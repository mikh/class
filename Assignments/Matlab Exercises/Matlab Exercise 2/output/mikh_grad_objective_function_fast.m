function [ result ] = mikh_grad_objective_function_fast( X, Y, W, n, m, d, lambda )
    %gradient of objective function
    %X - input samples [n x d]
    %Y - labesl for input samples [n x 1]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of parameters
    %lambda - constant
    total_a = mikh_grad_NLL_fast(X,Y,W,n,m, d);
    total_b = W .* lambda;
    result = total_a + total_b;
end
