FROM alpine:3.10
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
	python3 \
	python3-dev \
	rsync \
	sshpass \
	sudo \
	unzip \
	&& rm -rf /var/cache/apk/*

ENV ANSIBLE_VERSION=2.9.2 \
    BOTO_VERSION=2.49.0 \
    WINRM_VERSION=0.3.0 \
    KERBEROS_VERSION=1.3.0 \
    MITOGEN_VERSION=0.2.9

ENV ANSIBLE_STRATEGY_PLUGINS=/mitogen-${MITOGEN_VERSION}/ansible_mitogen/plugins/strategy \
    ANSIBLE_TRANSFORM_INVALID_GROUP_CHARS=ignore \
    MITOGEN_TAG=v${MITOGEN_VERSION}

RUN curl -L "https://github.com/dw/mitogen/archive/$MITOGEN_TAG.tar.gz" | \
		tar xzv -C / && \
		pip3 install --upgrade pip && \
    pip3 --no-cache-dir install "ansible==$ANSIBLE_VERSION" \
	     "boto==$BOTO_VERSION" \
	     "pywinrm==$WINRM_VERSION" \
	     "kerberos==$KERBEROS_VERSION" \
	     netaddr && \
    git clone https://github.com/kewlfft/ansible-aur.git /usr/share/ansible/plugins/modules/aur

VOLUME /work
WORKDIR /work

ENV  ANSIBLE_HOST_KEY_CHECKING False
COPY entry.sh /entry.sh
copy ansible.cfg /etc/ansible/ansible.cfg

ENTRYPOINT ["/entry.sh"]
