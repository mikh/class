function [ result ] = mikh_grad_objective_function( X, Y, W, n, m, d, yy, lambda )
    %gradient of objective function
    %X - input samples [n x d]
    %Y - labesl for input samples [n x 1]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of parameters
    %yy - used y
    %lambda - constant
    total_a = mikh_grad_NLL(X,Y,W,n,m, d,yy);
    total_b = W(:,yy) .* lambda;
    result = total_a + total_b;
end

