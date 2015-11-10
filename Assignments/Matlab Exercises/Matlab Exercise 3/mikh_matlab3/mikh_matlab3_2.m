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

%% part b
fprintf('Using robustfit...\n');
t2 = clock;
r1 = robustfit(xData, yData, 'cauchy', 2.385, 'on');
r2 = robustfit(xData, yData, 'fair', 1.400, 'on');
r3 = robustfit(xData, yData, 'huber', 1.345, 'on');
r4 = robustfit(xData, yData, 'talwar', 2.795, 'on');

MSE_1 = 1/length(xData) * sum(abs(yData - (xData' .* r1(2) + r1(1))').^2);
MSE_2 = 1/length(xData) * sum(abs(yData - (xData' .* r2(2) + r2(1))').^2);
MSE_3 = 1/length(xData) * sum(abs(yData - (xData' .* r3(2) + r3(1))').^2);
MSE_4 = 1/length(xData) * sum(abs(yData - (xData' .* r4(2) + r4(1))').^2);

MAD_1 = 1/length(xData) * sum(abs(yData - (xData' .* r1(2) + r1(1))'));
MAD_2 = 1/length(xData) * sum(abs(yData - (xData' .* r2(2) + r2(1))'));
MAD_3 = 1/length(xData) * sum(abs(yData - (xData' .* r3(2) + r3(1))'));
MAD_4 = 1/length(xData) * sum(abs(yData - (xData' .* r4(2) + r4(1))'));

fprintf('For %s, MSE = %f, MAD = %f\n', 'cauchy', MSE_1, MAD_1);
fprintf('For %s, MSE = %f, MAD = %f\n', 'fair', MSE_2, MAD_2);
fprintf('For %s, MSE = %f, MAD = %f\n', 'huber', MSE_3, MAD_3);
fprintf('For %s, MSE = %f, MAD = %f\n', 'talwar', MSE_4, MAD_4);

fprintf('For huber, w = %f, b = %f\n', r3(2), r3(1));

figure(1);
hold on;
grid on;
s = scatter(xData, yData, 'filled');
p1 = plot(xData, r1(1) + r1(2)*xData, 'r', 'LineWidth', 2);
p2 = plot(xData, r2(1) + r2(2)*xData, 'g', 'LineWidth', 2);
p3 = plot(xData, r3(1) + r3(2)*xData, 'k', 'LineWidth', 2);
p4 = plot(xData, r4(1) + r4(2)*xData, 'c', 'LineWidth', 2);
p5 = plot(xData, b + W*xData, 'y', 'LineWidth', 2);
title('Comparing robust fit regressions with different loss functions');
xlabel('x-data');
ylabel('y-data');
legend([s, p1, p2, p3, p4, p5], 'Data', 'cauchy loss function', 'fair loss function', 'huber loss function', 'talwar loss function', 'OLS');
hold off

fprintf('Done. (%.2fs)\n',etime(clock, t2));

%% Complete
fprintf('matlab3-1 done. (%.2fs)\n', etime(clock,t1));