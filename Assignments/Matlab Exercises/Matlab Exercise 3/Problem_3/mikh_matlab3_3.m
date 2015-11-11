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



%% Complete
fprintf('matlab3-3 done. (%.2fs)\n', etime(clock,t1));