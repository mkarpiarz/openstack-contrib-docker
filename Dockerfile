FROM ubuntu:24.04

RUN apt update
RUN apt install -y \
    git \
    wget \
    curl \
    vim \
    git-review \
    python3-reno
RUN apt clean all

# The first and last name of the contributor
ARG GIT_USERNAME
ENV GIT_USERNAME=$GIT_USERNAME
# Email address of the contributor
ARG GIT_EMAIL
ENV GIT_EMAIL=$GIT_EMAIL
# Username in gerrit
ARG GERRIT_USERNAME
ENV GERRIT_USERNAME=$GERRIT_USERNAME

RUN git config --global user.name $GIT_USERNAME
RUN git config --global user.email $GIT_EMAIL
RUN git config --global gitreview.username $GERRIT_USERNAME

RUN ssh-keyscan review.opendev.org >> /etc/ssh/ssh_known_hosts

# editor for reno
ENV EDITOR=/usr/bin/vim

# vim config
COPY vimrc /root/.vimrc

WORKDIR /repo
