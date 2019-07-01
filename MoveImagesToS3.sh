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

  # Push each file to the correct path in the s3 bucket
  # Put png and jpg into fallback
  if [[ $fileToSendToS3 == *.png ]]; then
    aws s3 cp $fileToSendToS3 s3://$bucket/fallback/ --acl=public-read
  elif [[ $fileToSendToS3 == *.jpg || $fileToSendToS3 == *.jpeg ]]; then
    aws s3 cp $fileToSendToS3 s3://$bucket/fallback/ --acl=public-read
  elif [[ $fileToSendToS3 == *.webp ]]; then
    aws s3 cp $fileToSendToS3 s3://$bucket/webpImages/ --acl=public-read
  elif [[ $fileToSendToS3 == *.jp2 ]]; then
    aws s3 cp $fileToSendToS3 s3://$bucket/jp2Images/ --acl=public-read
  fi

done

cd ..

echo ""
echo "This is the url to see the images:"
echo "https://$bucket.s3.amazonaws.com/some-extension"
echo "some-extension is the path and filename, so it's something like fallback/someImage.jpg"
echo "ie. https://$bucket.s3.amazonaws.com/fallback/someImage.jpg"
echo ""
