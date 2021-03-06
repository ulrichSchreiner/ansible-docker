#!/bin/sh

SUBAPP=$1
APP="/usr/bin/ansible"
if test -e "/usr/bin/ansible-$SUBAPP";then
  APP="/usr/bin/ansible-$SUBAPP"
  shift
fi

USERID=$(stat -c '%u' /work)
GROUPID=$(stat -c '%g' /work)

if [ x$ANSIBLE_VAULT_PASSWORD != 'x' ]; then
  echo $ANSIBLE_VAULT_PASSWORD >/vault
  chmod 644 /vault
  export ANSIBLE_VAULT_PASSWORD_FILE=/vault
fi


# check if work-directory is owned by root or another user.
# if another user, we create one with the correct UID/GID and run
# the command as this user. if the command creates a file it will belong
# to the same user as the owner of the mounted /work
if [ $USERID = '0' ]; then
  $APP "$@"
else
  USERNAME=ansible
  GROUPNAME=ansible

  addgroup -S -g $GROUPID $GROUPNAME

  echo "$USERNAME:x:$USERID:$USERID::/home/$USERNAME:" >> /etc/passwd
  echo "$USERNAME:!:$(($(date +%s) / 60 / 60 / 24)):0:99999:7:::" >> /etc/shadow
  echo "$USERNAME:x:$USERID:" >> /etc/group

  mkdir /home/$USERNAME
  chown ansible:ansible /home/$USERNAME
  if [ ! -z "$SSH_AUTH_SOCK" ]
  then
    chown ansible:ansible $SSH_AUTH_SOCK
  fi
  export HOME=/home/$USERNAME
  sudo -u ansible -E $APP "$@"
fi
