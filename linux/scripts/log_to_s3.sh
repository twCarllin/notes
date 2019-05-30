set -e

if [ -z $1 ]; then
	echo "Error: no filename passed in."
	exit;
fi

echo 'Starting S3 Log Upload'

# Extract file anme from pat
path="$1"
file="${path##*/}"
file="$file"

BUCKET_NAME="ai-server-log"
# Time stamp and instance id for bucket sub-folders
timestamp=$(date +"%H%M")
date=$(date +"%Y-%m-%d")

# Dynamically retreive instance ID and replace i- with nothing
EC2_INSTANCE_ID="`wget -q -O - http://instance-data/latest/meta-data/instance-id | sed -e s/i-//`"

if [ -z $EC2_INSTANCE_ID ]; then
	echo "Error: Couldn't fetch Instance ID."
	exit;
fi

/usr/bin/aws s3 cp $1.1 s3://$BUCKET_NAME/matomo/$EC2_INSTANCE_ID/$date/$timestamp.csv

