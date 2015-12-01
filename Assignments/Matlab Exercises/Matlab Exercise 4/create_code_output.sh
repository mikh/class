current_directory="/e/Digital_Library/data/Class/EC500/class/Assignments/Matlab Exercises/Matlab Exercise 4/"
#current_directory="/d/Digital_Library/data/Documents/Class/EC500_Learning_From_Data/Assignments/Matlab Exercises/Matlab Exercise 4/"
output_files_txt="$current_directory""output.txt"
output_directory="$current_directory""mikh_matlab4"

rm -rf "$output_directory"
mkdir "$output_directory"
output_directory="$output_directory""/"

while read p; do
	echo $p
	name=`basename $p`
	cp "$current_directory""$p" "$output_directory""$name"
done < "$output_files_txt"
