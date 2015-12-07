
import math

DEBUG = True

#MLP constants
INPUT_LAYER = 0
HIDDEN_LAYER = 1
OUTPUT_LAYER = 2

LINEAR_ACTIVATION_FUNCTION = 0
LOG_ACTIVATION_FUNCTION = 1
TANH_ACTIVATION_FUNCTION = 2


DATASET_PATH = 'D:\\Digital_Library\\data\\Documents\\Class\\EC500_Learning_From_Data\\Project\\Dataset\\Caltech_Dataset'
#DATASET_PATH = 'E:\\Digital_Library\\data\\Class\\EC500\\class\\Project\\Dataset\\Caltech_Dataset'

#preprocessing
PERFORM_PREPROCESSING = True
RESIZE_IMAGES = False
RESIZE_IMAGE_DIMENSIONS = (300, 300)
CREATE_DATA_FILES = True
DATA_FILE_LOCATIONS = 'D:\\Digital_Library\\data\\Documents\\Class\\EC500_Learning_From_Data\\Project\\Dataset\\data'


def dprint(message):
	if DEBUG:
		print(message, end="")