#!/bin/bash

# Andrew Burnheimer
# abrhir@email.com

ALT_USER=brhie
DOMAIN_SUFFIX=work.suffix

dflag=false
nflag=false
lflag=false
pflag=false
uflag=false

usage() {
  echo "Usage: $0 hostname"
  echo 
  echo "  -d     Log in with DT xdeploy credential"
  echo "  -h     Usage statement"
  echo "  -l     Return login string for hostname (useful for "
  echo "         SCP/SFTP pasting)"
  echo "  -p     Log in with PO xdeploy credential"
  echo "  -f,-n  Return FQDN string for hostname"
  echo "  -u     Log in to host with uid hostname"
  echo 
}

set -- $(getopt dfhlnpu "$@")
while [ $# -gt 0 ]
do
    case "$1" in
    (-d)
      dflag=true
      ;;
    (-f|-n)
      nflag=true
      ;;
    (-h)
      usage
      exit 0
      ;;
    (-l)
      lflag=true
      ;;
    (-p)
      pflag=true
      ;;
    (-u)
      uflag=true
      ;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" >&2; exit 1;;
    (*)  break;;
    esac
    shift
done

if [[ $uflag == true ]]; then
  #            vm-  32xvul9u    .dt
  HOST_MATCH="^vm-([0-9a-z]{8})\.([a-z]{2})$"
else
  #              ccp    c  a  p-  p  o    -   c     0       0  1-        p     -    1
  HOST_MATCH="^(ccp)?[a-z]{2,3}-([a-z]{2})-[a-z0-9]{0,5}(-)?(d|q|qi|i|s|p|e)(-[0-9])?$"
fi

host=$1

if [[ $host =~ $HOST_MATCH ]]; then
  data_center=${BASH_REMATCH[2]}

  if [[ $uflag == true ]]; then
    #            vm-  32xvul9u    .dt
    host="vm-${BASH_REMATCH[1]}"
  fi

  case $data_center in
  br)
    if [ -z ${BASH_REMATCH[1]} ]; then
      data_center="idk"
      user=$ALT_USER
    else
      user=$(whoami)
    fi
    ;;
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

sshopts=""

if [[ $dflag == true ]] || [[ $pflag == true ]] ; then
  user="xdeploy"
  if [[ $pflag == true ]]; then
    sshopts="$sshopts -i /Users/aburnh000/.ssh/id_dsa-po-xdeploy"
  else
    sshopts="$sshopts -i /Users/aburnh000/.ssh/id_dsa-dt-xdeploy"
  fi
fi

sshopts="$sshopts -l $user"

if [[ $data_center == "idk" ]]; then
  DOMAIN_SUFFIX=work.suffix
fi

if [[ $lflag == true ]]; then
  echo $user@$host.$data_center.$DOMAIN_SUFFIX

elif [[ $nflag == true ]]; then
  echo $host.$data_center.$DOMAIN_SUFFIX

else # Most often
  ssh $sshopts $host.$data_center.$DOMAIN_SUFFIX
fi


# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
