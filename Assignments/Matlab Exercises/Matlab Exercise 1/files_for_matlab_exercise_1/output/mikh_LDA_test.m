function [Y_predict] = LDA_test(X_test, LDAmodel, numofClass)
% Testing for QDA
%
% EC 500 Learning from Data
% Fall semester, 2015
% by Prakash Ishwar
%
% Assuming D = dimension of data
% Inputs:
% X_test : test data matrix, each row is a test data point
% numofClass : number of class 
% QDAmodel: the parameters of QDA classifier which has the follwoing fields
% QDAmodel.Mu : numofClass * D matrix, i-th row = mean vector of class i
% QDAmodel.Sigmapooled : D*D  covariance 
% QDAmodel.Pi : numofClass *1 vector, Pi(i) = prior probability of class i
%
% Assuming that the classes are labeled  from 1 to numofClass
%
% Output:
% Y_predict predicted labels for all the testing data points in X_test

% Write your codes here:
    M = numofClass;
    [N, D] = size(X_test);
    
    Y_predict = zeros(N,1);
    
    %precalculate the beta and gamma terms
    beta = zeros(M, D);
    gamma = zeros(M, 1);
    for jj = 1:M
       beta(jj, :) = LDAmodel.Mu(jj,:) * inv(LDAmodel.Sigmapooled);
       gamma(jj) = .5 * (beta(jj,:) * LDAmodel.Mu(jj,:)') + log(LDAmodel.pi(jj)); 
    end
    
    for ii = 1:N
       best_class = 0;
       best_class_result = 0;
       for jj = 1:M 
           rule_result = (beta(jj,:) * X_test(ii,:)') - gamma(jj);   
           if rule_result > best_class_result
               best_class_result = rule_result;
               best_class = jj;
           end
       end
       Y_predict(ii) = best_class;
    end
end