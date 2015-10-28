%% Constants

CLEAR_VARIABLES = 1;



clc
if CLEAR_VARIABLES == 1
clear
end
TRAIN_DATA_MULTIPLIER = 1; %[ORIGINAL=1]
FEATURE_LENGTH = 41;
M = 39;
step_size = 10^(-5);
lambda = 1000;
training_division = 0.6;
t_max = 1000;  %[ORIGINAL=1000]
TT = 0; %total time
ETT = 0; %estimated total time
category_mapping = struct('ARSON', 1, 'ASSAULT', 2, 'BAD_CHECKS', 3, 'BRIBERY', 4, 'BURGLARY', 5, 'DISORDERLY_CONDUCT', 6, 'DRIVING_UNDER_THE_INFLUENCE',7, 'DRUG_NARCOTIC',8, 'DRUNKENNESS',9, 'EMBEZZLEMENT',10, 'EXTORTION',11, 'FAMILY_OFFENSES',12, 'FORGERY_COUNTERFEITING',13, 'FRAUD',14, 'GAMBLING',15, 'KIDNAPPING',16, 'LARCENY_THEFT',17, 'LIQUOR_LAWS',18, 'LOITERING',19, 'MISSING_PERSON',20, 'NON_CRIMINAL',21, 'OTHER_OFFENSES',22, 'PORNOGRAPHY_OBSCENE_MAT',23, 'PROSTITUTION',24, 'RECOVERED_VEHICLE',25, 'ROBBERY',26, 'RUNAWAY',27, 'SECONDARY_CODES',28, 'SEX_OFFENSES_FORCIBLE',29, 'SEX_OFFENSES_NON_FORCIBLE',30, 'STOLEN_PROPERTY',31, 'SUICIDE',32, 'SUSPICIOUS_OCC',33, 'TREA',34, 'TRESPASS',35, 'VANDALISM',36, 'VEHICLE_THEFT',37, 'WARRANTS',38, 'WEAPON_LAWS',39);

RUN_FIRST_PART = 0;
RUN_TRAINING_PART = 0;
LOAD_TRAINING_FROM_FILE = 1;


%% Load part a data

if RUN_FIRST_PART == 1
fprintf('Starting Matlab2_1b\n');

fprintf('Loading part a data...\t');
t1 = clock;
load 'matlab2_1a.mat'
t2 = clock;
elapsed_time = etime(t2,t1);
TT = TT + elapsed_time;
ETT = ETT + elapsed_time;
fprintf('Done. (%.2fs)\n', elapsed_time);

fprintf('Extract relevant data...\t');
t1 = clock;
N_train = ceil(N_train * TRAIN_DATA_MULTIPLIER);
N_train_div = ceil(N_train*training_division);
X_train = zeros(N_train_div, FEATURE_LENGTH);
Y_train = zeros(N_train_div, 1);
N_test_div = N_train - N_train_div;
X_test = zeros(N_test_div,  FEATURE_LENGTH);
Y_test = zeros(N_test_div, 1);

for ii = 1:N_train_div
    X_train(ii, :) = training_data(ii).feature_vector(:);
    cate = training_data(ii).Category;
    cate = strrep(cate, ' ', '_');
    cate = strrep(cate, '/', '_');
    cate = strrep(cate, '-', '_');
    Y_train(ii) = category_mapping.(cate);
end
for ii = (N_train_div+1):N_train
    X_test(ii-N_train_div, :) = training_data(ii).feature_vector(:);
    cate = training_data(ii).Category;
    cate = strrep(cate, ' ', '_');
    cate = strrep(cate, '/', '_');
    cate = strrep(cate, '-', '_');
    Y_test(ii-N_train_div) = category_mapping.(cate);
end
t2 = clock;
elapsed_time = etime(t2,t1);
TT = TT + elapsed_time;
ETT = ETT + (elapsed_time/TRAIN_DATA_MULTIPLIER);
fprintf('Done. (%.2fs)\n', elapsed_time);

clear t1 t2 elapsed_time estimated_total_time total_time total_test_features total_training_features ii

end

%% Train 

if RUN_TRAINING_PART == 1
clc
fprintf('Training...\n');
t1 = clock;
W = zeros(t_max + 1, FEATURE_LENGTH, M);
f_theta = zeros(t_max+1, 1);
w_current = zeros(FEATURE_LENGTH, M);

C = zeros(FEATURE_LENGTH, M);
for j = 1:N_train_div
    C(:,Y_train(j)) = C(:,Y_train(j)) + X_train(j,:)';
end

for t = 1:t_max
    t3 = clock;
    [obj_fnc, grad_obj_fnc] = train(X_train, Y_train, C, w_current, N_train_div, M, FEATURE_LENGTH, lambda);   
    f_theta(t) = obj_fnc;
    w_next = w_current - (grad_obj_fnc .* step_size);
    W(t+1, :,:) = w_next(:,:);
    w_current = w_next;
    t4 = clock;
    fprintf('\tLoop Iteration %d/%d complete. (%.2fs)\n', t, t_max, etime(t4,t3));
end

save('W_matrix_data', 'W', 'f_theta');
t2 = clock;
elapsed_time = etime(t2, t1);
fprintf('Done. (%.2fs)\n', elapsed_time);
end

%% Part b results
LOAD_TRAINING_FROM_FILE = 1;
if LOAD_TRAINING_FROM_FILE == 1
clear
t_max = 1000;
fprintf('Loading results from file...\t');
t1 = clock;
load 'W_matrix_data.mat'
t2 = clock;
fprintf('Done. (%.2fs)\n', etime(t2,t1));

figure(1);
plot(1:t_max,f_theta(1:t_max));
title('Objective function vs. iterations');
xlabel('Iterations');
ylabel('Objective Function value');



end


%% Code complete

fprintf('Matlab2_1b complete. (%.2fs) (ETT: %.2fs)\n', TT, ETT);