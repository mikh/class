function [Y_predict] = QDA_test(X_test, QDAmodel, numofClass)
% Testing for QDA
%
% EC 500 Learning from Data
% Fall semester, 2015
% by Prakash Ishwar
%
% Assuming D = dimension of data
% Inputs:
% X_test : test data matrix, each row is a test data point
% 
% numofClass : number of class 
%
% QDAmodel: the parameters of QDA classifier which has the follwoing fields
% 
% QDAmodel.Mu : numofClass * D matrix, i-th row = mean vector of class i
% QDAmodel.Sigma : D*D*numofClass array, Sigma(:,:,i) = covariance of class i
% QDAmodel.Pi : numofClass *1 vector, Pi(i) = prior probability of class i
% 
% Assuming that the classes are labeled  from 1 to numofClass

% Output:
% Y_predict predicted labels for all the testing data points in X_test

% Write your codes here:
    M = numofClass;
	[N, D] = size(X_test);
    
    Y_predict = zeros(N,1);
    
    for ii = 1:N
       best_class = 0;
       best_class_value = -1;
       
       for jj = 1:M
           sub_x_u = (X_test(ii, :) - QDAmodel.Mu(jj, :));
           quadratic = (0.5)*(sub_x_u * inv(QDAmodel.Sigma(:,:,jj))) * sub_x_u';
           constant = (0.5)*log(det(QDAmodel.Sigma(:,:,jj))) - log(QDAmodel.pi(jj));
           rule = quadratic + constant;
           
           if (best_class_value == -1) || (best_class_value > rule)
               best_class_value = rule;
               best_class = jj;
           end
       end
       Y_predict(ii) = best_class;        
    end
end