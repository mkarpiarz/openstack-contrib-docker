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

RUN git config --system user.name "$GIT_USERNAME"
RUN git config --system user.email $GIT_EMAIL
RUN git config --system gitreview.username $GERRIT_USERNAME

RUN ssh-keyscan review.opendev.org >> /etc/ssh/ssh_known_hosts

# Non-root user inside the container
ARG DOCKER_USER=contributor
ARG DOCKER_UID=1000
ARG DOCKER_GID=1000

RUN addgroup --gid $DOCKER_GID $DOCKER_USER
RUN adduser --uid $DOCKER_UID --gid $DOCKER_GID $DOCKER_USER

# editor for reno
ENV EDITOR=/usr/bin/vim

# vim config
COPY vimrc /home/$DOCKER_USER/.vimrc

# git config (if exists)
COPY gitconfig* /home/$DOCKER_USER/.gitconfig

RUN chown -R $DOCKER_UID:$DOCKER_GID /home/$DOCKER_USER/

WORKDIR /repo

USER $DOCKER_USER

RUN mkdir /home/$DOCKER_USER/.ssh
RUN chmod -R 700 /home/$DOCKER_USER/.ssh
