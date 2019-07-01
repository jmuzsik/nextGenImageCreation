# Create the folder to store Next Gen images
mkdir ./Images/ConvertedFiles

# Go into Image directory for easier understanding
cd Images

# Loop through all images in the Image directory
for file in *; do
  # This means, do not run this code on a directory, only on a file (-f)
  if [[ -f $file ]]; then
    fileName=$(echo $file | cut -d'.' -f 1) # something.jpg -> something

    # Create jpg if png, png if jpg
    if [[ $file == *.png ]]; then
      convert $file ./ConvertedFiles/$fileName.jpg
    else
      convert $file ./ConvertedFiles/$fileName.png
    fi

    # Conversion to Next Gen formats
    convert $file ./ConvertedFiles/$fileName.webp
    convert $file ./ConvertedFiles/$fileName.jp2

  fi

done

# For display purposes
cd ConvertedFiles
echo "Newly converted files:"
ls

# Go back down
cd ../..

# Move images to Image directory
mv ./Images/ConvertedFiles/* ./Images
# Remove old directory
rm -rf ./Images/ConvertedFiles
