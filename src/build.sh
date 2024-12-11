#!/bin/bash


echo "Copy to everything except tf to bin"
rm -rf ../bin/*

rsync -av --exclude='*.tf' --exclude 'build.sh' --exclude '*.h' . ../bin

# Find all .cfcpp files in the current directory and subdirectories
find . -type f -name "*.tf" | while read -r c_file; do
  # Get the directory of the .c file
  dir=$(dirname "$c_file")
  
  # Get the base name of the .c file without the extension
  base_name=$(basename "$c_file" .tf)

  # Set the output file name with .i extension in the same directory
  output_file="../bin/$dir/$base_name.tf"

  # Preprocess the .c file using the C compiler's preprocessor
  gcc -E -x c "$c_file" -o "$output_file"

  # Check if preprocessing was successful
  if [ $? -eq 0 ]; then
    echo "Processed: $c_file -> $output_file"
  else
    echo "Failed to process: $c_file"
  fi
done

mkdir ../bin/headers
find . -type f -name "*.h" | while read -r c_file; do
  # Get the directory of the .c file
  dir=$(dirname "$c_file")
  
  # Get the base name of the .c file without the extension
  base_name=$(basename "$c_file" .tf)

  # Set the output file name with .i extension in the same directory
  output_file="../bin/headers/$base_name"

  # Preprocess the .c file using the C compiler's preprocessor
  cp $c_file $output_file

done

cd ../bin
echo "Formatting to tf standards"
terraform fmt -recursive >/dev/null

cd ../src