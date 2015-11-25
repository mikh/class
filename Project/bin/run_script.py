


import os, imp, sys

config_file = 'config.txt'

ini_lib = imp.load_source('ini_lib', os.path.join('lib', 'ini_lib.py'))
path_lib = imp.load_source('path_lib', os.path.join('lib', 'path_lib.py'))
image_lib = imp.load_source('image_lib', os.path.join('lib', 'image_lib.py'))
console_lib = imp.load_source('console_lib', os.path.join('lib', 'console_lib.py'))

DATASET_PATH = ini_lib.get_value_default(config_file, 'PATHS', 'DATASET_PATH', 'NO_PATH')

def load_files(path, file_type=None):
	dataset = {}
	list_path = path_lib.get_all_files_in_directory(path)
	count = 0
	for category in list_path:
		cur_path = os.path.join(path, category)
		dataset[category] = path_lib.get_all_files_in_directory_with_extension(cur_path, file_type)
		count += len(dataset[category])
	dataset['dataset_count'] = count
	return dataset

def load_dataset_paths(path, file_type=None):
	if path == 'NO_PATH':
		print('No path to dataset.')
		sys.exit(-1);
	training_set = load_files(os.path.join(path, 'training_set'), file_type=file_type)
	testing_set = load_files(os.path.join(path, 'testing_set'), file_type=file_type)
	return (training_set, testing_set)

def preprocess_dataset(path, resize_images=True, resize_image_dimensions=(300,300)):
	(training_images, testing_images) = load_dataset_paths(path, file_type='jpg')
	if resize_images:
		total_count = training_images['dataset_count'] + testing_images['dataset_count']
		count = 0
		for category in training_images:
			if category != 'dataset_count':
				for ii in training_images[category]:
					p = os.path.join(path, 'training_set', category, ii)
					image_lib.resize_image(p, p, resize_image_dimensions[0], resize_image_dimensions[1])
					count += 1
					console_lib.update_progress_bar(count/total_count, 'Resizing ' + category + ' ' + ii + '                            ')
		for category in testing_images:
			if category != 'dataset_count':
				for ii in testing_images[category]:
					p = os.path.join(path, 'testing_set', category, ii)
					image_lib.resize_image(p, p, resize_image_dimensions[0], resize_image_dimensions[1])
					count += 1
					console_lib.update_progress_bar(count/total_count, 'Resizing ' + category + ' ' + ii + '                            ')

preprocess_dataset(DATASET_PATH)







