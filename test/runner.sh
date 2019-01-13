#!/bin/bash
set -e

function abort()
{
	echo "$@"
	exit 1
}

function cleanup()
{
	echo " --> Stopping container"
	docker stop $ID >/dev/null
	docker rm $ID >/dev/null
}

PWD=`pwd`

echo " --> Starting container"
ID=$( docker run -d -p 22 -v $PWD/test:/test $NAME:$VERSION /sbin/my_init ) 
sleep 1

echo " --> Obtaining SSH port number"
SSHPORT=`docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' "$ID"`
if [[ "$SSHPORT" = "" ]]; then
	abort "Unable to obtain container SSH port number"
fi

trap cleanup EXIT

echo " --> Enabling SSH in the container"
docker exec -t -i $ID /etc/my_init.d/00_regen_ssh_host_keys.sh -f
docker exec -t -i $ID rm /etc/service/sshd/down
docker exec -t -i $ID sv start /etc/service/sshd
sleep 1

echo " --> Running tests in container"
sleep 1 # Give container some more time to start up.
docker exec -t -i $ID /bin/bash /test/test.sh
