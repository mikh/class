function [ result ] = objective_function( X, Y, W, n, m, d , lambda)
    %l2 - regularized objective function
    %X - input samples [n x d]
    %Y - labels for input samples [n x 1]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of paramters
    %lambda - constant
    
    total_a = NLL(X, Y, W, n, m, d);
    total_b = 0;
    
    for k = 1:m
        w_temp = W(:, k);
        w_temp = w_temp .^ 2;
        total_b = total_b + sum(w_temp);
    end
    
    result = total_a + (lambda/2*total_b);
end

