%% start
clc;
clear;
close all
fprintf('Running Matlab 4 Problem 1 b\n');

%% create D1 D2

colors = {'r', 'b', 'g', 'k'};
[Data1, D1_labels] = sample_circle(3, [500, 500, 500]);
[Data2, D2_labels] = sample_spiral(3, [500, 500, 500]);
N = length(D1_labels);

sigma = 0.2;

S1 = zeros(N, N);
S2 = zeros(N, N);
for ii = 1:N
    for jj = 1:N
        S1(ii, jj) = exp( -1*((Data1(ii,1)-Data1(jj,1))^2 + (Data1(ii,2)-Data1(jj,2))^2)/(2*sigma^2));
        S2(ii, jj) = exp( -1*((Data2(ii,1)-Data2(jj,1))^2 + (Data2(ii,2)-Data2(jj,2))^2)/(2*sigma^2));
    end
end
W1 = S1;
W2 = S2;

D1 = diag(sum(W1'));
D2 = diag(sum(W2'));
clear ii jj
f = figure(5);

for k = 2:4

    %% un-normalized spectral clustering
    L1 = D1 - W1;
    L2 = D2 - W2;
    [eigen_V1, eigen_D1] = eigs(L1, k, 'sm');
    [eigen_V2, eigen_D2] = eigs(L2, k, 'sm');
    rng(2);
    [Y_u1, C_u1] = kmeans(eigen_V1, k, 'Replicates', 20, 'Distance', 'sqeuclidean');
    rng(2);
    [Y_u2, C_u2] = kmeans(eigen_V2, k, 'Replicates', 20, 'Distance', 'sqeuclidean');

    %% normalized spectral clustering - random walk
    L1 = D1 - W1;
    L_rw1 = (D1^(-1))*L1;
    [eigen_V_rw1, eigen_D_rw1] = eigs(L_rw1, k, 'sm');
    rng(2);
    [Y_rw1, C_rw1] = kmeans(eigen_V_rw1, k, 'Replicates', 20, 'Distance', 'sqeuclidean');

    L2 = D2 - W2;
    L_rw2 = (D2^(-1))*L2;
    [eigen_V_rw2, eigen_D_rw2] = eigs(L_rw2, k, 'sm');
    rng(2);
    [Y_rw2, C_rw2] = kmeans(eigen_V_rw2, k, 'Replicates', 20, 'Distance', 'sqeuclidean');

    %% normalized spectral clustering - symmetric normalization
    L1 = D1 - W1;
    L_sym1 = (D1^(-.5))*L1*(D1^(-.5));
    [eigen_V_sym1, eigen_D_sym1] = eigs(L_sym1, k, 'sm');
    norms = sqrt(sum((eigen_V_sym1.^2)'));
    for ii = 1:length(norms)
        eigen_V_sym1(ii, :) = eigen_V_sym1(ii, :) ./ norms(ii);
    end

    rng(2);
    [Y_sym1, C_sym1] = kmeans(eigen_V_sym1, k, 'Replicates', 20, 'Distance', 'sqeuclidean');

    L2 = D2 - W2;
    L_sym2 = (D2^(-.5))*L2*(D2^(-.5));
    [eigen_V_sym2, eigen_D_sym2] = eigs(L_sym2, k, 'sm');
    norms = sqrt(sum((eigen_V_sym2.^2)'));
    for ii = 1:length(norms)
        eigen_V_sym2(ii, :) = eigen_V_sym2(ii, :) ./ norms(ii);
    end

    rng(2);
    [Y_sym2, C_sym2] = kmeans(eigen_V_sym2, k, 'Replicates', 20, 'Distance', 'sqeuclidean');

    subplot(3,2, (k - 2)*2 + 1);
    hold on
    for jj = 1:k
        subdata = Data1(Y_sym1 == jj, :);
        scatter(subdata(:,1), subdata(:,2), colors{jj});
    end
    hold off
    title(sprintf('Symmetric clustering for k = %d with circle points', k));
    subplot(3,2, (k - 2)*2 + 2);
    hold on
    for jj = 1:k
        subdata = Data2(Y_sym2 == jj, :);
        scatter(subdata(:,1), subdata(:,2), colors{jj});
    end
    hold off
    title(sprintf('Symmetric clustering for k = %d with spiral points', k));

    if k == 3
        V_u1 = eigen_V1;
        V_u2 = eigen_V2;
        Y_3_u1 = Y_u1;
        Y_3_u2 = Y_u2;
        V_rw1 = eigen_V_rw1;
        V_rw2 = eigen_V_rw2;
        Y_3_rw1 = Y_rw1;
        Y_3_rw2 = Y_rw2;
        V_sym1 = eigen_V_sym1;
        V_sym2 = eigen_V_sym2;
        Y_3_sym1 = Y_sym1;
        Y_3_sym2 = Y_sym2;
    end
end

%% Plot eigenvalues
eigenvals_u1 = eigs(L1, 1500, 'sm');
eigenvals_u2 = eigs(L2, 1500, 'sm');
eigenvals_rw1 = eigs(L_rw1, 1500, 'sm');
eigenvals_rw2 = eigs(L_rw2, 1500, 'sm');
eigenvals_sym1 = eigs(L_sym1, 1500, 'sm');
eigenvals_sym2 = eigs(L_sym2, 1500, 'sm');

f = figure(4);
subplot(3,2,1);
plot(1:1500, eigenvals_u1);
title('Eigenvalues for un-normalized spectral clustering for circle graph');
xlabel('k');
ylabel('eigenvalues');

subplot(3,2,2);
plot(1:1500, eigenvals_u2);
title('Eigenvalues for un-normalized spectral clustering for spiral graph');
xlabel('k');
ylabel('eigenvalues');

subplot(3,2,3);
plot(1:1500, eigenvals_rw1);
title('Eigenvalues for random walk spectral clustering for circle graph');
xlabel('k');
ylabel('eigenvalues');

subplot(3,2,4);
plot(1:1500, eigenvals_rw2);
title('Eigenvalues for random walk spectral clustering for spiral graph');
xlabel('k');
ylabel('eigenvalues');

subplot(3,2,5);
plot(1:1500, eigenvals_sym1);
title('Eigenvalues for symmetric spectral clustering for circle graph');
xlabel('k');
ylabel('eigenvalues');

subplot(3,2,6);
plot(1:1500, eigenvals_sym2);
title('Eigenvalues for symmetric spectral clustering for spiral graph');
xlabel('k');
ylabel('eigenvalues');

%% Plot 3d
f = figure(6);
grid on

subplot(3,2,1);
hold on
grid on
for ii = 1:3
    subdata = V_u1(Y_3_u1 == ii, :);
    plot3(subdata(:,1), subdata(:, 2), subdata(:, 3), colors{ii});
end
hold off
title('Eigenvectors for un-normalized spectral clustering for k = 3 on circle dataset');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

subplot(3,2,2);
hold on
grid on
for ii = 1:3
    subdata = V_u2(Y_3_u2 == ii, :);
    plot3(subdata(:,1), subdata(:, 2), subdata(:, 3), colors{ii});
end
hold off
title('Eigenvectors for un-normalized spectral clustering for k = 3 on spiral dataset');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

subplot(3,2,3);
hold on
grid on
for ii = 1:3
    subdata = V_rw1(Y_3_rw1 == ii, :);
    plot3(subdata(:,1), subdata(:, 2), subdata(:, 3), colors{ii});
end
hold off
title('Eigenvectors for random walk spectral clustering for k = 3 on circle dataset');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

subplot(3,2,4);
hold on
grid on
for ii = 1:3
    subdata = V_rw2(Y_3_rw2 == ii, :);
    plot3(subdata(:,1), subdata(:, 2), subdata(:, 3), colors{ii});
end
hold off
title('Eigenvectors for random walk spectral clustering for k = 3 on spiral dataset');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

subplot(3,2,5);
hold on
grid on
for ii = 1:3
    subdata = V_sym1(Y_3_sym1 == ii, :);
    plot3(subdata(:,1), subdata(:, 2), subdata(:, 3), colors{ii});
end
hold off
title('Eigenvectors for symmetric spectral clustering for k = 3 on circle dataset');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

subplot(3,2,6);
hold on
grid on
for ii = 1:3
    subdata = V_sym2(Y_3_sym2 == ii, :);
    plot3(subdata(:,1), subdata(:, 2), subdata(:, 3), colors{ii});
end
hold off
title('Eigenvectors for symmetric spectral clustering for k = 3 on spiral dataset');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');