fprintf('Loading defaults...\t');

%random seed
SEED = 'shuffle';

%dataset setup
DATASET_LOCATION = 'E:\\Digital_Library\\data\\Class\\EC500\\class\\Project\\Dataset\\Caltech_Dataset';
%DATASET_LOCATION = 'D:\\Digital_Library\\data\\Documents\\Class\\EC500_Learning_From_Data\\Project\\Dataset\\Caltech_Dataset';
NUMBER_OF_CATEGORIES_TO_USE = 3;
NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY = 20;
NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY = 10;

%neural network
NUM_INPUTS = 90000;
HIDDEN_LAYERS = [3000, 3000];
NUM_OUTPUTS = 1;
INPUT_ACTIVATION = 'LINEAR';
HIDDEN_ACTIVATIONS = {'SIGMOID', 'SIGMOID'};
OUTPUT_ACTIVATION = 'LINEAR';
LEARNING_RATE = 0.1;
THRESHOLD = 0.3;


fprintf('Done.\n');