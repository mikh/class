clc 
clear

load 'data_knnSimulation.mat'
[N, K] = size(Xtrain);
figure(1);
gscatter(Xtrain(:,1),Xtrain(:,2),ytrain, 'rgb');
title('Scatter plot of k-NN training data.');
xlabel('x-coordinates');
ylabel('y-coordinates');

x_axis = -3.5:0.1:6;
y_axis = -3:0.1:6.5;

grid = zeros(length(x_axis), length(y_axis), N);

x_index = 1;
y_index = 1;
for ii = x_axis
    y_index = 1;
    for jj = y_axis
        distances = zeros(N,1);
        for kk = 1:N
            distances(kk) = sqrt((Xtrain(kk,1)-ii)^2 + (Xtrain(kk,2) - jj)^2);
        end
        grid(x_index, y_index, :) = distances;

        y_index = y_index + 1;
    end
    x_index = x_index + 1;
end

grid_2_p = zeros(length(x_axis), length(y_axis));
grid_3_p = zeros(length(x_axis), length(y_axis));
grid_k1 = zeros(length(x_axis), length(y_axis));
grid_k5 = zeros(length(x_axis), length(y_axis));
        
for ii = 1:length(x_axis)
    for jj = 1:length(y_axis)
        [sorted_values, sorted_indices] = sort(grid(ii,jj,:));
        classes = zeros(10,1);
        for kk = 1:10
            classes(kk) = ytrain(sorted_indices(kk));
        end
        grid_2_p(ii,jj) = length(find(classes==2))/10;
        grid_3_p(ii,jj) = length(find(classes==3))/10;
        grid_k1(ii,jj) = classes(1);
        grid_k5(ii,jj) = mode(classes(1:5));
    end
end

figure(2);
imagesc([min(x_axis), max(x_axis)], [min(y_axis), max(y_axis)], grid_2_p);
colorbar;
title('Probabilities of points being class 2');
xlabel('x-coordinates');
ylabel('y-coordinates');
figure(3);
imagesc([min(x_axis), max(x_axis)], [min(y_axis), max(y_axis)],grid_3_p);
colorbar;
title('Probabilities of points being class 3');
xlabel('x-coordinates');
ylabel('y-coordinates');

map = [1,0,0;0,1,0;0,0,1];
figure(4);
imagesc([max(x_axis), min(x_axis)], [min(y_axis), max(y_axis)],grid_k1);
colorbar;
title('Classification areas for k=1');
xlabel('x-coordinates');
ylabel('y-coordinates');
colormap(map);

figure(5);
imagesc([max(x_axis), min(x_axis)], [min(y_axis), max(y_axis)],grid_k5);
colorbar;
title('Classification areas for k=5');
xlabel('x-coordinates');
ylabel('y-coordinates');
colormap(map);