#!/bin/bash

AWS_ACCOUNT_ID=$0
AWS_REGION=$1
YOUR_ACCESS_KEY=$2
YOUR_SECRET_KEY=$3
SERVER_NAME=$4
GITHUB_LINK=$5
DOCKERFILE_PATH=$6
CONTAINER_PORT=$7

aws configure set aws_access_key_id $YOUR_ACCESS_KEY && \
aws configure set aws_secret_access_key $YOUR_SECRET_KEY && \
aws configure set region $AWS_REGION

pushd s3-upload
terraform init 
terraform apply -auto-approve \
    -var="server_name=$SERVER_NAME"

popd
pushd ecr-upload

sed -i 's/<REGION>/$AWS_REGION/g' provider.tf
terraform init
terraform apply -auto-approve \
    -var="account_id=$AWS_ACCOUNT_ID" \
    -var="server_name=$SERVER_NAME" \
    -var="aws_region=$AWS_REGION"

popd
git clone $GITHUB_LINK ./server
pushd server/$DOCKERFILE_PATH

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

DOCKER_TAG="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVER_NAME:latest"
docker build -t $DOCKER_TAG .
docker push $DOCKER_TAG

popd

sed -i 's/<REGION>/$AWS_REGION/g' provider.tf
terraform init
terraform apply -auto-approve \
    -var="account_id=$AWS_ACCOUNT_ID" \
    -var="server_name=$SERVER_NAME" \
    -var="aws_region=$AWS_REGION" \
    -var="image_tag=$DOCKER_TAG" \
    -var="container_port=$CONTAINER_PORT"
