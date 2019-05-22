#!/usr/bin/env bash

normal_exec(){
count=$(AWS_ACCESS_KEY_ID=${which_access} AWS_SECRET_ACCESS_KEY=${which_secret} /usr/local/bin/aws ec2 describe-instances --region ${region} --query "Reservations[*].Instances[*].[State.Name]" | grep "running" | wc -w)
inst_details=$(AWS_ACCESS_KEY_ID=${which_access} AWS_SECRET_ACCESS_KEY=${which_secret} /usr/local/bin/aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value[]|[0], PrivateIpAddress, State.Name]" | grep "running" -B2 | grep -v "running" |grep -e "null" -e '\"*\"' | awk '{$1=$1;print}'|sed -e 's/\"//g'|awk '{ORS = (NR%2? "":RS)}1'|sed -e 's/,/-/g'| awk '{ORS=";\n";print}')
arr+=(,${count},${inst_details})
}

assume_role_exec(){
creds=$(AWS_ACCESS_KEY_ID=${add_AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${add_AWS_SECRET_ACCESS_KEY} aws sts assume-role --role-arn <role-arn> --role-session-name test --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]'|grep "\"" | awk '{$1=$1}1')
access=$(echo $creds | cut -d"," -f1 | sed 's/\"//g')
secret=$(echo $creds | awk -F", " '{print $2}'| sed 's/\"//g')
token=$(echo $creds | awk -F", " '{print $3}'| sed 's/\"//g')
export AWS_ACCESS_KEY_ID=${access}
export AWS_SECRET_ACCESS_KEY=${secret}
export AWS_SESSION_TOKEN=${token}
count=$(/usr/local/bin/aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[State.Name]" | grep "running" | wc -w)
inst_details=$(/usr/local/bin/aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value[]|[0], PrivateIpAddress, State.Name]" | grep "running" -B2 | grep -v "running" |grep -e "null" -e '\"*\"' | awk '{$1=$1;print}'|sed -e 's/\"//g'|awk '{ORS = (NR%2? "":RS)}1'|sed -e 's/,/-/g'| awk '{ORS=";\n";print}')
arr+=(,${count},${inst_details})
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
}

arr=($(date +%D),$(date +%T))
while read environment
do
prof=$(echo $environment | cut -d"," -f1)
env=$(echo $environment | cut -d"," -f1 | cut -d"-" -f2)
region=$(echo $environment | cut -d"," -f2)
if [ $env == "dev" ] 
then 
echo $prof-$region
which_access=${dev_AWS_ACCESS_KEY_ID}
which_secret=${dev_AWS_SECRET_ACCESS_KEY}
normal_exec
elif [ $prof == "profile1" ]
then 
echo $prof-$region
assume_role_exec
elif [ $prof == "profile2" ]
then
echo $prof-$region
which_access=${add_AWS_ACCESS_KEY_ID}
which_secret=${add_AWS_SECRET_ACCESS_KEY}
normal_exec
else
echo $prof-$region
which_access=${prod_AWS_ACCESS_KEY_ID}
which_secret=${prod_AWS_SECRET_ACCESS_KEY}
normal_exec
fi
done <<EOF
profile-prod,us-east-1
profile-prod,eu-west-1
profile-prod,ap-northeast-1
profile-dev,us-east-1
profile1, us-east-1
profile2, us-east-1
EOF
echo ${arr[@]}
#echo ${arr[@]}>> instance_count_$(date +%d%m%y).csv
echo ${arr[@]}>> instance_count_$(date +%B).csv
