function [Y_predicted] = test(X, W, n)

    %X - input samples [n x d]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of dimensions

    Y_predicted = zeros(n, 1);

    for ii = 1:n
        x_test = X(ii,:)';
        gradient_matrix = W'*x_test;
        gradient_matrix = exp(gradient_matrix);
        alpha = sum(gradient_matrix);
        gradient_matrix = gradient_matrix./alpha;
        [max_v, max_i] = max(gradient_matrix);
        Y_predicted(ii) = max_i;
    end
end
