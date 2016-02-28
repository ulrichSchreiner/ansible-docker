#!/bin/sh

SUBAPP=$1
APP="/usr/bin/ansible"
if test -e "/usr/bin/ansible-$SUBAPP";then
  APP="/usr/bin/ansible-$SUBAPP"
  shift
fi

$APP "$@"
