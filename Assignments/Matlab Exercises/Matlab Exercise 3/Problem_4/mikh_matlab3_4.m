%% Init
clear;
clc;

fprintf('Running matlab3 part 4...\n');
t1 = clock;

colors = ['r', 'g', 'k', 'c', 'm', 'y'];
MAX_ITERATIONS = 100;


%% Load data
fprintf('Loading prostateStnd.mat...\t');
t2 = clock;
load('prostateStnd.mat');
fprintf('Done. (%.2fs)\n', etime(clock, t2));


%% part a

[N, P] = size(Xtrain);

lambda = -5;
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
    if 
end

%% Complete
fprintf('matlab3-4 done. (%.2fs)\n', etime(clock,t1));