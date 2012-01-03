#!/bin/bash

# Andrew Burnheimer
# abrhir@email.com
# 22 Dec 2011

ALT_USER=brhie
DOMAIN_SUFFIX=work.suffix

lflag=false
nflag=false

set -- $(getopt hln "$@")
while [ $# -gt 0 ]
do
    case "$1" in
    (-h|-l)
      lflag=true
      ;;
    (-n)
      nflag=true
      ;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" >&2; exit 1;;
    (*)  break;;
    esac
    shift
done

#           ccp  c  a  p-  p  o    -   c     0       0  1-        p     -    1
HOST_MATCH="^ccp[a-z]{3}-([a-z]{2})-[a-z][a-z0-9][0-9]{2}-(d|q|qi|i|s|p)(-[0-9])?$"
host=$1

if [[ $host =~ $HOST_MATCH ]]; then
  data_center=${BASH_REMATCH[1]}
  case $data_center in
  dt|ra)
    user=$ALT_USER
    ;;
  *)
    user=$(whoami)
    ;;
  esac

else # REGEX error handling
  case $? in
  1)
    rv=$?
    echo "Hostname does not match pattern: $host" >&2
    exit $rv
    ;;
  2)
    rv=$?
    echo "Regular expression is syntactically incorrect" >&2
    exit $rv
    ;;
  *)
    rv=$?
    echo "Another error $rv occured with regex match" >&2
    exit $rv
    ;;
  esac
fi

if [[ $lflag == true ]]; then
  echo $user@$host.$data_center.$DOMAIN_SUFFIX

elif [[ $nflag == true ]]; then
  echo $host.$data_center.$DOMAIN_SUFFIX

else # Most often
  ssh -l $user $host.$data_center.$DOMAIN_SUFFIX
fi


# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
