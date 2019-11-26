#!/bin/bash

# Buffer file
BFILE="/tmp/current-vms.txt"

# Remove any duplicates from the buffer file
rm -rf $BFILE

# XML path
mkdir -p /root/kvm-images
XMLs="/root/kvm-images/"

# Dump all current used VMs on this hypervisor
virsh list | grep -e "running\|executando" | awk '{ print $2; }' > $BFILE

while read vm
do
	echo "DUMPING $vm"
	virsh dumpxml $vm > "$XMLs$vm.xml"
done < $BFILE

# Removing leftovers
rm -rf $BFILE
