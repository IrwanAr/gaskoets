#!/bin/bash

# go to root
cd

# userlist
clear
echo "-------------------------------"
echo "USERNAME        TANGGAL EXPIRED"
echo "-------------------------------"
while read Irwan Ardana
do
        AKUN="$(echo $Irwan Ardana | cut -d: -f1)"
        ID="$(echo $Irwan Ardana | grep -v nobody | cut -d: -f3)"
        exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
        if [[ $ID -ge 500 ]]; then
        printf "%-17s %2s\n" "$AKUN" "$exp"
                fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 500 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo "-------------------------------"
echo "Jumlah akun: $JUMLAH user"
echo "-------------------------------"
echo -e "Script by \e[1;33;44m[ Irwan Ardana@337 ]\e[0m"

# userlog
clear
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "Checking User Login";
echo "=================================";

for PID in "${data[@]}"
do
    #echo "check $PID";
    NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
    USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
    IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
    if [ $NUM -eq 1 ]; then
        echo "$PID - $USER - $IP";
    fi
done
echo "---";

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);


for PID in "${data[@]}"
do
        #echo "check $PID";
        NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
        IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
        fi
done
echo "-------------------------------"
echo -e "Script by \e[1;33;44m Irwan Ardana@337 \e[0m"

# usernew
clear
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "Informasi SSH"
echo -e "=========-account-=========="
echo -e "Host: $IP"
echo -e "Port: 443 109 110"
echo -e "Username: $Login "
echo -e "Password: $Pass"
echo -e "-----------------------------"
echo -e "Aktif Sampai: $exp"
echo -e "==========================="
echo -e "Script by \e[1;33;44mIrwan Ardana@337\e[0m"

# trial
clear
Login=trial
masaaktif="1"
Pass=trial
IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "Host: $IP"
echo -e "Port: 443"
echo -e "Username: $Login "
echo -e "Password: $Pass\n"
echo -e ""
echo -e "Akun ini hanya aktif 1 hari"
echo -e "Script by \e[1;33;44mIrwan Ardana@337\e[0m"

# script
cd
chmod +x  /usr/bin/userlist
chmod +x  /usr/bin/userlog
chmod +x  /usr/bin/usernew
chmod +x  /usr/bin/trial


