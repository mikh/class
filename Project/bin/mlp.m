%% startup

clc;
clear;
fprintf('Multi-Layer Perceptron for Image Dectection.\n\n');

const;
rng(SEED);

%% load dataset paths:
% fprintf('Loading dataset...\t');
% [training_list, training_labels, testing_list, testing_labels, categories] = load_dataset(DATASET_LOCATION, NUMBER_OF_CATEGORIES_TO_USE, NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY, NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY);
% fprintf('Done.\n');
% 
% fprintf('Testing images...\t');
% for ii = 1:length(training_list)
%     load_image(training_list{ii});
% end
% for ii = 1:length(testing_list)
%     load_image(testing_list{ii});
% end
% fprintf('Done.\n');
fid(1) = fopen('data0', 'r');
fid(2) = fopen('data1', 'r');

%% create neural network
fprintf('Creating neural network...\t');
[layers, weights, activation_functions] = create_neural_network(NUM_INPUTS, HIDDEN_LAYERS, NUM_OUTPUTS, INPUT_ACTIVATION, HIDDEN_ACTIVATIONS, OUTPUT_ACTIVATION);
fprintf('Done.\n');

%% training

training_list = cell(NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY, 1);
training_labels = zeros(NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY, 1);
% for ii = 1:NUMBER_OF_CATEGORIES_TO_USE
%     for jj = 1:NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY
%         [mat, fid(ii)] = load_digit_image(fid(ii));
%         training_list{(ii-1)*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY+jj} = mat;
%         training_labels((ii-1)*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY+jj) = ii -1;
%     end
% end

fprintf('Training image %d of %d...\t', ii*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY + jj, NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY);
[layers, weights] = train_neural_network_by_epoch(training_list, training_labels, layers, weights, activation_functions, LEARNING_RATE, NUMBER_OF_ITERATIONS);
fprintf('Done.\n');
    

% for ii = 1:length(training_list)
%     fprintf('Training image %d of %d...\t', ii, length(training_list));
%     
% 	[layers, weights] = train_neural_network(load_image(training_list{ii}), training_labels(ii), layers, weights, activation_functions, LEARNING_RATE);
%     fprintf('Done.\n');
% end

%% testing
num_correct = 0;
results = zeros(NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY, 1);


for ii = 1:NUMBER_OF_CATEGORIES_TO_USE
    for jj = 1:NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY
        fprintf('Testing image %d of %d...\t', ii*NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY + jj, NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY);
        [mat, fid(ii)] = load_digit_image(fid(ii));
        [num_correct, results((ii-1)*NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY+jj)] = test_neural_network(mat, ii-1, num_correct, layers, weights, activation_functions, THRESHOLD);
        fprintf('Done.\n');
    end
end
fprintf('%d correct of %d.\n', num_correct, NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY);
%% script end
fprintf('Script complete.\n');


