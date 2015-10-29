function [ logloss ] = calculate_logloss( X, Y, W, n )
    logloss = 0;
    for ii = 1:n
        x_test = X(ii,:)';
        gradient_matrix = W'*x_test;
        gradient_matrix = exp(gradient_matrix);
        alpha = sum(gradient_matrix);
        gradient_matrix = gradient_matrix./alpha;
        
        p = gradient_matrix(Y(ii));
        if p < 10^(-10)
            p = 10^(-10);
        end
        logloss = logloss + log(p);
    end
    logloss = logloss * (-1/n);

end

