#!/bin/bash

set -euo pipefail

function ok()
{
	echo "  OK"
}

function fail()
{
	echo "  FAIL"
	exit 1
}

echo "Checking whether all services are running..."
if [ "$DISABLE_SSH" -eq 0 ] ; then
  if [[ "$( sv status sshd )" =~ down ]]; then
    fail
  else
    ok
  fi
  if sv status sshd 2>&1 > /dev/null ; then
    ok
  else
    fail
  fi
else
  if sv status sshd 2>&1 > /dev/null ; then
    fail
  else
    ok
  fi
fi
if [ "$DISABLE_CRON" -eq 0 ] ; then
  if [[ "$( sv status cron )" =~ down ]]; then
    fail
  else
    ok
  fi
  if sv status cron 2>&1 > /dev/null ; then
    ok
  else
    fail
  fi
else
  if sv status cron 2>&1 > /dev/null ; then
    fail
  else
    ok
  fi
fi
