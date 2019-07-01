#!/bin/bash

# Check if any arguments were added, store in correct variable
for ARGUMENT in "$@"; do

  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  VALUE=$(echo $ARGUMENT | cut -f2 -d=)

  case "$KEY" in
  bucket) bucket=${VALUE} ;;
  region) region=${VALUE} ;;

  *) ;;
  esac
done

# Create bucket if it does not exist
if [[ $region == "" ]]; then
  aws s3api create-bucket --bucket $bucket --region 'us-east-1' --acl 'public-read'
else
  aws s3api create-bucket --bucket $bucket --region $region --acl 'public-read'
fi

# Send a test image
aws s3 cp ./Images/duckJPG.jpg s3://$bucket/ --acl=public-read

# Final message
echo "Check if it works by clicking this url: https://$bucket.s3.amazonaws.com/duckJPG.jpg"
