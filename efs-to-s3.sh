#!/bin/bash
# Example would be to run this script as follows:
# Every 6 hours; retain last 4 backups
# efs-backup.sh $src $dst hourly 4 efs-12345
# Once a day; retain last 31 days
# efs-backup.sh $src $dst daily 31 efs-12345
# Once a week; retain 4 weeks of backup
# efs-backup.sh $src $dst weekly 7 efs-12345
# Once a month; retain 3 months of backups
# efs-backup.sh $src $dst monthly 3 efs-12345
#
# Snapshots will look like:
# $dst/$efsid/hourly.0-3; daily.0-30; weekly.0-3; monthly.0-2


# Input arguments
source=$1
#efsid=$2
S3DestinationPath=$2

# Prepare system for rsync
echo 'sudo yum -y install nfs-utils'
sudo yum -y install nfs-utils
echo 'sudo mkdir /backup'
sudo mkdir /backup

echo "sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $source /backup"
sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $source /backup

echo "sudo aws s3 sync /backup $S3DestinationPath"
sudo aws s3 sync /backup $S3DestinationPath
syncStatus=$?
# echo "sudo aws s3 cp /tmp/efs-backup.log s3://datapipeline.elmodev.com/logs/$efsid-`date +%Y%m%d-%H%M`.log"
# sudo aws s3 mv /tmp/efs-backup.log s3://datapipeline.elmodev.com/logs/$efsid-`date +%Y%m%d-%H%M`.log

exit $syncStatus
