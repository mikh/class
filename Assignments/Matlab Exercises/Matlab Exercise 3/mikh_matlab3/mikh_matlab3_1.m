%% Init
clear;
clc;

fprintf('Running matlab3 part 1...\n');
t1 = clock;


%% Load data
fprintf('Loading housing_data.mat...\t');
t2 = clock;
load('housing_data.mat');
fprintf('Done. (%.2fs)\n', etime(clock, t2));

%% part a
fprintf('Training tree...\t');
t2=clock;
% Need to use MinLeaf for it to work with Matlab 2014a. Otherwise use MinLeafNode
tree = fitrtree(Xtrain,ytrain, 'MinLeaf', 20);
view(tree, 'Mode', 'graph');
fprintf('Done. (%.2fs)\n', etime(clock, t2));

%% part b
fprintf('Testing on a single sample...\t');
t2=clock;
example = [5,18,2.31,1,0.5440,2,64,3.7,1,300,15,390,10];
y = predict(tree,example);
fprintf('Done. (%.2fs)\n', etime(clock,t2));
fprintf('MEDV = %f\n', y);


%% part c
fprintf('Calculating training and testing MAE...\t');
t2=clock;

MAE_train = zeros(25,1);
MAE_test = zeros(25,1);
for obs_per_leaf = 1:25
	tree = fitrtree(Xtrain, ytrain, 'MinLeaf', obs_per_leaf);
	y_predict_training = predict(tree, Xtrain);
	y_predict_testing = predict(tree, Xtest);
	MAE_train(obs_per_leaf) = sum(abs(y_predict_training - ytrain))/length(y_predict_training);
	MAE_test(obs_per_leaf) = sum(abs(y_predict_testing - ytest))/length(y_predict_testing);
end;
figure(1);
plot(1:25,MAE_train, 1:25,MAE_test);
title('Mean Absolute Value for Number of Observations per leaf');
xlabel('Observations per Leaf');
ylabel('Mean Absolute Error');
legend('Train data', 'Test data');

fprintf('Done. (%.2fs)\n', etime(clock,t2));

%% Complete
fprintf('matlab3-1 done. (%.2fs)\n', etime(clock,t1));