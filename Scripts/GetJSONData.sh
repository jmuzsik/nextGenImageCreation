#!/bin/bash

# Check if any arguments were added, store in correct variable
for ARGUMENT in "$@"; do

  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  VALUE=$(echo $ARGUMENT | cut -f2 -d=)

  case "$KEY" in
  bucket) bucket=${VALUE} ;;
  *) ;;
  esac
done

cd ./Javascript

# Create the file
touch data.json

# Output data to file
aws s3api list-objects --bucket $bucket > data.json

# Run Javascript on the JSON file
node makeJSONReadable.js $bucket

# Remove data that is not needed
rm data.json

# Return to home directory
cd ..
