%% start
clc;
clear;
fprintf('Running Matlab 4 Problem 1 c\n');

%% create D1 D2 D3

colors = {'r', 'b', 'g', 'k'};
[Data1, D1_labels] = sample_circle(3, [500, 500, 500]);
[Data2, D2_labels] = sample_spiral(3, [500, 500, 500]);
N = length(D1_labels);

[D3_c_a, D3_c_r] = cart2pol(Data1(:,1), Data1(:,2));
[D3_s_a, D3_s_r] = cart2pol(Data2(:,1), Data2(:,2));

min_a = min(D3_c_a);
D = D3_c_a + (-1*min_a);
max_a = max(D);
Dca = D ./ max_a;

min_a = min(D3_s_a);
D = D3_s_a + (-1*min_a);
max_a = max(D);
Dsa = D ./ max_a;

min_a = min(D3_c_r);
D = D3_c_r + (-1*min_a);
max_a = max(D);
Dcr = D ./ max_a;

min_a = min(D3_s_r);
D = D3_s_r + (-1*min_a);
max_a = max(D);
Dsr = D ./ max_a;
cluster_distances = zeros(4, 2);

%% kmeans
f = figure(7);
for k = 2:4
    rng(2);
    [Y, C] = kmeans([Dca, Dcr], k, 'Replicate', 20, 'Distance', 'cityblock');
    
    subplot(3, 2, (k-2)*2+1);
    hold on
    grid on
    for jj = 1:k
        subdata_a = D3_c_a(Y == jj, 1);
        subdata_r = D3_c_r(Y == jj, 1);
        scatter(subdata_r, subdata_a, colors{jj});
        C_a = C(jj, 1);
        C_r = C(jj, 2);
        mx = max(D3_c_a);
        mn = min(D3_c_a);
        C_a = C_a *(mx- mn);
        C_a = C_a + mn;
        
        mx = max(D3_c_r);
        mn = min(D3_c_r);
        C_r = C_r *(mx - mn);
        C_r = C_r + mn;
        scatter(C_r, C_a, 100, 'c', 'filled'); 
        
        cluster_distances(jj, 1) = cluster_distances(jj, 1) + sum( sqrt( (C_r - subdata_r).^2 + (C_a - subdata_a).^2   ));
    end
    
    hold off
    title(sprintf('Polar representation of kmeans for k = %d on circle data', k));
    xlabel('radius');
    ylabel('angle');
    
    rng(2);
    [Y, C] = kmeans([Dsa, Dsr], k, 'Replicate', 20, 'Distance', 'cityblock');
    
    subplot(3, 2, (k-2)*2+2);
    hold on
    grid on
    for jj = 1:k
        subdata_a = D3_s_a(Y == jj, 1);
        subdata_r = D3_s_r(Y == jj, 1);
        scatter(subdata_r, subdata_a, colors{jj});
        
        C_a = C(jj, 1);
        C_r = C(jj, 2);
        mx = max(D3_s_a);
        mn = min(D3_s_a);
        C_a = C_a *(mx- mn);
        C_a = C_a + mn;
        
        mx = max(D3_s_r);
        mn = min(D3_s_r);
        C_r = C_r *(mx - mn);
        C_r = C_r + mn;
        scatter(C_r, C_a, 100, 'c', 'filled'); 
        
        cluster_distances(jj, 2) = cluster_distances(jj, 2) + sum( sqrt( (C_r - subdata_r).^2 + (C_a - subdata_a).^2   ));
    end
    hold off
    title(sprintf('Polar representation of kmeans for k = %d on spiral data', k));
    xlabel('radius');
    ylabel('angle');
end

cluster_distances(1,:) = cluster_distances(1,:)/3;
cluster_distances(2,:) = cluster_distances(2,:)/3;
cluster_distances(3,:) = cluster_distances(3,:)/2;

for ii = 1:4
    fprintf('Overall centroid distance for cluster %d: circle: %f, spiral: %f\n', ii, cluster_distances(ii,1), cluster_distances(ii,2));
end
