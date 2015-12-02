


import os, imp, sys
import neuron, neural_network, const


path_lib = imp.load_source('path_lib', os.path.join('lib', 'path_lib.py'))
image_lib = imp.load_source('image_lib', os.path.join('lib', 'image_lib.py'))
console_lib = imp.load_source('console_lib', os.path.join('lib', 'console_lib.py'))

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

def get_sample_lists(path):
	(training_images, testing_images) = load_dataset_paths(path, file_type='jpg')
	const.dprint('Loading categories...\t')
	training_list = []
	testing_list = []
	training_labels = []
	testing_labels = []
	label_ids = []
	for category in list(training_images):
		if (const.USE_FULL_DATASET or (category in const.DATASET_CATEGORIES)) and (category != 'dataset_count'):
			training_list.extend([os.path.join(path, 'training_set', category, i) for i in training_images[category][0:const.NUMBER_OF_TRAINING_IMAGES]])
			training_labels.extend([len(label_ids)]*const.NUMBER_OF_TRAINING_IMAGES)
			testing_list.extend([os.path.join(path, 'training_set', category, i) for i in training_images[category][const.NUMBER_OF_TRAINING_IMAGES:(const.NUMBER_OF_TRAINING_IMAGES+const.NUMBER_OF_TESTING_IMAGES)]])
			testing_labels.extend([len(label_ids)]*const.NUMBER_OF_TESTING_IMAGES)
			label_ids.append(category)
	const.dprint('Done.\n')
	return (training_list, training_labels, testing_list, testing_labels, label_ids)

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

def create_neural_network(n_inputs, n_hidden, n_outputs, activation_function):
	return neural_network.neural_network(n_inputs, n_hidden, n_outputs, activation_function)

def run_training(training_list, training_labels, neu_net):
	for ii in range(0, len(training_list)):
		matrix = image_lib.convert_to_matrix(training_list[ii])
		neu_net.add_sample(matrix, const.RESIZE_IMAGE_DIMENSIONS, True, correct_label=training_labels[ii])

if const.PERFORM_PREPROCESSING:
	preprocess_dataset(const.DATASET_PATH, resize_images=const.RESIZE_IMAGES, resize_image_dimensions=const.RESIZE_IMAGE_DIMENSIONS)

if const.BUILD_NEURAL_NETWORK:
	neu_net = create_neural_network(const.NUMBER_OF_INPUTS, const.HIDDEN_LAYER_NODES, const.NUMBER_OF_OUTPUT_NODES, const.ACTIVATION_FUNCTION)
	#neu_net = None
	(training_list, training_labels, testing_list, testing_labels, label_ids) = get_sample_lists(const.DATASET_PATH)
	run_training(training_list, training_labels, neu_net)


const.dprint('Script Finished.\n')
