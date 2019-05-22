#!/bin/bash

/usr/local/bin/aws ec2 describe-instances --profile <profile> --region us-east-1 --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value[], PrivateIpAddress]" --filters 'Name=tag:Name,Values=*tag*' | grep -e \"*\" | sed -e 's/\"//g'| awk '{$1=$1;print}' | awk '{ORS = (NR%2? ",":RS)}1' > /home/ubuntu/metrics/instances_list

curr_time=$(date +%s)
curr_date=$(date +%m%d%y)
while read create_time
do
time_diff=$(( (curr_time - create_time) / (24*3600) ))
if [[ $time_diff -ge 7 ]]
then
[ -d "/home/ec2-user/metrics/backup" ] && find /home/ec2-user/metrics -type f -name '*.csv' -print0 -maxdepth 1 | xargs --null -I{} cp {} {}_$curr_date
find /home/ubuntu/metrics -type f -name *_$curr_date -print0 -maxdepth 1 | xargs --null -I{} mv -f {} /home/ubuntu/metrics/backup/
fi
done < /home/ubuntu/metrics/timer

mv /home/ubuntu/metrics/timer /home/ubuntu/metrics/backup/timer_$curr_date
echo $curr_time > /home/ubuntu/metrics/timer

while read i
do
    ser_name=$(echo $i | cut -d"," -f1)
    ser_ip=$(echo $i | cut -d"," -f2)
    if [[ $ser_name =~ "bastion" ]]
    then
        bash /home/ubuntu/metrics/metrics_calculation.sh >> /home/ubuntu/metrics/${ser_name}-${ser_ip}.csv 2>&1
    elif [[ $ser_name =~ "public" ]]
    then
        continue
    else
       cat /home/ubuntu/metrics/metrics_calculation.sh | ssh -q -i /home/ubuntu/metrics/metrics.pem ec2-user@$ser_ip >> /home/ubuntu/metrics/${ser_name}-${ser_ip}.csv 2>&1
    fi
done < /home/ubuntu/metrics/instances_list
