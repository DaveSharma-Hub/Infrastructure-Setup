## About
Server deployment infrastructure to run the desired server-side application. Will create an ecs fargate task attached with an application load balancer with an exposed HTTP DNS. Provide your aws account id, desired deployment region, transient access and secret key, unique server name, github link with the path to the docker image and the container port to expose the backend application apis. 

## How to run

### Using Dockerfile to run

Provide the runtime environment variables

```
docker build -t <DOCKERFILE_TAG> .

docker run \ 
    -e AWS_ACCOUNT_ID=<AWS_ACCOUNT_ID> \
    -e AWS_REGION=<AWS_REGION> \
    -e YOUR_ACCESS_KEY=<YOUR_ACCESS_KEY> \
    -e YOUR_SECRET_KEY=<YOUR_SECRET_KEY> \
    -e SERVER_NAME=<SERVER_NAME> \
    -e GITHUB_LINK=<GITHUB_LINK> \
    -e DOCKERFILE_PATH=<DOCKERFILE_PATH> \
    -e CONTAINER_PORT=<CONTAINER_PORT> \
    <DOCKERFILE_TAG>
```