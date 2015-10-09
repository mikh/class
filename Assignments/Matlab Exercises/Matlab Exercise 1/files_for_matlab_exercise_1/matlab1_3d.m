clear
clc

load 'data_mnist_train.mat'
load 'data_mnist_test.mat'

%imshow(reshape(X_train(200,:), 28, 28)');

[N_train, D] = size(X_train);
[N_test, D] = size(X_test);

Y_predicted = zeros(N_test, 1);
CCR = 0;

iters = 1;
for ii = 1:N_test  %test loop
    if iters == 100
        fprintf('%.2f%% complete.\n', 100*ii/N_test);
        iters = 0;
    end
    iters = iters + 1;
    best_class = -1;
    best_distance = -1;
    test_s = X_test(ii, :);
    for jj = 1:N_train %train loop
        train_s = X_train(jj, :);
        distance = sum(abs(train_s - test_s));
        if (best_distance == -1) || (best_distance > distance)
            best_distance = distance;
            best_class = Y_train(jj);
        end
    end
    Y_predicted(ii) = best_class;
    if best_class == Y_test(ii)
        CCR = CCR + 1;
    end
end

fprintf('CCR = %.2f (%.2f%%)\n', CCR, CCR * 100/N_test); 