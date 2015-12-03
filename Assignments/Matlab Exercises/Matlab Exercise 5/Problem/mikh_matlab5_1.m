%% start
clc;
clear;
close all
fprintf('Starting matlab 5\n\n');
c = 0;
d = 3;
sigma = 4;

%% part a
load('helix.mat');
X_h = X;
t_h = tt;
load('swiss.mat');
X_s = X;
t_s = tt;
clear X tt

f1 = figure(1);
grid on
scatter3(X_h(1,:), X_h(2,:), X_h(3, :), 20, t_h);
view([12 20])
title('Helix graph');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
saveas(f1, 'helix.fig');
saveas(f1, 'helix.png');

f2 = figure(2);
grid on
scatter3(X_s(1, :), X_s(2, :), X_s(3, :), 20, t_s);
view([12 20])
title('Swiss roll graph');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
saveas(f2, 'swiss_roll.fig');
saveas(f2, 'swiss_roll.png');


%% part b
N = length(t_h);
K_h = zeros(3, N, N);
K_s = zeros(3, N, N);
H = eye(N) - (ones(N, 1)*ones(1, N)*(1/N));


%construct kernels
for x = 1:N
    for y = 1:N
        %linear
        K_h(1, x, y) = dot(X_h(:, x), X_h(:, y)) + c;
        K_s(1, x, y) = dot(X_s(:, x), X_s(:, y)) + c;
        
        %polynomial
        K_h(2, x, y) = (dot(X_h(:, x), X_h(:, y)) + c)^d;
        K_s(2, x, y) = (dot(X_s(:, x), X_s(:, y)) + c)^d;
        
        %rbf
        K_h(3, x, y) = exp(-1*(sum((X_h(:,x) - X_h(:, y)).^2))/(2*sigma^2));
        K_s(3, x, y) = exp(-1*(sum((X_s(:,x) - X_s(:, y)).^2))/(2*sigma^2));
    end
end

for z = 1:3
    K_h(z, :, :) = H * squeeze(K_h(z, :, :)) * H;
    K_s(z, :, :) = H * squeeze(K_s(z, :, :)) * H;
end