#!/bin/bash

#source account login
echo "#!/bin/bash" > source-account-logon.sh
aws ecr get-login --profile <profile> --region us-east-1 >> source-account-logon.sh
./source-account-logon.sh

#dest account login
echo "#!/bin/bash" > dest-account-logon.sh
aws ecr get-login --profile <profile> --region us-east-1 > dest-account-logon.sh
./dest-account-logon.sh

#create tagged copies of un-tagged images in the source account repositories
for repo in `aws ecr --region=us-east-1 describe-repositories --profile <profile> | grep 'repositoryName' | gawk -F[\"] '{IRS=",\n"; ORS="\n"}{print $4}'`; do aws ecr --region us-east-1 --profile <profile> list-images --repository-name $repo --query 'imageIds[?type(imageTag)!=`string`].[imageDigest]' --output text | while read imgd; do \
manifest=$(aws ecr batch-get-image --repository-name $repo --image-ids imageDigest="$imdg" --query 'images[].imageManifest' --output text --profile <profile> --region us-east-1); \
aws ecr put-image --repository-name $repo --image-tag untagged1 --image-manifest "$manifest" --profile <profile> --region us-east-1
done; done;

#ECR migration from source to destination account
for repo in `aws ecr --region=us-east-1 describe-repositories --profile <profile> | grep 'repositoryName' | gawk -F[\"] '{IRS=",\n"; ORS="\n"}{print $4}'`;  do for image in `aws ecr --region us-east-1 --profile <profile> list-images --repository-name $repo | grep imageTag | gawk -F[\"] '{print $4}'`;  do aws ecr describe-images --repository-name=<repo-name> --image-ids=imageTag=$repo-$image --profile default --region us-east-1 --query 'imageDetails[0].imageTags[0]'; if [ $? != 0 ]; then docker pull 403543998317.dkr.ecr.us-east-1.amazonaws.com/$repo:$image; docker tag 403543998317.dkr.ecr.us-east-1.amazonaws.com/$repo:$image 661072482170.dkr.ecr.us-east-1.amazonaws.com/<repo-name>:$repo-$image;  docker push 661072482170.dkr.ecr.us-east-1.amazonaws.com/<repo-name>:$repo-$image;  docker rmi 403543998317.dkr.ecr.us-east-1.amazonaws.com/$repo:$image;  docker rmi 661072482170.dkr.ecr.us-east-1.amazonaws.com/<repo-name>:$repo-$image; fi; done; done
