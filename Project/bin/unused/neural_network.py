import os, imp, sys
import const, neuron, numpy
console_lib = imp.load_source('console_lib', os.path.join('lib', 'console_lib.py'))

def create_list_of_neurons(size, start_label, layer_type, prev_layer_size, activation_function, learning_rate):
	l = []
	for ii in range(0, size):
		l.append(neuron.neuron(start_label+ii, layer_type, prev_layer_size, activation_function, learning_rate))
	return l

def get_size_of_matrix(matrix):
	x = len(matrix)
	y = 0
	if x > 0:
		y = len(matrix[0])
	return (x, y)

class neural_network:
	def __init__(self, number_of_input_nodes, hidden_layer_list, number_of_outputs, activation_function, learning_rate):
		self.node_weights = []
		self.number_of_layers = 2 + len(hidden_layer_list)
		self.layer_widths = [number_of_input_nodes]
		self.layer_widths.extend(hidden_layer_list)
		self.layer_widths.append(number_of_outputs)

		for ii in range(0, self.number_of_layers-1):
			a = numpy.reshape([[1] * self.layer_widths[ii]], (self.layer_widths[ii], 1))
			b = [[1] * self.layer_widths[ii+1]]
			c = numpy.dot(a, b)


			print(get_size_of_matrix(a))
			print(get_size_of_matrix(b))
			print(get_size_of_matrix(c))
			input("pause")



	'''
	def __init__(self, number_of_input_nodes, hidden_layer_list, number_of_outputs, activation_function, learning_rate):
		const.dprint("Bulding neural network...\n")
		self.nodes = []
		self.number_of_layers = 2 + len(hidden_layer_list)
		const.dprint('Creating input layer...\t')
		self.nodes.append(create_list_of_neurons(number_of_input_nodes, 0, const.INPUT_LAYER, 0, const.LINEAR_ACTIVATION_FUNCTION, learning_rate))
		const.dprint('Done.\n')
		index = number_of_input_nodes + 1
		prev_size = number_of_input_nodes
		for ii in range(0, len(hidden_layer_list)):
			const.dprint('Creating hidden layer...\t')
			self.nodes.append(create_list_of_neurons(hidden_layer_list[ii], index, const.HIDDEN_LAYER, prev_size, activation_function, learning_rate))
			const.dprint('Done.\n')
			index += hidden_layer_list[ii]
			prev_size = hidden_layer_list[ii]
		const.dprint('Creating output layer...\t')
		self.nodes.append(create_list_of_neurons(number_of_outputs, index, const.OUTPUT_LAYER, prev_size, const.LINEAR_ACTIVATION_FUNCTION, learning_rate))
		const.dprint('Done.\n')
		print('Neural Network Built.')
	'''

	def collect_activations(self, layer):
		layer_size = len(self.nodes[layer])
		activations = []
		for ii in range(0, layer_size):
			activations.append(self.nodes[layer][ii].activation)
		return activations

	def add_sample(self,sample, sample_size, training, correct_label=None):
		for r in range(0, sample_size[0]):
			for c in range(0, sample_size[1]):
				sample_point = sample[r][c]
				self.nodes[0][r*sample_size[1]+c].forward_pass(sample_point)
		activations = self.collect_activations(0)
		for ii in range(1, self.number_of_layers):
			for jj in range(0, len(self.nodes[ii])):
				console_lib.update_progress_bar(jj/len(self.nodes[ii]), 'Neuron: ' + str(jj) + '                            ')
				self.nodes[ii][jj].forward_pass(activations)
			print('\n')
			activations = self.collect_activations(ii)
		for jj in range(0, len(self.nodes[self.number_of_layers-1])):
			print("Output=")
			print(self.nodes[self.number_of_layers-1][jj].activation)
		input("pause")

