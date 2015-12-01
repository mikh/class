%% start
clc;
clear;
fprintf('Running Matlab 4 Problem 2\n');

%% load data

load('BostonListing.mat');
save_latitude = latitude;
save_longitude = longitude;

% mn = min(latitude);
% latitude = latitude - mn;
% mx = max(latitude);
% latitude = latitude ./ mx;
% 
% mn = min(longitude);
% longitude = longitude - mn;
% mx = max(longitude);
% longitude = longitude ./ mx;

colors = {'r', 'b', 'g', 'k', 'c'};
N = length(neighbourhood);
sigma = 0.01;

u = unique(neighbourhood);
M = length(u);
Y_truth = zeros(N, 1);
for ii = 1:N
    for jj = 1:M
        if strcmp(neighbourhood{ii}, u{jj}) == 1
            Y_truth(ii) = jj;
            break;
        end
    end
end
num_truth = zeros(M,1);
for ii = 1:M
    num_truth(ii) = sum(Y_truth == ii);
end
    

S = zeros(N,N);
for ii = 1:N
    for jj = 1:N
        S(ii, jj) = exp(-1*(sqrt( (latitude(ii)-latitude(jj))^2 + (longitude(ii)-longitude(jj))^2 )) / (2*sigma^2));
    end
end

D = diag(sum(S'));


%% spectral clustering

purity = zeros(25, 1);

for k = 1:25
    fprintf('k = %d\n', k);
    L = D-S;
    L = (D^(-.5)) * L * (D^(-.5));
    [eV, eD] = eigs(L, k, 'sm');
    norms = sqrt(sum((eV.^2)'));
    for ii = 1:length(norms)
        eV(ii, :) = eV(ii, :) ./ norms(ii);
    end
    rng(2);
    Y = kmeans(eV, k, 'Replicates', 20, 'Distance', 'sqeuclidean');
    
    
    for ii = 1:k
        objects_in_i = (Y == ii);
        max_match = 0;
        for jj = 1:M
            objects_in_j = (Y_truth == jj);
            match = and(objects_in_i, objects_in_j);
            num_match = sum(match);
            if max_match < num_match
                max_match = num_match;
            end
        end
        purity(k) = purity(k) + max_match/N;
    end
end

figure(8);
plot(1:25, purity);
title('Purity Metric');
xlabel('k');
ylabel('purity');
%%
k=5;
L = D-S;
   L = (D^(-.5)) * L * (D^(-.5));
    [eV, eD] = eigs(L, k, 'sm');
    norms = sqrt(sum((eV.^2)'));
    for ii = 1:length(norms)
        eV(ii, :) = eV(ii, :) ./ norms(ii);
    end
    rng(2);
    Y = kmeans(eV, k, 'Replicates', 20, 'Distance', 'sqeuclidean');
    
    
    f = figure(9);
  
    hold on
for ii = 1:k
    sub_lat = latitude(Y == ii);
    sub_lon = longitude(Y==ii);
    scatter(sub_lon, sub_lat, colors{ii});
end
plot_google_map
hold off

