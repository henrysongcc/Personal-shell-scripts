#!/bin/bash

TEMPDIR=/tmp/
PROJECTNAME=rally-testes

# Sourcing the variables file
source /root/admin-openrc.sh

# Listing only the $PROJECTNAME volumes
openstack volume list --project $PROJECTNAME | grep -v "ID" | grep "^| " | awk '{print $2}' > "$tempdir/volumes-$PROJECTNAME"

# Removing all volumes from $PROJECTNAME
while read volume
do
	cinder reset-state $volume
        cinder delete $volume
        echo "Removing Volume $volume  ..."
        sleep 1
done < $tempdir/volumes-$PROJECTNAME

# Getting rid of the evidence
rm $tempdir/volumes-$PROJECTNAME
