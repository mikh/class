function [LDAmodel]= RDA_train(X_train, Y_train,gamma, numofClass)
% Training LDA
%
% EC 500 Learning from Data
% Fall semester, 2015
% by Prakash Ishwar
%
% Assuming D = dimension of data
% Inputs:
% X_train : training data matrix, each row is a training data point
% Y_train : training labels for rows of X_train
% numofClass : number of class 
% Assuming that the classes are labeled  from 1 to numofClass
%
%
% Output:
% LDAmodel: the parameters of QDA classifier which has the follwoing fields
% Mu : numofClass * D matrix, i-th row = mean vector of class i
% Sigmapooled : D*D  covariance matrix
% pi : numofClass *1 vector, pi(i) = prior probability of class i

% output:
% Y_predict predicted labels for all the testing data points in X_test

% Write your code here:
	
	%first get the base LDA values
	LDAmodel = LDA_train(X_train, Y_train, numofClass);

	%now regularize the matrix
	S = LDAmodel.Sigmapooled;
	diag_matrix = diag(diag(S));

	S_new = gamma*diag_matrix + (1-gamma)*S;
	LDAmodel.Sigmapooled = S_new;
end