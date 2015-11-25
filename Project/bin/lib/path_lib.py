################ CHANGELOG #####################
#
# v1.0 - 5/18/15 11:40 Initial version. Designed to provide abstraction to path/file related functions
# v1.1 - 5/18/15 11:57 Added get_all_files_in_directory_with_extension
# v1.2 - 5/18/15 12:04 Added get_path_component
# v1.3 - 5/18/15 12:35 Added get_filename_without_extension
# v1.4 - 6/2/15 11:16 Added generate_alternate_name to allow for new file creation despite matched names
# V1.5 - 6/2/15 11:25 Added get_directory to return the directory a file is in
# v1.5 - 6/16/15 12:55 Added code to break a path apart into components and to follow a path creating directories as needed
# v1.6 - 6/16/15 15:01 Returns the latest alternate path of a file
# v1.7 - 6/22/15 12:47 Added code to delete a file and a directory
# v1.8 - 8/7/15 13:22 Added convert_bytes_to_KB function
# v1.9 - 8/12/15 15:20 Added function to extract drive from a windows path
# v1.10 - 8/12/15 15:25 Added function to return a windows path without the drive
# v1.11 - 9/8/15 14:30 Added linux_style to get_filename to allow for linux style paths
# v1.12 - 10/11/15 00:57 Added function to list all files in a directory
# v1.13 - 10/11/15 1:07 Added function to move files 
#
################ END CHANGELOG ################

import os, shutil

#combines path components into single path string
def merge_path(b_path):
	if(len(b_path) > 0):
		path = b_path[0]
		for ii in range(1, len(b_path)):
			path += "\\"
			path += b_path[ii]
		return path
	return ''

#return the path of this library
def get_current_path():
	return os.path.abspath(__file__)

#returns the base path of the Digital ibrary
def get_base_path():
	full_path = get_current_path()
	b_path = full_path.split("\\")
	while len(b_path) > 0 and b_path[len(b_path)-1] != 'bin':
		b_path.pop(len(b_path)-1)
	if b_path[len(b_path)-1] == 'bin':
		b_path.pop(len(b_path)-1)
	return merge_path(b_path)

#combines to paths
def join_path(path_a, path_b):
	return os.path.join(path_a, path_b)

#checks if directory exists
def directory_exists(path):
	return os.path.isdir(path)

#checks if file exists
def file_exists(path):
	return os.path.exists(path)

#deletes a file
def delete_file(path):
	if file_exists(path):
		os.remove(path)
	
#moves a file
def move_file(path, new_path):
	shutil.move(path, new_path)

#deletes a directory
def delete_directory(path):
	if directory_exists(path):
		shutil.rmtree(path)

#creates a directory at path
def create_directory(path):
	os.makedirs(path)

#copies file from src to dest
def copy_file(src, dest):
	shutil.copy2(src, dest)

#gets the filename of at the end of the path
def get_filename(path, linux_style=False):
	if linux_style:
		b_path = path.split('/')
		return b_path[len(b_path)-1]
	b_path = path.split("\\")
	return b_path[len(b_path)-1]

#gets the directory path the file is in
def get_directory(path):
	return os.path.dirname(path)

#returns filename without extension
def get_filename_without_extension(path):
	return os.path.splitext(get_filename(path))[0]

#gets all the files in a directory
def get_all_files_in_directory(path):
	return os.listdir(path)

#gets all files in a directory(non-recursive) with the given extension
def get_all_files_in_directory_with_extension(path, extension):
	if extension == None:
		return get_all_files_in_directory(path)
	results = []
	for f in os.listdir(path):
		if f.endswith(extension):
			results.append(f)
	return results

#splits a path into seperate pieces and returns a specific piece of the path, can also be taken from back of path
def get_path_component(path, position, from_back):
	s_path = path.split("\\")
	if(position < 0 or position >= len(s_path)):
		return None
	if(from_back):
		return s_path[len(s_path)-1-position]
	else:
		return s_path[position]

#creates a new file that does not conflict in name with previous files
def generate_alternate_name(file_path):
	base_path = get_directory(file_path)
	file_name = get_filename(file_path)
	base_name, extension = os.path.splitext(file_name)
	base_name.strip()
	if('(' in base_name and ')' in base_name):
		base_name = base_name[:base_name.find('(')].strip()
	file_number = 1

	new_path = os.path.join(base_path, "{0}({1}){2}".format(base_name, str(file_number), extension))
	while(file_exists(new_path)):
		file_number += 1
		new_path = os.path.join(base_path, "{0}({1}){2}".format(base_name, str(file_number), extension))
	return new_path

#returns the file path of the newest alternate path
def get_latest_alternate_path(file_path):
	return get_alternate_path(file_path, 0)

#returns the alternate name of a file before the end
def get_alternate_path(file_path, position_from_latest):
	if not file_exists(file_path):
		return file_path
	base_path = get_directory(file_path)
	file_name = get_filename(file_path)
	base_name, extension = os.path.splitext(file_name)
	if('(' in base_name and ')' in base_name):
		base_name = base_name[:base_name.find('(')].strip()
	file_number = 1
	new_path = os.path.join(base_path, "{0}({1}){2}".format(base_name, str(file_number), extension))
	while file_exists(new_path):
		file_number += 1
		new_path = os.path.join(base_path, "{0}({1}){2}".format(base_name, str(file_number), extension))

	if file_number == 1:
		return file_path
	return os.path.join(base_path, "{0}({1}){2}".format(base_name, str(file_number-1-position_from_latest), extension))
	

#breaks a path up into components - works with both linux and windows
def break_path(filepath):
	if '\\' in filepath:
		return filepath.split('\\')
	else:
		return filepath.split('/')

#follows a path and makes sure every part exists
def create_path(file_path):
	file_path = get_directory(file_path)

	path_pieces = break_path(file_path)
	if len(path_pieces) > 0:
		current_path = ''
		for ii in range(0, len(path_pieces)):
			if len(current_path) > 0 and current_path[len(current_path)-1] == ':':
				current_path += ("\\" + path_pieces[ii])
			else: 
				current_path = os.path.join(current_path, path_pieces[ii])
			if not directory_exists(current_path):
				create_directory(current_path)

#returns the size of a file in bytes
def get_filesize(file_path):
	return os.path.getsize(file_path)

#converts bytes to MB
def convert_bytes_to_megabytes(i_bytes):
	return float(float(i_bytes)/float(1048576))

#converts bytes to KB
def convert_bytes_to_kilobytes(i_bytes):
	return float(float(i_bytes)/float(1024))