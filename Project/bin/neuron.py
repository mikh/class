
import const

class neuron:
	def __init__(self, neuron_label, layer_type, number_of_prev_layer_nodes, activation_function):
		self.label = neuron_label
		self.layer = layer_type
		self.prev_nodes = number_of_prev_layer_nodes
		self.weight_vector = [0] * self.prev_nodes
		self.bias = 0
		self.activation_function = activation_function
		self.activation = 0
		

	def forward_pass(self, layer_input):
		if self.layer == const.INPUT_LAYER:
			self.activation = self.activation_function(layer_input)
		else:
			self.activation = self.bias
			for ii in range(0, number_of_prev_layer_nodes):
				self.activation += (self.weight_vector[ii]*layer_input[ii])
				self.activation = const.activate(self.activation_function, self.activation)





