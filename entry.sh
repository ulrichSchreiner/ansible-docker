#!/bin/sh

SUBAPP=$1
APP="/usr/bin/ansible"
if test -e "/usr/bin/ansible-$SUBAPP";then
  APP="/usr/bin/ansible-$SUBAPP"
  shift
fi

USERID=$(stat -c '%u' /work)
GROUPID=$(stat -c '%g' /work)

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
  adduser -S -G $GROUPNAME -u $USERID $USERNAME

  chown ansible:ansible $SSH_AUTH_SOCK
  export HOME=/home/ansible
  sudo -u ansible -E $APP "$@"
fi
