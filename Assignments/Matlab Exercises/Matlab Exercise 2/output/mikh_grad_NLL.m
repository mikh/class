function [ result ] = mikh_grad_NLL( X, Y,  W, n, m, d, yy )
    %Gradient of NLL function 
    %X - input samples [n x d]
    %Y - labesl for input samples [n x 1]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of parameters
    %yy - used y

    result = 0;
    for j = 1:n
        exponent = W(:,yy)'*X(j,:)';
        top = exp(exponent);
        
        bottom = 0;
        for k = 1:m
            exponent = W(:, k)' * X(j,:)';
            bottom = bottom + exp(exponent);
        end
        
        total = top/bottom;
        if Y(j) == yy
            total = total - 1;
        end
        
        result = result + (total*X(j,:)');
    end
    
end

