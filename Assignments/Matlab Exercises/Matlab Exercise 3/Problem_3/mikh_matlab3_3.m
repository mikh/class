%% Init
clear;
clc;

fprintf('Running matlab3 part 3...\n');
t1 = clock;


%% Load data
fprintf('Loading quad_data.mat...\t');
t2 = clock;
load('quad_data.mat');
fprintf('Done. (%.2fs)\n', etime(clock, t2));

%% part a
OLS_poly = cell(14,1);
N = length(xtrain);
for ii = 1:14
	k = ones(N, ii);
	k(:,ii) = xtrain;
	OLS_poly{ii} = ridge(ytrain, k, 0, 0);
end

figure(1);
hold on;
grid on;
s = scatter(xtrain, ytrain, 'b');
for ii = 1:14
	if (ii==1) || (ii == 2) || (ii == 6) || (ii == 10) || (ii == 14)
		y_plot = zeros(N,1);
		polynomial = OLS_poly{ii};
		for jj = 1:ii+1
			y_plot = y_plot + (xtrain.^(jj-1))*polynomial(jj);
		end
		%y_plot = (xtrain.^ii)*polynomial(2) + polynomial(1);

		plot(xtrain, y_plot, 'LineWidth', 2);
	end
end
ylim([min(ytrain)-5, max(ytrain) + 5])

%% Complete
fprintf('matlab3-3 done. (%.2fs)\n', etime(clock,t1));