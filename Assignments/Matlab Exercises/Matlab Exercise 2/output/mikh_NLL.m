function [ result ] = NLL( X, Y, W, n, m, d )
    %Negative log-likelihood function of logistic regression
    %X - input samples [n x d]
    %Y - labels for input samples [n x 1]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of dimensions
    
    total_a = 0;
    for j = 1:n
        total = 0;
        for k = 1:m
            exponent = W(:, k)'*X(j,:)';
            total = total + exp(exponent);
        end
        total_a = total_a + log(total);
    end
    
    total_b = 0;
    for k = 1:m
        total = zeros(d, 1);
        for j = 1:n
            if(Y(j) == k)
                 total = total + X(j,:)';
            end
        end
        total_b = total_b + (W(:, k)'*total);
    end
    
    result = total_a - total_b;
end

