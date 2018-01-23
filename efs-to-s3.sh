#!/bin/bash

# Prepare system for rsync
echo 'sudo yum -y install nfs-utils'
sudo yum -y install nfs-utils >> /tmp/file.txt 2>&1
echo 'sudo mkdir /backup'
sudo mkdir /backup >> /tmp/file.txt 2>&1

echo "sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $source /backup"
sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard fs-e753a6de.efs.ap-southeast-2.amazonaws.com:/ /backup >> /tmp/file.txt 2>&1

echo "sudo aws s3 sync /backup s3://data-pipeline-am/backup-1"
sudo aws s3 sync /backup s3://data-pipeline-am/backup-1 >> /tmp/file.txt 2>&1
syncStatus=$?
aws s3 cp /tmp/file.txt s3://data-pipeline-am/logs/
# echo "sudo aws s3 cp /tmp/efs-backup.log s3://datapipeline.elmodev.com/logs/$efsid-`date +%Y%m%d-%H%M`.log"
# sudo aws s3 mv /tmp/efs-backup.log s3://datapipeline.elmodev.com/logs/$efsid-`date +%Y%m%d-%H%M`.log
#sleep 300
exit $syncStatus
