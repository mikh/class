
import const, neuron

def create_list_of_neurons(size, start_label, layer_type, prev_layer_size, activation_function):
	l = []
	for ii in range(0, size):
		l.append(neuron.neuron(start_label+ii, layer_type, prev_layer_size, activation_function))
	return l


class neural_network:
	def __init__(self, number_of_input_nodes, hidden_layer_list, number_of_outputs, activation_function):
		const.dprint("Bulding neural network...\n")
		self.nodes = []
		self.number_of_layers = 2 + len(hidden_layer_list)
		const.dprint('Creating input layer...\t')
		self.nodes.append(create_list_of_neurons(number_of_input_nodes, 0, const.INPUT_LAYER, 0, const.linear_activation))
		const.dprint('Done.\n')
		index = number_of_input_nodes + 1
		prev_size = number_of_input_nodes
		for ii in range(0, len(hidden_layer_list)):
			const.dprint('Creating hidden layer...\t')
			self.nodes.append(create_list_of_neurons(hidden_layer_list[ii], index, const.HIDDEN_LAYER, prev_size, activation_function))
			const.dprint('Done.\n')
			index += hidden_layer_list[ii]
			prev_size = hidden_layer_list[ii]
		const.dprint('Creating output layer...\t')
		self.nodes.append(create_list_of_neurons(number_of_outputs, index, const.OUTPUT_LAYER, prev_size, activation_function))
		const.dprint('Done.\n')
		print('Neural Network Built.')

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
			print('layer={0}'.format(ii))
			for jj in range(0, len(self.nodes[ii])):
				print('\tnode={0}'.format(jj))
				self.nodes[ii][jj].forward_pass(activations)
			activations = self.collect_activations(ii)
		for jj in range(0, len(self.nodes[self.number_of_layers-1])):
			print("Output=")
			print(self.nodes[self.number_of_layers-1][jj].activation)
		input("pause")

