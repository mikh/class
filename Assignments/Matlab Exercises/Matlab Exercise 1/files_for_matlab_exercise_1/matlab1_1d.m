clc
clear

load 'data_cancer.mat';

[N, D] = size(X);
M = range(Y)+1;

num_training = 150;
num_testing = N - 150;
rand_stream = RandStream('mt19937ar', 'Seed', 1);

%perform split
train_indices = sort(randperm(rand_stream, N, num_training));
training_samples = zeros(num_training,D);
training_labels = zeros(num_training, 1);
testing_samples = zeros(num_testing,D);
testing_labels = zeros(num_testing, 1);

index = 1;
train_index = 1;
test_index = 1;
x_axis = 0.1:0.05:1;
CCR_train = zeros(length(x_axis), 1);
CCR_test = zeros(length(x_axis), 1);

for kk = 1:N
    if (index <= num_training) && (train_indices(index) == kk)
        training_samples(train_index, :) = X(kk, :);
        training_labels(train_index) = Y(kk);
        index = index + 1;
        train_index = train_index + 1;
    else
        testing_samples(test_index, :) = X(kk, :);
        testing_labels(test_index) = Y(kk);
        test_index = test_index + 1;    
    end    
end

if min(training_labels) == 0
    training_labels = training_labels + 1;
end
if min(testing_labels) == 0
    testing_labels = testing_labels + 1;
end

fprintf('Training...\t');
LDAmodel_all_gamma = RDA_train(training_samples, training_labels, x_axis, M);
fprintf('Done.\n');

index = 1;
for jj = 1:length(x_axis)
   fprintf('lambda=%d\n', x_axis(jj));
   fprintf('Testing Train Samples...\t');
   Y_Predict_train = RDA_test(training_samples, LDAmodel_all_gamma(jj), M);
   fprintf('Done.\n');
   fprintf('Testing Test Samples...\t');
   Y_Predict_test = RDA_test(testing_samples, LDAmodel_all_gamma(jj), M);
   fprintf('Done.\n');
   
   total_correct_train = 0;
   for ii = 1:length(Y_Predict_train)
       if training_labels(ii) == Y_Predict_train(ii)
           total_correct_train = total_correct_train + 1;
       end
   end
   CCR_train(index) = total_correct_train/length(Y_Predict_train);
   
   total_correct_test = 0;
   for ii = 1:length(Y_Predict_test)
       if testing_labels(ii) == Y_Predict_test(ii)
           total_correct_test = total_correct_test + 1;
       end
   end
   CCR_test(index) = total_correct_test/length(Y_Predict_test);
   index = index + 1;
end

plot(x_axis, CCR_train, x_axis, CCR_test);
