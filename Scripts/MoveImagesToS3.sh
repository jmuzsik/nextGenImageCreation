#!/bin/bash

# First flag becomes $1, second becomes $2 in the function
sendToAppropriateFolder() {

  # First check if this is the Placeholder folder, as
  # these files are also jpg or png images
  if [[ "$3" == "Placeholders" ]]; then
    aws s3 cp $1 s3://$2/placeholders/ --acl=public-read
    return 1
  fi

  # Push each file to the correct path in the s3 bucket
  # Put png and jpg into fallback
  if [[ $1 == *.png ]]; then
    aws s3 cp $1 s3://$2/fallback/ --acl=public-read
  elif [[ $1 == *.jpg || $1 == *.jpeg ]]; then
    aws s3 cp $1 s3://$2/fallback/ --acl=public-read
  elif [[ $1 == *.webp ]]; then
    aws s3 cp $1 s3://$2/webpImages/ --acl=public-read
  elif [[ $1 == *.jp2 ]]; then
    aws s3 cp $1 s3://$2/jp2Images/ --acl=public-read
  fi
}

# Check if any arguments were added, store in correct variable
for ARGUMENT in "$@"; do

  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  VALUE=$(echo $ARGUMENT | cut -f2 -d=)

  case "$KEY" in
  bucket) bucket=${VALUE} ;;
  *) ;;
  esac
done

# Go to Images directory
cd Images

for fileToSendToS3 in *; do

  if [[ -f $fileToSendToS3 ]]; then
    sendToAppropriateFolder $fileToSendToS3 $bucket
  # Here it is a directory
  elif [[ -d $fileToSendToS3 ]]; then
    # So go into the directory
    cd $fileToSendToS3
    # And loop through it
    for fileWithinFolder in *; do
      # Third argument is used in case it is the Placeholders folder
      sendToAppropriateFolder $fileWithinFolder $bucket $fileToSendToS3
    done
    # Go back to the original directory
    cd ..
  fi
done

cd ..

echo ""
echo "This is the url to see the images:"
echo "https://$bucket.s3.amazonaws.com/some-extension"
echo "some-extension is the path and filename, so it's something like fallback/someImage.jpg"
echo "ie. https://$bucket.s3.amazonaws.com/fallback/someImage.jpg"
echo ""
