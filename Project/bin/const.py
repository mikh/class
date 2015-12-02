
import math

def linear_activation(z):
	return z

def log_activation(z):
	return 1.0/(1 + math.exp(-1*z))

def tanh_activation(z):
	e_z = math.exp(z)
	e_minus_z = 1.0/e_z
	return (e_z - e_minus_z)/(e_z + e_minus_z)

def activate(act_fun, z):
	if act_fun == LINEAR_ACTIVATION_FUNCTION:
		return linear_activation(z)
	elif act_fun == LOG_ACTIVATION_FUNCTION:
		return log_activation(z)
	elif act_fun == TANH_ACTIVATION_FUNCTION:
		return tanh_activation(z)

DEBUG = True

#MLP constants
INPUT_LAYER = 0
HIDDEN_LAYER = 1
OUTPUT_LAYER = 2

LINEAR_ACTIVATION_FUNCTION = 0
LOG_ACTIVATION_FUNCTION = 1
TANH_ACTIVATION_FUNCTION = 2


#DATASET_PATH = 'D:\\Digital_Library\\data\\Documents\\Class\\EC500_Learning_From_Data\\Project\\Dataset\\Caltech_Dataset'
DATASET_PATH = 'E:\\Digital_Library\\data\\Class\\EC500\\class\\Project\\Dataset\\Caltech_Dataset'

#preprocessing
PERFORM_PREPROCESSING = False
RESIZE_IMAGES = True
RESIZE_IMAGE_DIMENSIONS = (300, 300)

#neural network
BUILD_NEURAL_NETWORK = True
NUMBER_OF_INPUTS = 90000
HIDDEN_LAYER_NODES = [3000, 3000]
NUMBER_OF_OUTPUT_NODES = 1
ACTIVATION_FUNCTION = LOG_ACTIVATION_FUNCTION

#dataset seperation
USE_FULL_DATASET = False
DATASET_CATEGORIES = ['accordion', 'airplanes', 'anchor']
NUMBER_OF_TRAINING_IMAGES = 20
NUMBER_OF_TESTING_IMAGES = 10


def dprint(message):
	if DEBUG:
		print(message, end="")