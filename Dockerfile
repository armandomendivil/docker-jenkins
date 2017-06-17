FROM jenkins:latest
#1.642.1
MAINTAINER Jonathan Klingberg <jonathan.klingberg@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

USER root

ARG DOCKER_GID=497

RUN groupadd -g ${DOCKER_GID:-497} docker

ARG DOCKER_ENGINE=1.10.2
ARG DOCKER_COMPOSE=1.6.2

RUN apt-get update -y && \
    apt-get install apt-transport-https curl python-dev python-setuptools gcc make libssl-dev -y && \
    easy_install pip

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
  echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list && \
  apt-get update -y && \
  apt-get purge lxc-docker* -y && \
  apt-get install docker-engine=${DOCKER_ENGINE:-1.10.2}-0~trusty -y && \
  usermod -aG docker jenkins && \
  usermod -aG users jenkins

RUN pip install docker-compose==${DOCKER_COMPOSE:-1.6.2} && \
    pip install ansible boto boto3

USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt | tr '\n' ' ')
