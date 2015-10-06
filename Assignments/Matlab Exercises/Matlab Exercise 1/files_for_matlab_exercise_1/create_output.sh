

current_directory="/d/Digital_Library/data/Documents/Class/EC500_Learning_From_Data/Assignments/Matlab Exercises/Matlab Exercise 1/files_for_matlab_exercise_1/"
output_files_txt="output_files.txt"

output_files_list="$current_directory""$output_files_txt"
output_directory="$current_directory""output"
rm -rf "$output_directory"
mkdir "$output_directory"
output_directory="$output_directory""/"

while read p; do
	echo $p
	cp "$current_directory""$p" "$output_directory""mikh_""$p"

done <"$output_files_list"

