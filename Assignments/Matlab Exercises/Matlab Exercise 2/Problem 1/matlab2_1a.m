clc
clear

fprintf('Starting Matlab2_1a\n');

TRAINING_DATA_MULTIPLE = 0.01;
TESTING_DATA_MULTIPLE = 0.01;
blank_data_point = struct('index', 0, 'Address', '', 'Category', '', 'Date', '', 'Time', '', 'DayOfWeek', '', 'PdDistrict', '', 'X', 0, 'Y', 0, 'feature_vector', zeros(1,41));
day_of_week_mapping = struct('Sunday', 1, 'Monday', 2, 'Tuesday', 3, 'Wednesday', 4, 'Thursday', 5, 'Friday', 6, 'Saturday', 7);
police_district_mapping = struct('BAYVIEW', 1, 'CENTRAL', 2, 'INGLESIDE', 3, 'MISSION', 4, 'NORTHERN', 5, 'PARK', 6, 'RICHMOND', 7, 'SOUTHERN', 8, 'TARAVAL', 9, 'TENDERLOIN', 10);
total_time = 0;
estimated_total_time = 0;
total_training_features = zeros(1, 41);
total_test_features = zeros(1,41);

fprintf('Loading training data...\t');
t1 = clock;
load 'data_SFcrime_train.mat'
t2 = clock;
elapsed_time = etime(t2,t1);
total_time = total_time + elapsed_time;
estimated_total_time = estimated_total_time + elapsed_time;
fprintf('Done. (%.2fs)\n', elapsed_time);

fprintf('Processing training data...\t');
t1 = clock;
N_train = ceil(length(Address) * TRAINING_DATA_MULTIPLE);
training_data(N_train) = blank_data_point;
for ii = 1:N_train
    training_data(ii) = blank_data_point;
    training_data(ii).index = ii;
    training_data(ii).Address = Address{ii};
    training_data(ii).Category = Category{ii};
    training_data(ii).DayOfWeek = DayOfWeek{ii};
    training_data(ii).PdDistrict = PdDistrict{ii};
    training_data(ii).X = X(ii);
    training_data(ii).Y = Y(ii);
    date_data = Dates{ii};
    date_data = strsplit(date_data, ' ');
    training_data(ii).Date = date_data{1};
    training_data(ii).Time = date_data{2};
    date_data = strsplit(date_data{2}, ':');
    hour_data = date_data{1};
    training_data(ii).feature_vector(str2num(hour_data)+1) = 1;
    training_data(ii).feature_vector(24 + day_of_week_mapping.(training_data(ii).DayOfWeek)) = 1;
    training_data(ii).feature_vector(24+7+police_district_mapping.(training_data(ii).PdDistrict)) = 1;

    total_training_features = total_training_features + training_data(ii).feature_vector;
end
t2 = clock;
elapsed_time = etime(t2, t1);
total_time = total_time + elapsed_time;
estimated_total_time = estimated_total_time + (elapsed_time * 1/TRAINING_DATA_MULTIPLE);
fprintf('Done. (%.2fs)\n', elapsed_time);

clear Address Category date_data Dates DayOfWeek elapsed_time ii PdDistrict t1 t2 X Y hour_data

fprintf('Loading testing data...\t');
t1 = clock;
load 'data_SFcrime_test.mat'
t2 = clock;
elapsed_time = etime(t2,t1);
total_time = total_time + elapsed_time;
estimated_total_time = estimated_total_time + elapsed_time;
fprintf('Done. (%.2fs)\n', elapsed_time);

fprintf('Processing testing data...\t');
t1 = clock;
N_test = ceil(length(Address_test) * TESTING_DATA_MULTIPLE);
testing_data(N_test) = blank_data_point;
for ii = 1:N_test
    testing_data(ii) = blank_data_point;
    testing_data(ii).index = ii;
    testing_data(ii).Address = Address_test{ii};
    testing_data(ii).DayOfWeek = DayOfWeek_test{ii};
    testing_data(ii).PdDistrict = PdDistrict_test{ii};
    testing_data(ii).X = X_test(ii);
    testing_data(ii).Y = Y_test(ii);
    date_data = Dates_test{ii};
    date_data = strsplit(date_data, ' ');
    testing_data(ii).Date = date_data{1};
    testing_data(ii).Time = date_data{2};
    date_data = strsplit(date_data{2}, ':');
    hour_data = date_data{1};
    testing_data(ii).feature_vector(str2num(hour_data)+1) = 1;
    testing_data(ii).feature_vector(24 + day_of_week_mapping.(testing_data(ii).DayOfWeek)) = 1;
    testing_data(ii).feature_vector(24+7+police_district_mapping.(testing_data(ii).PdDistrict)) = 1;
    
    total_test_features = total_test_features + testing_data(ii).feature_vector;
end
t2 = clock;
elapsed_time = etime(t2, t1);
total_time = total_time + elapsed_time;
estimated_total_time = estimated_total_time + (elapsed_time * 1/TESTING_DATA_MULTIPLE);
fprintf('Done. (%.2fs)\n', elapsed_time);

clear Address_test date_data Dates_test DayOfWeek_test elapsed_time ii PdDistrict_test t1 t2 X_test Y_test hour_data blank_data_point

all_hours = zeros(0,1);
all_days = zeros(0,1);
all_districts = zeros(0,1);
for i = 1:24
    current_hour = zeros(total_training_features(i), 1);
    current_hour(:,1) = current_hour(:,1) + (i);
    all_hours = [all_hours; current_hour];
end
for i = 25:31
    current_week = zeros(total_training_features(i), 1);
    current_week(:,1) = current_week(:, 1) + (i-24);
    all_days = [all_days; current_week];
end
for i = 32:41
    current_district = zeros(total_training_features(i), 1);
    current_district(:,1) = current_district(:,1) + (i-31);
    all_districts = [all_districts; current_district];
end


fprintf('Matlab2_1a complete. (%.2fs) (ETT: %.2fs)\n', total_time, estimated_total_time);

%%
fprintf('running section');

all_hours = zeros(0,1);
for i = 1:length(hours)
    current_hour = zeros(hours(i), 1);
    current_hour(:,1) = current_hour(:,1) + (i);
    all_hours = [all_hours; current_hour];
end
hist(all_hours, 24);
    