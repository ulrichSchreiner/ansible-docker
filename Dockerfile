FROM alpine:3.8
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apk add --update \
	build-base \
	ca-certificates \
	curl \
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
	unzip \
	&& rm -rf /var/cache/apk/*

ENV ANSIBLE_VERSION 2.6.1.0
ENV BOTO_VERSION 2.48.0
ENV WINRM_VERSION 0.3.0
ENV KERBEROS_VERSION 1.2.5

RUN 	pip install --upgrade pip && \
	pip install "ansible==$ANSIBLE_VERSION" --no-binary :all: && \
	pip install "boto==$BOTO_VERSION" "pywinrm==$WINRM_VERSION" "kerberos==$KERBEROS_VERSION" netaddr && \
	curl -sSL https://github.com/dw/mitogen/archive/stable.zip > /tmp/stable.zip && \
	mkdir /mitogen && \
	unzip /tmp/stable.zip -d /mitogen


VOLUME /work
WORKDIR /work

ENV  ANSIBLE_HOST_KEY_CHECKING False
COPY entry.sh /entry.sh
copy ansible.cfg /etc/ansible/ansible.cfg

ENTRYPOINT ["/entry.sh"]
