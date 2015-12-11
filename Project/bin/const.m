fprintf('Loading defaults...\t');

%random seed
SEED = 'shuffle';

%dataset setup
%DATASET_LOCATION = 'E:\\Digital_Library\\data\\Class\\EC500\\class\\Project\\Dataset\\Caltech_Dataset';
DATASET_LOCATION = 'D:\\Digital_Library\\data\\Documents\\Class\\EC500_Learning_From_Data\\Project\\Dataset\\Caltech_Dataset';
NUMBER_OF_CATEGORIES_TO_USE = 3;
NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY = 300;
NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY = 30;


%neural network
NUM_INPUTS = 784;
HIDDEN_LAYERS = [300, 300];
NUM_OUTPUTS = 3;
INPUT_ACTIVATION = 'LINEAR';
HIDDEN_ACTIVATIONS = {'SIGMOID', 'SIGMOID'};
OUTPUT_ACTIVATION = 'LINEAR';
LEARNING_RATE = 0.05;
THRESHOLD = 0.3;
NUMBER_OF_ITERATIONS = 300;


fprintf('Done.\n');