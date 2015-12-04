%% start
clc;
clear;
close all
fprintf('Starting matlab 5\n\n');
c = 0;
d = 3;
sigma = 4;
q=2;
knn = 7;

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

%compute eigenvalues and eigenvectors
f3 = figure(3);
kernel_type = {'linear', 'polynomial', 'rbf'};
grid on;

for z = 1:3
    rng('default');
    [V, D] = eigs(squeeze(K_h(z, :, :)), q);
    D = sqrt(D);
    enc = D*V';
    subplot(3,2,2*(z-1)+1);
    scatter(enc(1,:), enc(2,:), 20, t_h);
    title(strcat('Helix encoded to 2 dimensions with ',kernel_type{z},' kernel'));
    xlabel('x-axis');
    ylabel('y-axis');

    rng('default');
    [V, D] = eigs(squeeze(K_s(z, :, :)), q);
    D = sqrt(D);
    enc = D*V';
    subplot(3,2,2*(z-1)+2);
    scatter(enc(1,:), enc(2,:), 20, t_s);
    title(strcat('Swiss roll encoded to 2 dimensions with ' , kernel_type{z} , ' kernel'));
    xlabel('x-axis');
    ylabel('y-axis');
end


saveas(f3, '3kernels.fig')


%% part d

%%%TEMP%%%%%%%%%%%%%%%%%%%%%
%close all


%compute overall distance matrix
D_h = zeros(N, N);
D_s = zeros(N, N);

for ii = 1:N
    for jj = 1:N
        if ii == jj
            D_h(ii,jj) = 0;
            D_s(ii,jj) = 0;
        else
            D_h(ii, jj) = sqrt(sum((X_h(:, ii) - X_h(:, jj)).^2));
            D_s(ii, jj) = sqrt(sum((X_s(:, ii) - X_s(:, jj)).^2));
        end
    end
end

for ii = 1:N
    jj = ii+1;
    [vals, ind] = sort(D_h(ii, jj:N));
    if length(ind) > knn
        for zz = knn+1:length(ind)
            D_h(ii, (jj-1) + ind(zz)) = 0;
        end
    end
    [vals, ind] = sort(D_s(ii, jj:N));
    if length(ind) > knn
        for zz = knn+1:length(ind)
            D_s(ii, (jj-1) + ind(zz)) = 0;
        end
    end    
end

for ii = 1:N
    for jj = ii+1:N
        D_h(jj, ii) = D_h(ii, jj);
        D_s(jj, ii) = D_s(ii, jj);
    end
end

f4 = figure(4);
hold on
grid on
for ii = 1:N
    for jj = ii+1:N
        if(D_h(ii, jj) ~= 0)
            plot3([X_h(1, ii), X_h(1, jj)], [X_h(2, ii), X_h(2, jj)], [X_h(3, ii), X_h(3, jj)]);
        end
    end
end
view([12 20])
hold off
title(sprintf('kNN graph for Helix with k=%d', knn));
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
saveas(f4, 'helix_knn.fig');
saveas(f4, 'helix_knn.png');

f5= figure(5);
hold on;
grid on;
for ii = 1:N
    for jj = ii+1:N
        if(D_s(ii, jj) ~= 0)
            plot3([X_s(1, ii), X_s(1, jj)], [X_s(2, ii), X_s(2, jj)], [X_s(3, ii), X_s(3, jj)]);
        end
    end
end
view([12 20])
hold off
title(sprintf('kNN graph for Swiss Roll with k=%d', knn));
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
saveas(f5, 'swiss_knn.fig');
saveas(f5, 'swiss_knn.png');


D_h_sparse = sparse(D_h);
D_s_sparse = sparse(D_s);

dij_h = (dijkstra(D_h_sparse, 1:N)).^2;
dij_s = (dijkstra(D_s_sparse, 1:N)).^2;

H = eye(N) - (ones(N, 1)*ones(1, N)*(1/N));

K_h = H*dij_h*H .*-.5;
K_s = H*dij_s*H .*-.5;

f6 = figure(6);

rng('default');
[V, D] = eigs(K_h, q);
D = sqrt(D);
enc = D*V';
subplot(2,1,1);
scatter(enc(1,:), enc(2,:), 20, t_h);
title(strcat('Helix encoded to 2 dimensions with ISOMAP kernel'));
xlabel('x-axis');
ylabel('y-axis');

rng('default');
[V, D] = eigs(K_s, q);
D = sqrt(D);
enc = D*V';
subplot(2,1,2);
scatter(enc(1,:), enc(2,:), 20, t_s);
title(strcat('Swiss roll encoded to 2 dimensions with ISOMAP kernel'));
xlabel('x-axis');
ylabel('y-axis');
