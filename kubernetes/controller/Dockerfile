FROM ubuntu


RUN apt-get update && apt-get install -y curl gnupg apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

CMD kubectl config set-cluster default --server=https://kubernetes.default --certificate-authority=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt && kubectl config set-context default --cluster=default && token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) && kubectl config set-credentials user --token=$token && kubectl config set-context default --user=user && kubectl config use-context default && /bin/bash