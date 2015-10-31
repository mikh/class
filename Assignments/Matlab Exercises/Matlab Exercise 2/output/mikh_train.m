function [obj_fnc, grad_obj_fnc] = train(X, Y, C, W, n, m, d, lambda)

    %X - input samples [n x d]
    %Y - labels for input samples [n x 1]
    %C - sample sum matrix [d x m]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of dimensions

    A = zeros(d,m);
    B = 0;
    obj_fnc = 0;

    for j = 1:n
    	exponent_matrix = exp(W'*X(j,:)');
    	alpha = sum(exponent_matrix);
    	exponent_matrix = exponent_matrix ./ alpha;
    	exponent_matrix(Y(j)) = exponent_matrix(Y(j)) - 1;
    	exponent_matrix = (exponent_matrix * X(j,:))';
    	A = exponent_matrix + W .* lambda;
    	B = B + log(alpha);
    end
    obj_fnc = sum(diag(W'*C));

    grad_obj_fnc = A + W .* lambda;
    obj_fnc = obj_fnc + (lambda/2)*sum(sum(W.^2));
end
