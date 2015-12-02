
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

	def add_sample(sample, training, correct_label=None):
		