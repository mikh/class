%% Init
clear;
clc;

fprintf('Running matlab3 part 4...\n');
t1 = clock;

colors = {'r', 'g', 'k', 'm', [.328,.328,.328], [.183, .308, .308], [1,.496, .140], [.406,.132,.542]};
MAX_ITERATIONS = 100;


%% Load data
fprintf('Loading prostateStnd.mat...\t');
t2 = clock;
load('prostateStnd.mat');
fprintf('Done. (%.2fs)\n', etime(clock, t2));


%% part a

[N, P] = size(Xtrain);
all_B = zeros(length(-5:10), P);
avg_B = zeros(MAX_ITERATIONS+1, P);

for lambda = -5:10
    B = zeros(MAX_ITERATIONS+1, P);
    B(1,:) = ones(1,P);
    iterations = 1;
    converged = 0;

    while (iterations <= MAX_ITERATIONS) && (converged == 0)
        iterations = iterations + 1;
        B(iterations, :) = B(iterations-1,:);
        
        for i = 1:P
            x_i = Xtrain(:,i);
            y_i = (ytrain - Xtrain*B(iterations,:)') + (x_i .* B(iterations, i));
            val = x_i' * y_i;
            
            if val < -1*lambda
                B(iterations, i) = (val + lambda)/(x_i'*x_i); 
            elseif val > lambda
                B(iterations, i) = (val + lambda)/(x_i'*x_i);
            else
                B(iterations, i) = 0;
            end
        end
        b_old = B(iterations-1,:);
        b_new = B(iterations, :);
        if isequal(b_old, b_new) == 1
            converged = 1;
        end
    end
    if iterations > MAX_ITERATIONS
        iterations = MAX_ITERATIONS;
    end
    all_B(lambda+6,:) = B(iterations,:);
    avg_B = avg_B + B;
end

figure(1);
hold on
grid on
plots = zeros(8,1);
lambda = -5:10;
for i = 1:8
    plots(i) = plot(lambda, all_B(:,i), 'Color', colors{i}, 'LineWidth', 2);
end
title('Coefficient values for different lambda');
xlabel('log(lambda)');
ylabel('Coefficient value');
legend(plots, 'lcavol', 'lweight', 'age', 'lbph', 'svi', 'lcp', 'gleason', 'pgg45')
hold off

y_pred_train = zeros(length(ytrain), length(lambda));
y_pred_test = zeros(length(ytest), length(lambda));

MSE_train = zeros(length(lambda), 1);
MSE_test = zeros(length(lambda), 1);

for lambda = -5:10
    for i = 1:length(ytrain)
        y_pred_train(i, lambda+6) = Xtrain(i, :)*all_B(lambda+6, :)';
    end
    for i = 1:length(ytest)
        y_pred_test(i, lambda+6) = Xtest(i, :)*all_B(lambda+6,:)';
    end
    MSE_train(lambda+6) = sum(abs(y_pred_train(:,lambda+6) - ytrain).^2)/length(ytrain);
    MSE_test(lambda+6) = sum(abs(y_pred_test(:,lambda+6) - ytest).^2)/length(ytest);
end

figure(2);
hold on
grid on
lambda = -5:10;
p1 = plot(lambda, MSE_train, 'r', 'LineWidth', 2);
p2 = plot(lambda, MSE_test, 'b', 'LineWidth', 2);
title('MSE rate for different lambda');
xlabel('log(lambda)');
ylabel('MSE');
legend([p1,p2], 'MSE for training set', 'MSE for testing set');
hold off

avg_B = abs(avg_B ./ 8);
avg_B_diff = zeros(MAX_ITERATIONS, P);
for i = 1:MAX_ITERATIONS
    avg_B_diff(i, :) = abs(avg_B(i+1,:) - avg_B(i, :));
end
figure(3);
hold on
grid on
plots = zeros(8,1);
for i = 1:8
    plots(i) = plot(1:MAX_ITERATIONS, avg_B_diff(:,i), 'Color', colors{i}, 'LineWidth', 2);
end
legend(plots, 'lcavol', 'lweight', 'age', 'lbph', 'svi', 'lcp', 'gleason', 'pgg45')
ylim([0 0.5]);
hold off

%% Complete
fprintf('matlab3-4 done. (%.2fs)\n', etime(clock,t1));