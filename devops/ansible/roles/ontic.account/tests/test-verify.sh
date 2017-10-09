#!/bin/bash

# Verify the user and group exists.
docker exec --tty ${container_id} env TERM=xterm awk -v val=1333 -F ":" '$3==val{print "Group: "$1" (1333)"}' /etc/group
docker exec --tty ${container_id} env TERM=xterm awk -v val=1444 -F ":" '$3==val{print "User: "$1" (1444)"}' /etc/passwd