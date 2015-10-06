function [LDAmodel]= LDA_train(X_train, Y_train, numofClass)
% Training LDA
%
% EC 500 Learning from Data
% Fall semester, 2015
% by Prakash Ishwar
%
% Assuming D = dimension of data
% Inputs:m
% X_train : training data matrix, each row is a training data point
% Y_train : training labels for rows of X_train
% numofClass : number of class 
% Assuming that the classes are labeled  from 1 to numofClass
%
% Output:
% LDAmodel: the parameters of QDA classifier which has the follwoing fields
% Mu : numofClass * D matrix, i-th row = mean vector of class i
% Sigmapooled : D*D  covariance matrix
% pi : numofClass *1 vector, pi(i) = prior probability of class i

% output:
% Y_predict predicted labels for all the testing data points in X_test

% Write your codes here:
	M = numofClass;
	[N, D] = size(X_train);

	n_y = zeros(1,M);
	p_y = zeros(1,M);
    u_y = zeros(M,D);
    cov_matrix = zeros(D, D);

	%find ny
	for ii = 1:N
		n_y(Y_train(ii)) = n_y(Y_train(ii)) + 1;
	end

	%find p^(y)
	for ii = 1:M
        p_y(ii) = n_y(ii)/N;
	end

	%find u^y
    for ii = 1:N
        k = Y_train(ii);
        for jj = 1:D
            u_y(k, jj) = (u_y(k, jj)' + ((1/n_y(k))*X_train(ii, jj))');
        end
    end

	%find covariance matrix
    for ii = 1:N
        k = Y_train(ii);
        cov_n = ((1/N).*((X_train(ii,:) - u_y(k,:))' * (X_train(ii,:) - u_y(k,:))));
        cov_matrix = cov_matrix + cov_n;
    end   

    LDAmodel = struct('Mu', u_y, 'Sigmapooled', cov_matrix, 'pi', p_y');
end