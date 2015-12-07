
import const

class neuron:
	def __init__(self, neuron_label, layer_type, number_of_prev_layer_nodes, activation_function, learning_rate):
		self.label = neuron_label
		self.layer = layer_type
		self.prev_nodes = number_of_prev_layer_nodes
		self.weight_vector = [0] * self.prev_nodes
		#self.weight_vector_diff = [0] * self.prev_nodes
		self.bias = 0
		self.activation_function = activation_function
		self.activation = 0
		self.diff_activation = 0
		self.learning_rate = learning_rate
		

	def forward_pass(self, layer_input):
		if self.layer == const.INPUT_LAYER:
			self.activation = const.activate(self.activation_function, layer_input)
		else:
			self.activation = self.bias
			for ii in range(0, self.prev_nodes):
				self.activation += (self.weight_vector[ii]*layer_input[ii])
				self.activation = const.activate(self.activation_function, self.activation)

#	def back_propogate(self, correct_label, previous_layer_activation):
#		if self.layer == const.OUTPUT_LAYER:
#			for ii in range(0, len(self.weight_vector_diff)):
#				self.weight_vector_diff[ii] = self.learning_rate*(correct_label-self.activation)*previous_layer_activation[ii]
#		elif self.layer == const.HIDDEN_LAYER:
#			pass






