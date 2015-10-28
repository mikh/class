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

RUN_LOADING_AND_PROCESSING_PART_A_DATA = 0;
RUN_TRAINING_PART = 0;
LOAD_TRAINING_FROM_FILE = 1;
fprintf('Starting Matlab2_1b\n');


%% Load part a data

if RUN_LOADING_AND_PROCESSING_PART_A_DATA == 1

    fprintf('Loading part a data...\t');
    t1 = clock;
    load 'matlab2_1a.mat'
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);

    [X_train, Y_train, N_train_d, X_test, Y_test, N_test_d, TT, ETT] = split_data(training_data, N_train, TRAIN_DATA_MULTIPLIER, training_division, FEATURE_LENGTH, TT, ETT, category_mapping);

    save('processed_part_a_data', 'X_train', 'Y_train', 'X_test', 'Y_test', 'N_train_d', 'N_test_d', 'TT', 'ETT');

    clear t1 t2 elapsed_time
end

%% Train 

if RUN_TRAINING_PART == 1
    [W, f_theta, TT, ETT] = training_wrapper(X_train, Y_train, N_train_d, M, FEATURE_LENGTH, t_max, lambda, TT, ETT);
end

%% Part b results
if LOAD_TRAINING_FROM_FILE == 1
t_max = 1000;
fprintf('Loading results from file...\t');
t1 = clock;
load 'W_matrix_data.mat'
load 'processed_part_a_data.mat'
t2 = clock;
fprintf('Done. (%.2fs)\n', etime(t2,t1));

figure(1);
plot(1:t_max,f_theta(1:t_max));
title('Objective function vs. iterations');
xlabel('Iterations');
ylabel('Objective Function value');

fprintf('Running testing...\t');
t1 = clock;
w_current = squeeze(W(t_max+1,:,:));
Y_predicted = test(X_test, w_current, N_test_div);
t2 = clock;
fprintf('Done. (%.2fs)\n', etime(t2, t1));

fprintf('Getting CCR...\t');
t1 = clock;
correct = 0;
for ii = 1:N_test_div
    if Y_predicted(ii) == Y_test(ii)
        correct = correct + 1;
    end
end
CCR = correct/N_test_div*100;
t2 = clock;
fprintf('Done. (%.2fs)\n', etime(t2, t1));
fprintf('CCR = %.2f%%\n', CCR);


save('test_results', 'Y_predicted');

end


%% Code complete

fprintf('Matlab2_1b complete. (%.2fs) (ETT: %.2fs)\n', TT, ETT);