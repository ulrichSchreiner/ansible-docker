FROM alpine:3.7
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
	rsync \
	sshpass \
	sudo \
	&& rm -rf /var/cache/apk/*

ENV ANSIBLE_VERSION 2.6.0.0
ENV BOTO_VERSION 2.48.0
ENV WINRM_VERSION 0.3.0
ENV KERBEROS_VERSION 1.2.5

RUN 	pip install --upgrade pip && \
	pip install "ansible==$ANSIBLE_VERSION" --no-binary :all: && \
	pip install "boto==$BOTO_VERSION" "pywinrm==$WINRM_VERSION" "kerberos==$KERBEROS_VERSION" netaddr

VOLUME /work
WORKDIR /work

ENV  ANSIBLE_HOST_KEY_CHECKING False
COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
