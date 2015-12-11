clc;
clear;

fid = fopen('epoch_parse.txt', 'r');
C = textscan(fid, '%d %d %f %d %f %f %d');
fclose(fid);

CCR = C{7};
neurons = C{1};
layers = C{2};
learning_rate = C{3};
iterations = C{4};
train_time = C{5};
test_time = C{6};

f1 = figure(1);
hold on
temp_1 = [neurons(layers == 1), double(CCR(layers==1))/20*100];
temp = sortrows([neurons(layers == 1), double(CCR(layers==1))/20*100], 1);
final_neurons = 50:50:1000;
final_ccr = zeros(length(final_neurons), 1);
    
index = 1;
for ii = 50:50:1000
    a = temp(temp(:,1)==ii, 2);
    final_ccr(index) = max(temp(temp(:,1)==ii, 2));
    index = index + 1;
end


plot(final_neurons, final_ccr, 'b');

temp = sortrows([neurons(layers == 2), double(CCR(layers==2))/20*100], 1);
final_neurons = 50:50:1000;
final_ccr = zeros(length(final_neurons), 1);
    
index = 1;
for ii = 50:50:1000
    a = temp(temp(:,1)==ii, 2);
    final_ccr(index) = max(temp(temp(:,1)==ii, 2));
    index = index + 1;
end


plot(final_neurons, final_ccr, 'r');


temp = sortrows([neurons(layers == 3), double(CCR(layers==3))/20*100], 1);
final_neurons = 50:50:1000;
final_ccr = zeros(length(final_neurons), 1);
    
index = 1;
for ii = 50:50:1000
    a = temp(temp(:,1)==ii, 2);
    final_ccr(index) = max(temp(temp(:,1)==ii, 2));
    index = index + 1;
end


plot(final_neurons, final_ccr, 'g');

% temp_1 = [neurons(layers == 1), double(CCR(layers==1))/20*100];
% temp = sortrows([neurons(layers == 2), double(CCR(layers==2))/20*100], 1);
% plot(temp(:, 1), temp(:, 2), 'r');
% temp_1 = [neurons(layers == 1), double(CCR(layers==1))/20*100];
% temp = sortrows([neurons(layers == 3), double(CCR(layers==3))/20*100], 1);
% plot(temp(:, 1), temp(:, 2), 'g');

f2 = figure(2);
temp = [iterations, double(CCR)/20*100];
final_iterations = 50:50:250;
final_ccr = zeros(length(final_iterations), 1);
index = 1;
for ii = 50:50:250
    a = temp(temp(:,1)==ii, 2);
    final_ccr(index) = max(temp(temp(:,1)==ii, 2));
    index = index + 1;
end
sortrows(temp, 1);
plot(final_iterations, final_ccr);


xlabel('Number of epochs');
ylabel('% Correct');


hold off