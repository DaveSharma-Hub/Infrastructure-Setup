#!/bin/bash

LOCAL_DOCKER_TAG=$1
ACCOUNT_ID=""
CLOUD_CLOUD_REPO_NAME=""
REGIONS="us-east-1 us-west-1"

if [ -z $LOCAL_DOCKER_TAG ]; then
    echo "Please provide a local docker tag"
    exit 1
fi

function tag_and_publish(){
    local REGION=$1
    ECR_REPO="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$CLOUD_REPO_NAME:latest"
    
    docker tag $LOCAL_DOCKER_TAG $ECR_REPO

    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

    docker push $ECR_REPO
}

function publish_in_all_regions(){
    for REGION in $REGIONS; do
        tag_and_publish "$REGION"
    done
}

publish_in_all_regions