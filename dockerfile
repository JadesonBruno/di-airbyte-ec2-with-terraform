# Using official Ubuntu image
FROM ubuntu:latest

# Maintainer of the image
LABEL maintainer="jadesonbruno.a@outlook.com"

# Updating system packages and installing necessary dependencies
RUN apt-get update && \
    apt-get install -y \
        wget \
        unzip \
        curl \
        vim && \
    rm -rf /var/lib/apt/lists/*

# Defining the Terraform version
ENV TERRAFORM_VERSION=1.13.0

# Downloading and installing Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Creating the downloads directory and installing the AWS CLI (to access AWS)
RUN mkdir downloads && \
    cd downloads && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    rm awscliv2.zip && \
    ./aws/install

# Creating and Setting the working directory
WORKDIR /projects/di-airbyte-ec2-with-terraform

# Copying terraform directory to the /projects directory in the container
COPY . .

# Defining the default command to run when the container starts
CMD ["tail", "-f", "/dev/null"]
