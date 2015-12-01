%% start
clc;
clear;
fprintf('Running Matlab 4 Problem 1 a\n');


%% part a
colors = {'r', 'b', 'g', 'k'};
cluster_distances = zeros(2,4);
[D1, D1_labels] = sample_circle(3, [500, 500, 500]);
[D2, D2_labels] = sample_spiral(3, [500, 500, 500]);

for ii = 2:4    
   rng(2);
   [Y1, C1] = kmeans(D1, ii, 'Replicates', 20, 'Distance', 'sqeuclidean');
   rng(2);
   [Y2, C2] = kmeans(D2, ii, 'Replicates', 20, 'Distance', 'sqeuclidean');
   
   f = figure(ii-1);
   title_string = sprintf('k-means for k=%d on circle and spiral datasets', ii);
   title(title_string);
   
   subplot(1,2,1);
   hold on
   for jj = 1:ii
    D1_subdata = D1(Y1 == jj, :);
    scatter(D1_subdata(:,1), D1_subdata(:,2), colors{jj});  
    scatter(C1(jj, 1), C1(jj, 2), 100, 'c', 'filled');
    cluster_distances(1, jj) = cluster_distances(1, jj) + sum(sqrt( (C1(jj,1) - D1_subdata(:,1)).^2 + (C1(jj,2) - D1_subdata(:, 2)).^2 ));
   end
   hold off
   title(sprintf('k-means for k=%d on circle datasets', ii));
   
   subplot(1,2,2);
   hold on
   for jj = 1:ii
    D2_subdata = D2(Y2 == jj, :);
    scatter(D2_subdata(:,1), D2_subdata(:,2), colors{jj}); 
    scatter(C2(jj, 1), C2(jj, 2), 100, 'c', 'filled');
    cluster_distances(2, jj) = cluster_distances(2, jj) + sum(sqrt( (C2(jj,1) - D2_subdata(:,1)).^2 + (C2(jj,2) - D2_subdata(:, 2)).^2 ));
   end
   hold off
   title(sprintf('k-means for k=%d on spiral datasets', ii));
end

cluster_distances(:,1) = cluster_distances(:,1)/3;
cluster_distances(:,2) = cluster_distances(:,2)/3;
cluster_distances(:,3) = cluster_distances(:,3)/2;

for ii = 1:4
    fprintf('Overall centroid distance for cluster %d: circle: %f, spiral: %f\n', ii, cluster_distances(1, ii), cluster_distances(2, ii));
end