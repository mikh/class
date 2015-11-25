################ CHANGELOG #####################
#
# v0.1 11/18/15 18:00 Added base version from archive
# v0.2 11/18/15 18:05 Added 
#
################ END CHANGELOG ################

import subprocess, os, imp, time, threading

#get Digital_Library base_path
base_path = str(os.path.abspath(__file__))
temp_path = base_path.split("\\")
file_name = temp_path[len(temp_path)-1]
base_path = temp_path[0]
for ii in range(1, len(temp_path)):
	if temp_path[ii] == file_name:
		break
	if len(base_path) > 0 and base_path[len(base_path)-1] == ':':
		base_path += "\\"
		base_path += temp_path[ii]
	else:
		base_path = os.path.join(base_path, temp_path[ii])

#setup paths
lib_path = base_path
temp_path = os.path.join(base_path, 'temp', 'execute_lib')

#load libraries
path_lib = imp.load_source('path_lib', os.path.join(lib_path, 'path_lib.py'))

#PRIVATE FUNCTIONS

#callback function for launching a script on a seperate thread
def run_script_callback(path):
	os.system(path)

#parses a line and extracts the command line call and processid
def parse_process_line(text):
	text = text[2:]		#remove b'
	text = text[:len(text)-7]		#remove /r/r/n
	text = text.strip()
	if ('ExecutablePath' in text) and ('ProcessId' in text):
		return None
	tab_count = text.count('\t')
	text_p = text.split('\t')
	d = {}

	if tab_count == 1:
		d['caption'] = text_p[0]
		d['executable_path'] = ''
		d['process_id'] = text_p[1]
	elif tab_count == 2:
		d['caption'] = text_p[0]
		d['executable_path'] = text_p[1]
		d['process_id'] = text_p[2]
	return d

#PUBLIC FUNCTIONS

#runs an executable given a path
def execute(path):
	subprocess.call([path], shell=True)

#executes an executable by passing it to the batch shell with the appropriate commands
def execute_batch_shell(path):
	os.system("start /b \"\" " + path)

#executes the executable from within its own directory using a batch script
def execute_within_folder(path, admin=False):
	drive = path_lib.get_drive(path)
	change_directory_path = path_lib.remove_drive(path_lib.get_directory(path))
	executable = path_lib.get_filename(path)

	temp_batch_script = os.path.join(temp_path, 'temp_batch_script.bat')
	path_lib.create_path(temp_batch_script)

	with open(temp_batch_script, 'w') as f:
		f.write('cd ' + drive + ':\\\n')
		f.write('cd "' + change_directory_path + '"\n')
		f.write(executable + '\n')

	t = threading.Thread(name='script', target=run_script_callback, args=(temp_batch_script,))
	t.start()

#gets the currently running processes
def get_processes():
	cmd = 'WMIC PROCESS get Caption,ExecutablePath,Processid'
	proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
	processes = []
	with open('test_file.txt', 'w') as f:
		for line in proc.stdout:
			line = str(line)
			line = line.replace('  ', '\t')
			while line.find('\t\t') != -1:
				line = line.replace('\t\t', '\t')
			p = parse_process_line(line)
			if p != None:
				processes.append(p)
	return processes

#writes a list of processes to a file
def write_processes(processes, filename):
	with open(filename, 'w') as f:
		for i in processes:
			f.write(str(i) + '\n')

#given a list of processes, returns the process_id if it can be found
def find_process_id(processes, caption_contains=None, executable_path_contains=None):
	if (caption_contains == None) and (executable_path_contains == None):
		return None
	for i in processes:
		if (caption_contains != None) and ('caption' in i):
			if i['caption'].find(caption_contains) != -1:
				return i['process_id']
		elif (executable_path_contains != None) and ('executable_path' in i):
			if i['executable_path'].find(executable_path_contains) != -1:
				return i['process_id']
	return None

#kills a process given a pid
def kill_process(pid):
	subprocess.Popen("taskkill /f /t /pid " + pid, shell=True)

#run shell command
def run_shell_command(command, get_output=False):
	p = subprocess.Popen(command, shell=True)
	if get_output:
		out, err = p.communicate()
		return (out, err)


#TEST CODE
#get_processes()

