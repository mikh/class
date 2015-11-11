%% Init
clear;
clc;

fprintf('Running matlab3 part 3...\n');
t1 = clock;

colors = ['r', 'g', 'k', 'c', 'm', 'y'];


%% Load data
fprintf('Loading quad_data.mat...\t');
t2 = clock;
load('quad_data.mat');
fprintf('Done. (%.2fs)\n', etime(clock, t2));

%% part a first graph
OLS_poly = cell(14,1);
N = length(xtrain);
for ii = 1:14
    X = xtrain;
    for jj = 2:ii
        X = [X, xtrain.^jj];
    end
	OLS_poly{ii} = ridge(ytrain, X, 0, 0);
end

figure(1);
hold on;
grid on;
graphs = zeros(5,1);
graphs(1) = scatter(xtrain, ytrain, 'b', 'filled');

color_index = 1;
for ii = 1:14
	if (ii == 2) || (ii == 6) || (ii == 10) || (ii == 14)
		y_plot = zeros(N,1);
		polynomial = OLS_poly{ii};
		for jj = 1:ii+1
			y_plot = y_plot + (xtrain.^(jj-1))*polynomial(jj);
		end
		%y_plot = (xtrain.^ii)*polynomial(2) + polynomial(1);

		graphs(color_index+1) = plot(xtrain, y_plot, colors(color_index), 'LineWidth', 2);
        color_index = color_index + 1;
	end
end
title('ridge regression curve fitting for different polynomials');
xlabel('x-axis');
ylabel('y-axis');
legend(graphs,'Training Data', '2nd order polynomial', '6th order polynomial', '10th order polynomial', '14th order polynomial'); 
ylim([min(ytrain)-5, max(ytrain) + 5])
hold off

%% part a second graph

predict = zeros(14, 2);

for ii = 1:14
    res1 = zeros(length(ytrain), 1);
    res2 = zeros(length(ytest), 1);
    poly = OLS_poly{ii};
    for jj = 1:ii + 1
        res1 = res1 + (xtrain .^ (jj-1))*poly(jj);
        res2 = res2 + (xtest .^ (jj-1))*poly(jj);
    end
    
    res1 = sum(abs(ytrain - res1).^2)*1/length(ytrain);
    res2 = sum(abs(ytest - res2).^2)*1/length(ytest);
    
    predict(ii,1) = res1;
    predict(ii,2) = res2;
end
figure(2);
hold on
grid on
p1 = plot(1:14, predict(:,1), 'b', 'LineWidth', 2);
p2 = plot(1:14, predict(:,2), 'r', 'LineWidth', 2);
title('MSE rates of training and testing sets for different orders of polynomial resgression');
xlabel('polynomial order');
ylabel('MSE');
legend([p1,p2], 'Training MSE', 'Testing MSE');
y_pred_train = zeros(length(ytrain),1);

%% part b
X = zeros(length(ytrain), 10);
for ii = 1:10
    X(:, ii) = xtrain .^ ii;
end
MSE_train = zeros(length(-25:5), 1);
MSE_test = zeros(length(-25:5), 1);
for lambda = -25:5
    poly_10 = ridge(ytrain, X, lambda, 0);
    res1 = zeros(length(ytrain), 1);
    res2 = zeros(length(ytest), 1);
    
    for jj = 1:11
        res1 = res1 + (xtrain .^ (jj-1))*poly_10(jj);
        res2 = res2 + (xtest .^ (jj-1))*poly_10(jj);
    end
    res1 = sum(abs(ytrain - res1).^2)*1/length(ytrain);
    res2 = sum(abs(ytest - res2).^2)*1/length(ytest);

    MSE_train(lambda+26) = res1;
    MSE_test(lambda+26) = res2;
end

figure(3);
hold on
grid on
p1 = plot(-25:5, MSE_train, 'b', 'LineWidth', 2);
p2 = plot(-25:5, MSE_test, 'r', 'LineWidth', 2);
title('MSE rate for training and testing sets for different lambda');
xlabel('lambda');
ylabel('MSE');
legend([p1,p2], 'Training MSE', 'Testing MSE');

[min_v, min_i] = min(MSE_test);
fprintf('log(lambda) = %d\n', min_i - 26);
plot_10_0 = ridge(ytrain, X, 0, 0);
plot_10_l2 = ridge(ytrain, X, min_i-26, 0);


res1 = zeros(length(ytest), 1);
res2 = zeros(length(ytest), 1);

for jj = 1:11
    res1 = res1 + (xtest .^ (jj-1))*plot_10_0(jj);
    res2 = res2 + (xtest .^ (jj-1))*plot_10_l2(jj);
end


figure(4);
hold on
grid on
s = scatter(xtest, ytest, 'b', 'filled');
p1 = plot(xtest, res1, 'r', 'LineWidth', 2);
p2 = plot(xtest, res2, 'g', 'LineWidth', 2);
title('Comparison of regressions using OLS and ridge regression');
xlabel('x-axis');
ylabel('y-axis');
legend([s,p1,p2], 'Data', 'OLS', 'ridge');



%% Complete
fprintf('matlab3-3 done. (%.2fs)\n', etime(clock,t1));