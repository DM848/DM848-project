FROM ubuntu


RUN apt-get update
RUN apt-get install --assume-yes git

#RUN git clone https://github.com/DM848/DM848-project.git
#

ADD jolie_deployer.ol .
ADD jolie_deployer_interface.iol .
ADD cloud_server_iface.iol .

#WORKDIR DM848-project/src/jolie_deployer

RUN apt-get install -y curl gnupg apt-transport-https wget
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install default-jre-headless

RUN apt-get install unzip
RUN wget https://www.jolie-lang.org/files/releases/jolie-1.7.0.jar
RUN java -jar jolie-1.7.0.jar -jh /usr/lib/jolie -jl /usr/bin
RUN echo 'export JOLIE_HOME="/usr/lib/jolie"' >> ~/.bash_profile

ENV JOLIE_HOME /usr/lib/jolie



CMD kubectl config set-cluster default --server=https://kubernetes.default --certificate-authority=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt && kubectl config set-context default --cluster=default && token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) && kubectl config set-credentials user --token=$token && kubectl config set-context default --user=user && kubectl config use-context default && jolie jolie_deployer.ol