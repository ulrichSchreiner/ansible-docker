FROM alpine:3.3
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apk add --update \
	build-base \
	ca-certificates \
	krb5-dev \
	openssh \
	openssl \
	py-pip \
	python \
	python-dev \
	sshpass

ENV ANSIBLE_VERSION 2.0.1.0
ENV WINRM_MIN_VERSION 0.1.1
ENV KERBEROS_VERSION 1.2.2

RUN 	pip install "ansible==$ANSIBLE_VERSION" && \
	pip install "pywinrm>=$WINRM_MIN_VERSION" && \
	pip install "kerberos==$KERBEROS_VERSION"

VOLUME /work
WORKDIR /work

ENV  ANSIBLE_HOST_KEY_CHECKING False
COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
