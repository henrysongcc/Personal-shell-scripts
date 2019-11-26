#!/bin/bash

while read JOBID
do
        echo $JOBID
done < /tmp/jobids.txt

