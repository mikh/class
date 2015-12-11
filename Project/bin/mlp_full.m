%% startup

clc;
clear;
fprintf('Multi-Layer Perceptron for Image Dectection.\n\n');

const;
rng(SEED);
f_data = fopen('results_data.txt', 'w');

%% load dataset
fprintf('Loading dataset...\t');
fid = zeros(NUMBER_OF_CATEGORIES_TO_USE,1);
for ii = 1:NUMBER_OF_CATEGORIES_TO_USE
    fid(ii) = fopen(sprintf('data%d', ii-1), 'r');
end

num_train = NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY;
num_test = NUMBER_OF_CATEGORIES_TO_USE*NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY;
training_list = cell(num_train, 1);
training_labels = cell(num_train, 1);
testing_list = cell(num_test, 1);
testing_labels = cell(num_test, 1);

for ii = 1:NUMBER_OF_CATEGORIES_TO_USE
    for jj = 1:NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY
        [mat, fid(ii)] = load_digit_image(fid(ii));
        training_list{(ii-1)*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY+jj} = mat;
        correct = zeros(NUMBER_OF_CATEGORIES_TO_USE, 1);
        correct(ii) = 1;
        training_labels{(ii-1)*NUMBER_OF_TRAINING_SAMPLES_PER_CATEGORY+jj} = correct;
    end
    for jj = 1:NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY
        [mat, fid(ii)] = load_digit_image(fid(ii));
        testing_list{(ii-1)*NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY+jj} = mat;
        correct = zeros(NUMBER_OF_CATEGORIES_TO_USE, 1);
        correct(ii) = 1;
        testing_labels{(ii-1)*NUMBER_OF_TESTING_SAMPLES_PER_CATEGORY+jj} = correct;
    end
end
fprintf('Done.\n');

%% learning by example
% fprintf(f_data, 'Learning by example...\n');
% % create neural network
% 
% for learning_rate = 0.2:0.2:1
%     for num_neurons = 50:50:1000
%         for num_layers = 1:3
%             hidden_layers = zeros(1, num_layers) + num_neurons;
%             hidden_activations = cell(num_layers, 1);
%             for kk = 1:num_layers
%                 hidden_activations{kk} = 'SIGMOID';
%             end
%             fprintf(f_data, 'num_neurons = %d\n', num_neurons);
%             fprintf(f_data, 'num_layers = %d\n', num_layers);
%             fprintf(f_data, 'learning rate = %.2f\n', learning_rate);
%             fprintf('Creating neural network...\t');
%             [layers, weights, activation_functions] = create_neural_network(NUM_INPUTS, hidden_layers, NUM_OUTPUTS, INPUT_ACTIVATION, hidden_activations, OUTPUT_ACTIVATION);
%             fprintf('Done.\n');
%             t1 = clock;
%             for ii = 1:num_train
%                 [layers, weights] = train_neural_network(training_list{ii}, training_labels(ii), layers, weights, activation_functions, learning_rate); 
%             end
%             fprintf(f_data, 'training time = %.2fs\n', etime(clock,t1));
%             num_correct = 0;
%             results = zeros(num_test, 1);
%             t1 = clock;
%             for ii = 1:num_test
%                 [num_correct, results(ii)] = test_neural_network(testing_list{ii}, testing_labels(ii), num_correct, layers, weights, activation_functions, THRESHOLD);
%             end
%             fprintf(f_data, 'testing time = %.2fs\n', etime(clock,t1));
%             fprintf(f_data, '%d correct of %d\n', num_correct, num_test);
%             fprintf(f_data, '\n');
%             clear layers weights
%         end
%     end
% end
% 
% fprintf(f_data,'\n\n\n\n');
%% learning by epoch

fprintf(f_data, 'Learning by epoch...\n');

learning_rate = 0.2;
iterations = 250;
num_neurons = 50;
num_layers = 3;
% for learning_rate = 0.2:0.2:1
%     for iterations = 50:50:400
%         for num_neurons = 50:50:1000
%             for num_layers = 1:3
                hidden_layers = zeros(1, num_layers) + num_neurons;
                hidden_activations = cell(num_layers, 1);
                for kk = 1:num_layers
                    hidden_activations{kk} = 'SIGMOID';
                end
                fprintf('num_neurons = %d\n', num_neurons);
                fprintf('num_layers = %d\n', num_layers);
                fprintf('learning rate = %.2f\n', learning_rate);
                fprintf('iterations = %d\n', iterations);
                fprintf('Creating neural network...\t');
                [layers, weights, activation_functions] = create_neural_network(NUM_INPUTS, hidden_layers, NUM_OUTPUTS, INPUT_ACTIVATION, hidden_activations, OUTPUT_ACTIVATION);
                fprintf('Done.\n');
                t1 = clock;
                [layers, weights] = train_neural_network_by_epoch(training_list, training_labels, layers, weights, activation_functions, learning_rate, iterations); 
                fprintf('training time = %.2fs\n', etime(clock,t1));
                num_correct = 0;
                results = zeros(num_test, 1);
                t1 = clock;
                for ii = 1:num_test
                    [num_correct, results(ii)] = test_neural_network(testing_list{ii}, testing_labels{ii}, num_correct, layers, weights, activation_functions, THRESHOLD);
                end
                fprintf('testing time = %.2fs\n', etime(clock,t1));
                fprintf('%d correct of %d\n', num_correct, num_test);
                fprintf('\n');
                clear layers weights
%             end
%         end
%     end
% end


%% learning by epoch with momentum

% fprintf(f_data, 'Learning by epoch with momentum...\n');
% for learning_rate = 0.2:0.2:1
%     for iterations = 50:50:400
%         for num_neurons = 50:50:1000
%             for num_layers = 1:3
%                 hidden_layers = zeros(1, num_layers) + num_neurons;
%                 hidden_activations = cell(num_layers, 1);
%                 for kk = 1:num_layers
%                     hidden_activations{kk} = 'SIGMOID';
%                 end
%                 fprintf(f_data, 'num_neurons = %d\n', num_neurons);
%                 fprintf(f_data, 'num_layers = %d\n', num_layers);
%                 fprintf(f_data, 'learning rate = %.2f\n', learning_rate);
%                 fprintf(f_data, 'iterations = %d\n', iterations);
%                 fprintf('Creating neural network...\t');
%                 [layers, weights, activation_functions] = create_neural_network(NUM_INPUTS, hidden_layers, NUM_OUTPUTS, INPUT_ACTIVATION, hidden_activations, OUTPUT_ACTIVATION);
%                 fprintf('Done.\n');
%                 t1 = clock;
%                 [layers, weights] = train_neural_network_by_epoch_with_momentum(training_list, training_labels, layers, weights, activation_functions, learning_rate, iterations); 
%                 fprintf(f_data, 'training time = %.2fs\n', etime(clock,t1));
%                 num_correct = 0;
%                 results = zeros(num_test, 1);
%                 t1 = clock;
%                 for ii = 1:num_test
%                     [num_correct, results(ii)] = test_neural_network(testing_list{ii}, testing_labels(ii), num_correct, layers, weights, activation_functions, THRESHOLD);
%                 end
%                 fprintf(f_data, 'testing time = %.2fs\n', etime(clock,t1));
%                 fprintf(f_data, '%d correct of %d\n', num_correct, num_test);
%                 fprintf(f_data, '\n');
%                 clear layers weights
%             end
%         end
%     end
% end
