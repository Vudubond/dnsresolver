#!/usr/bin/env bash
#
# dns speed test
#
DIGGER="dig"
if ! $DIGGER > /dev/null ; then
    DIGGER="drill"
    if ! $DIGGER > /dev/null ; then
        echo "No capable digger found"
        exit 1
    fi
fi
if [[ -z "$DOMAIN" ]]; then
    DOMAIN=google.com
fi;
CURRENTDNS=$("${DIGGER}" "$DOMAIN" | grep SERVER | awk -F'[)(]' '{print $2}')
if [[ -z "$SKIP" ]]; then
    echo
    echo " Test common resolvers by calculating average response times of 3 queries."
    echo
    annc() {
        echo
        echo " DNS Primary  Secondary"
        echo
        echo " AdGuard 94.140.14.14 94.140.15.15"
        echo " CleanBrowsing 185.228.168.9 185.228.169.9"
        echo " Cloudflare 1.1.1.1 1.0.0.1"
        echo " Control-D 76.76.2.2 76.76.10.2"
        echo " Gcore 95.85.95.85 2.56.220.2"
        echo " Google 8.8.8.8 8.8.4.4"
        echo " Neustar 156.154.70.2 156.154.71.2"
        echo " NextDNS 45.90.28.105 45.90.30.105"
        echo " OpenDNS 208.67.222.222 208.67.220.220"
        echo " Quad9 9.9.9.9 149.112.112.112"
        echo "a.root-servers.net. 198.41.0.4"
        echo "b.root-servers.net. 199.9.14.201"
        echo "c.root-servers.net. 192.33.4.12"
        echo "d.root-servers.net. 199.7.91.13"
        echo "e.root-servers.net. 192.203.230.10"
        echo "f.root-servers.net. 192.5.5.241"
        echo "g.root-servers.net. 192.112.36.4"
        echo "h.root-servers.net. 198.97.190.53"
        echo "i.root-servers.net. 192.36.148.17"
        echo "j.root-servers.net. 192.58.128.30"
        echo "k.root-servers.net. 193.0.14.129"
        echo "l.root-servers.net. 199.7.83.42"
        echo "m.root-servers.net. 202.12.27.33"
        echo
        if [[ -n "$TESTDNS" ]]; then
            echo "Custom $TESTDNS"
        fi
    }
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    annc | column -t
fi;
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo
while true; do
    read -p " Do you wish to flush the DNS cache? " yn
    case $yn in
        [Yy]* ) if systemctl is-active systemd-resolved.service > /dev/null ; then
                    resolvectl flush-caches > /dev/null ;
                elif systemctl is-active named.service > /dev/null ; then
                    rndc reload > /dev/null ;
                elif systemctl is-active dnsmasq.service > /dev/null ; then
                    systemctl restart dnsmasq.service > /dev/null ;
                else echo -e "\n No service found.\n" ;
                fi ; break ;;
        [Nn]* ) break ;;
        * ) echo -e "\n Please answer yes or no.\n" ;;
    esac
done
echo
echo "Current DNS $CURRENTDNS"
for reps in {1..3}
do
    "${DIGGER}" "$DOMAIN" | awk '/time/ {print $4 " ms"}'
    sleep 1
done | awk '/ms/ {sum+=$1} END {print "Avg time: ",sum/3, " ms"}'
echo
if [[ -z "$SKIP" ]]; then
    rank() {
        for resolver in "AdGuard 94.140.14.14" "CleanBrowsing 185.228.168.9" "Cloudflare 1.1.1.1" "Control-D 76.76.2.2" "Gcore 95.85.95.85" "Google 8.8.8.8" "Neustar 156.154.70.2" "NextDNS 45.90.28.105" "OpenDNS 208.67.222.222" "Quad9 9.9.9.9" "a.root-servers.net. 198.41.0.4" "b.root-servers.net. 199.9.14.201" "c.root-servers.net. 192.33.4.12" "d.root-servers.net. 199.7.91.13" "e.root-servers.net. 192.203.230.10" "f.root-servers.net. 192.5.5.241" "g.root-servers.net. 192.112.36.4" "h.root-servers.net. 198.97.190.53" "i.root-servers.net. 192.36.148.17" "j.root-servers.net. 192.58.128.30" "k.root-servers.net. 193.0.14.129" "l.root-servers.net. 199.7.83.42" "m.root-servers.net. 202.12.27.33";
        do
            echo "$resolver"
            for reps in {1..3}
            do
                "${DIGGER}" "$DOMAIN" "@${resolver#* }" | awk '/time/ {print $4 " ms"}'
                sleep 0.01
            done | awk '/ms/ {sum+=$1} END {print "Avg time: ",sum/3, " ms"}'
            echo
        done
    }
    rank;
fi;
if [[ -n "$TESTDNS" ]]; then
    echo "Custom Test DNS $TESTDNS"
    for reps in {1..3}
    do
        "${DIGGER}" "$DOMAIN" "@$TESTDNS" | awk '/time/ {print $4 " ms"}'
        sleep 0.01
    done | awk '/ms/ {sum+=$1} END {print "Avg time: ",sum/3, " ms"}'
    echo
fi
exit
