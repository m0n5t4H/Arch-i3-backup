#!/bin/sh

ip=unknown

trap "toggle" USR1
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

main() {
  i=0

  while true; do
    ((i++ % 60)) || { update_ip; i=1; }
    update
    sleep 1
  done
}

toggle() {
  color=de935f ; update_bar
  if (($retval)) ; then
    nordvpn c > /dev/null 2>&1
  else
    nordvpn d > /dev/null 2>&1
  fi
}

update() {
  nordvpn status | grep -q 'Status: Connected' 
  retval=$?
  test $retval -ne ${retval_prev:-2} && update_ip
  retval_prev=$retval

  if (($retval)) ; then
    color=cc241d
  else
    color=689d6a
  fi

  update_bar
}

update_ip() { 
  ip=$(curl -4 -sf ifconfig.co) || ip=unknown
}

update_bar() {
  echo "$ip"
}

main $*
