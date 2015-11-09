%% Init
clear;
clc;

fprintf('Running matlab3 part 2...\n');
t1 = clock;


%% Load data
fprintf('Loading linear_data.mat...\t');
t2 = clock;
load('linear_data.mat');
fprintf('Done. (%.2fs)\n', etime(clock, t2));

%% part a
fprintf('Implementing OLS...\t');
t2 = clock;
W = (xData'*xData)^(-1) * xData' * yData;
b = mean(yData - xData * W);

y_pred = (xData' .* W)' + b;
MSE = 1/length(xData) * sum(abs(yData - y_pred).^2);
MAD = 1/length(xData) * sum(abs(yData - y_pred));

fprintf('MSE = %f\n', MSE);
fprintf('MAD = %f\n', MAD);

fprintf('Done. (%.2fs)\n', etime(clock, t2));

%% Complete
fprintf('matlab3-1 done. (%.2fs)\n', etime(clock,t1));