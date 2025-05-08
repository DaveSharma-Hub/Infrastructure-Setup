FROM ubuntu

RUN wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN sudo apt update && sudo apt install terraform

RUN sudo apt update
RUN sudo apt install unzip curl -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN sudo ./aws/install

RUN sudo apt update
RUN sudo apt install git

WORKDIR /opt/app

COPY . /opt/app/

ENV AWS_ACCOUNT_ID=
ENV AWS_REGION=
ENV YOUR_ACCESS_KEY=
ENV YOUR_SECRET_KEY=
ENV SERVER_NAME=
ENV GITHUB_LINK=
ENV DOCKERFILE_PATH=
ENV CONTAINER_PORT=

ENTRYPOINT [ "./setup.sh ${AWS_ACCOUNT_ID} ${AWS_REGION} ${YOUR_ACCESS_KEY} ${YOUR_SECRET_KEY} ${SERVER_NAME} ${GITHUB_LINK} ${DOCKERFILE_PATH} ${CONTAINER_PORT}" ]