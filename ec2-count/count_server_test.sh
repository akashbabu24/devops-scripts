#!/usr/bin/env bash

arr=($(date +%D),$(date +%T))
while read environment
do
prof=$(echo $environment | cut -d"," -f1)
#env=$(echo $environment | cut -d"," -f2)
region=$(echo $environment | cut -d"," -f2)
count=$(/usr/local/bin/aws ec2 describe-instances --profile ${prof} --region ${region} --query "Reservations[*].Instances[*].[State.Name]" | grep "running" | wc -w)

inst_details=$(/usr/local/bin/aws ec2 describe-instances --region us-east-1 --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value[]|[0], PrivateIpAddress, State.Name]" | grep "running" -B2 | grep -v "running" |grep -e "null" -e '\"*\"' | awk '{$1=$1;print}'|sed -e 's/\"//g'|awk '{ORS = (NR%2? "":RS)}1'|sed -e 's/,/-/g'| awk '{ORS=";\n";print}')

arr+=(,${count},${inst_details})
#aws ec2 describe-instances --profile ${prof} --region us-east-1 --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value[], PrivateIpAddress, State.Name]"
#aws ec2 describe-instances --profile ${prof} --region ${region} --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value[], PrivateIpAddress]" --filters 'Name=tag:Name,Values=*${env}*' | grep -e \"*\" | sed -e 's/\"//g'| awk '{$1=$1;print}' | awk '{ORS = (NR%2? ",":RS)}1' >
done <<EOF
account1,us-east-1
account2,eu-west-1
account3,ap-northeast-1
account4,us-east-1
EOF
echo ${arr[@]} >> /home/ubuntu/instance_count/instance_count_$(date +%B).csv
