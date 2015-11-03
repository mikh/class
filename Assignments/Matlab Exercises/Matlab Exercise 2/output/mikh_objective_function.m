function [ result ] = mikh_objective_function( X, Y, W, n, m, d , lambda)
    %l2 - regularized objective function
    %X - input samples [n x d]
    %Y - labels for input samples [n x 1]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of paramters
    %lambda - constant
    
    total_a = mikh_NLL(X, Y, W, n, m, d);
    total_b = 0;

    total_b = sum(sum(W.^2));
    
    result = total_a + (lambda/2*total_b);
end

