%% startup

clc;
clear;
fprintf('Multi-Layer Perceptron for Image Dectection.\n\n');

const;
rng(SEED);

%% load dataset paths:
fprintf('Loading dataset...\t');
[training_list, training_labels, testing_list, testing_labels, categories] = load_dataset(DATASET_LOCATION, NUMBER_OF_CATEGORIES_TO_USE, NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY, NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY);
fprintf('Done.\n');

%% create neural network
fprintf('Creating neural network...\t');
[layers, weights, activation_functions] = create_neural_network(NUM_INPUTS, HIDDEN_LAYERS, NUM_OUTPUTS, INPUT_ACTIVATION, HIDDEN_ACTIVATIONS, OUTPUT_ACTIVATION);
fprintf('Done.\n');

%% training
for ii = 1:length(training_list)
	[layers, weights] = train_neural_network(load_image(training_list{ii}), training_labels(ii), layers, weights, activation_functions, LEARNING_RATE);
end

%% script end
fprintf('Script complete.\n');


