FROM alpine:3.4
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apk add --update \
	build-base \
	ca-certificates \
	git \
	krb5-dev \
	libffi-dev \
	openssh \
	openssl \
	openssl-dev \
	py-pip \
	python \
	python-dev \
	sshpass \
	sudo \
	&& rm -rf /var/cache/apk/*

ENV ANSIBLE_VERSION 2.1.2.0
ENV WINRM_MIN_VERSION 0.2.0
ENV KERBEROS_VERSION 1.2.2

RUN 	pip install --upgrade pip && \
	pip install "ansible==$ANSIBLE_VERSION" && \
	pip install "pywinrm>=$WINRM_MIN_VERSION" && \
	pip install "kerberos==$KERBEROS_VERSION" 

VOLUME /work
WORKDIR /work

ENV  ANSIBLE_HOST_KEY_CHECKING False
COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
