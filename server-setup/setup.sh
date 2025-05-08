#!/bin/bash

AWS_ACCOUNT_ID=$1
AWS_REGION=$2
YOUR_ACCESS_KEY=$3
YOUR_SECRET_KEY=$4
SERVER_NAME=$5
GITHUB_LINK=$6
DOCKERFILE_PATH=$7
CONTAINER_PORT=$8

function check_valid_argument(){
    ARGUMENT=$1
    if [[ -z "$ARGUMENT" ]];then
        echo "Invalid argument $ARGUMENT"
        exit 1
    fi
}

check_valid_argument "$AWS_ACCOUNT_ID"
check_valid_argument "$AWS_REGION"
check_valid_argument "$YOUR_ACCESS_KEY"
check_valid_argument "$YOUR_SECRET_KEY"
check_valid_argument "$SERVER_NAME"
check_valid_argument "$GITHUB_LINK"
check_valid_argument "$DOCKERFILE_PATH"
check_valid_argument "$CONTAINER_PORT"

RELEASE_BUCKET="custom-infrastructure-setup-release-bucket-$SERVER_NAME"

aws configure set aws_access_key_id $YOUR_ACCESS_KEY && \
aws configure set aws_secret_access_key $YOUR_SECRET_KEY && \
aws configure set region $AWS_REGION

pushd s3-upload
terraform init 
terraform apply -auto-approve \
    -var="aws_region=$AWS_REGION" \
    -var="release_bucket_name=$RELEASE_BUCKET"

popd
pushd ecr-upload

sed -i "s/<REGION>/${AWS_REGION}/g" provider.tf
sed -i "s/<RELEASE_BUCKET>/${RELEASE_BUCKET}/g" provider.tf
terraform init
terraform apply -auto-approve \
    -var="account_id=$AWS_ACCOUNT_ID" \
    -var="server_name=$SERVER_NAME" \
    -var="aws_region=$AWS_REGION"

popd
git clone $GITHUB_LINK ./server
pushd server/$DOCKERFILE_PATH
# pushd $DOCKERFILE_PATH

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

DOCKER_TAG="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVER_NAME:latest"
docker build -t $DOCKER_TAG .
docker push $DOCKER_TAG

popd

sed -i "s/<REGION>/${AWS_REGION}/g" provider.tf
sed -i "s/<RELEASE_BUCKET>/${RELEASE_BUCKET}/g" provider.tf

terraform init
terraform apply -auto-approve \
    -var="account_id=$AWS_ACCOUNT_ID" \
    -var="server_name=$SERVER_NAME" \
    -var="aws_region=$AWS_REGION" \
    -var="image_tag=$DOCKER_TAG" \
    -var="container_port=$CONTAINER_PORT"
