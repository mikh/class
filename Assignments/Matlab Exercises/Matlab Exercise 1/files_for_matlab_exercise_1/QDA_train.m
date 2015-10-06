function [QDAmodel]= QDA_train(X_train, Y_train, numofClass)
% Training QDA
%
% EC 500 Learning from Data
% Fall semester, 2015
% by Prakash Ishwar
%
% Problem 1.1 Gaussian Discriminant Analysis
% Assuming D = dimension of data
% Inputs:
% X_train : training data matrix, each row is a training data point
% Y_train : training labels for rows of X_train; the classes are labeled
% from 1 to numofClass
% numofClass : number of class 
%
% output:
% QDAmodel: the parameters of QDA classifier which has the follwoing fields
% Mu : a numofClass * D matrix, i-th row = mean vector of class i
% Sigma : a D*D*numofClass array, Sigma(:,:,i) = covariance of class i
% pi : a numofClass *1 vector, pi(i) = prior probability of class i

% output:
% Y_predict predicted labels for all the testing data points in X_test

% Write your code here:
    M = numofClass;
	[N, D] = size(X_train);

	n_y = zeros(1,M);
	p_y = zeros(1,M);
    u_y = zeros(M,D);
    cov_matrix = zeros(D, D, M);
   
    
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
            u_y(k, jj) = u_y(k, jj) + ((1/n_y(k))*X_train(ii, jj));
        end
    end
    
    %find covariance matrices
    for ii = 1:N
       k = Y_train(ii);
       cov_ii = (1/n_y(k)).*((X_train(ii,:) - u_y(k,:))' * (X_train(ii,:) - u_y(k,:)));
       cov_matrix(:,:,k) = cov_matrix(:,:,k) + cov_ii(:,:);
    end

    QDAmodel = struct('Mu', u_y, 'Sigma', cov_matrix, 'pi', p_y');
end