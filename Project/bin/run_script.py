


import os, imp, sys

config_file = 'config.txt'

ini_lib = imp.load_source('ini_lib', os.path.join('lib', 'ini_lib.py'))
path_lib = imp.load_source('path_lib', os.path.join('lib', 'path_lib.py'))

DATASET_PATH = ini_lib.get_value_default(config_file, 'PATHS', 'DATASET_PATH', 'NO_PATH')

def load_dataset(path):
	if path == 'NO_PATH':
		print('No path to dataset.')
		sys.exit(-1);
	path = os.path.join(path, 'training_set')

	training_set_paths = {}

	count = 0
	list_path = path_lib.get_all_files_in_directory(path)
	for category in list_path:
		training_set_paths[category] = []
		cur_path = os.path.join(path, category)
		images = path_lib.get_all_files_in_directory(cur_path)
		for image in images:
			training_set_paths[category].append(os.path.join(cur_path, image))
			count += 1
	print(count)

load_dataset(DATASET_PATH)








