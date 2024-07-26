# Will be using ubuntu as an example but can be updated to redhat
FROM ubuntu:20.04 

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    sshpass \
    openssh-client \
    sudo \
    vim \
    git && \
    apt-get clean

# Install Ansible
RUN pip3 install ansible

# Create Ansible directory
RUN mkdir -p /etc/ansible

# Copy Ansible inventory
COPY hosts /etc/ansible/hosts

# Copy Ansible playbook
COPY nginx.yaml /nginx.yaml

# Copy Ansible templates
COPY templates /templates

WORKDIR /

CMD ["ansible-playbook", "-i", "/etc/ansible/hosts", "nginx.yaml"]
