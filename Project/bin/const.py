
import math

#MLP constants
INPUT_LAYER = 0
HIDDEN_LAYER = 1
OUTPUT_LAYER = 2

LINEAR_ACTIVATION_FUNCTION = 0
LOG_ACTIVATION_FUNCTION = 1
TANH_ACTIVATION_FUNCTION = 2

def linear_activation(z):
	return z

def log_activation(z):
	return 1.0/(1 + math.exp(-1*z))

def tanh_activation(z):
	e_z = math.exp(z)
	e_minus_z = 1.0/e_z
	return (e_z - e_minus_z)/(e_z + e_minus_z)