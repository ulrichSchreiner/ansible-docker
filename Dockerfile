FROM alpine:3
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apk add --update \
	build-base \
	ca-certificates \
	cargo \
	curl \
	git \
	krb5-dev \
	libffi-dev \
	openssh \
	openssl \
	openssl-dev \
	python3 \
	python3-dev \
	py3-dnspython \
	py3-pip \
	py3-passlib \
	rsync \
	rust \
	sshpass \
	sudo \
	unzip \
	&& rm -rf /var/cache/apk/*

ENV ANSIBLE_VERSION=6.0.0 \
    ROLEPATH=/ansible/roles \
    ANSIBLE_ROLES_PATH=/ansible/roles:$ANSIBLE_ROLES_PATH \
    ANSIBLE_HOST_KEY_CHECKING=False

RUN pip3 install "ansible==$ANSIBLE_VERSION"
RUN ansible-galaxy collection install -p /usr/share/ansible/collections kewlfft.aur

VOLUME /work
WORKDIR /work

COPY entry.sh /entry.sh
copy ansible.cfg /etc/ansible/ansible.cfg

ENTRYPOINT ["/entry.sh"]
