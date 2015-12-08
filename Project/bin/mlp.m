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

fprintf('Testing images...\t');
for ii = 1:length(training_list)
    load_image(training_list{ii});
end
for ii = 1:length(testing_list)
    load_image(testing_list{ii});
end
fprintf('Done.\n');

%% create neural network
fprintf('Creating neural network...\t');
[layers, weights, activation_functions] = create_neural_network(NUM_INPUTS, HIDDEN_LAYERS, NUM_OUTPUTS, INPUT_ACTIVATION, HIDDEN_ACTIVATIONS, OUTPUT_ACTIVATION);
fprintf('Done.\n');

%% training
for ii = 1:length(training_list)
    fprintf('Training image %d of %d...\t', ii, length(training_list));
	[layers, weights] = train_neural_network(load_image(training_list{ii}), training_labels(ii), layers, weights, activation_functions, LEARNING_RATE);
    fprintf('Done.\n');
end

%% testing
num_correct = 0;
for ii = 1:length(testing_list)
    fprintf('Testing image %d of %d...\t', ii, length(testing_list));
    num_correct = test_neural_network(load_image(testing_list{ii}), testing_labels(ii), num_correct, layers, weights, activation_functions, THRESHOLD);
    fprintf('Done.\n');
end
fprintf('%d correct of %d.\n', num_correct, length(testing_list));
%% script end
fprintf('Script complete.\n');


