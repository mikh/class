%% Process inputs
clc
clear

fprintf('Starting Matlab2_1a\n');

TRAINING_DATA_MULTIPLE = 1;
TESTING_DATA_MULTIPLE = 1;
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
save('matlab2_1a', 'training_data', 'testing_data', 'total_training_features', 'total_test_features', 'N_train', 'N_test', 'total_time', 'estimated_total_time');


%% Output histograms

LOAD_FROM_VARIABLE = 0;

if LOAD_FROM_VARIABLE == 1
    clc
	clear;
	load 'matlab2_1a.mat'
end


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

all_hours_categorical = categorical(all_hours, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],{'12AM','1AM', '2AM', '3AM', '4AM', '5AM', '6AM', '7AM', '8AM', '9AM', '10AM', '11AM', '12PM', '1PM', '2PM', '3PM', '4PM', '5PM', '6PM', '7PM', '8PM', '9PM', '10PM', '11PM'});
all_days_categorical = categorical(all_days, [1,2,3,4,5,6,7], {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'});
all_district_categorical = categorical(all_districts, [1,2,3,4,5,6,7,8,9,10], {'BAYVIEW', 'CENTRAL', 'INGLESIDE', 'MISSION', 'NORTHERN', 'PARK', 'RICHMOND', 'SOUTHERN', 'TARAVAL', 'TENDERLOIN'});

h1 = figure(1);
set(h1, 'Position',  [100,100,1250,400])
hist(all_hours_categorical);
%[temp_n, temp_x] = hist(all_hours, 24);
%barstrings = num2str(temp_n');
%text(temp_x, temp_n, barstrings, 'horizontalalignment', 'center', 'verticalalignment', 'bottom');
title('Histogram of incidents per hour');
ylabel('Number of incidents');
xlabel('Hour');

h2 = figure(2);
set(h2, 'Position',  [100,100,900,400])
hist(all_days_categorical);
title('Histogram of incidents per day of the week');
ylabel('Number of incidents');
xlabel('Day');

h3 = figure(3);
set(h3, 'Position',  [100,100,1150,400])
hist(all_district_categorical);
title('Histogram of incidents per district');
ylabel('Number of incidents');
xlabel('District');

saveas(h1, 'histogram_hours.png');
saveas(h2, 'histogram_days.png');
saveas(h3, 'histogram_district.png');

clear all_hours all_days all_districts current_hour current_week current_district all_hours_categorical all_days_categorical all_district_categorical h1 h2 h3

%% Most likely incidents

LOAD_FROM_VARIABLE = 0;
clc;

if LOAD_FROM_VARIABLE == 1
    clc;
	clear;
	load 'matlab2_1a.mat'
end
category_mapping = struct('ARSON', 1, 'ASSAULT', 2, 'BAD_CHECKS', 3, 'BRIBERY', 4, 'BURGLARY', 5, 'DISORDERLY_CONDUCT', 6, 'DRIVING_UNDER_THE_INFLUENCE',7, 'DRUG_NARCOTIC',8, 'DRUNKENNESS',9, 'EMBEZZLEMENT',10, 'EXTORTION',11, 'FAMILY_OFFENSES',12, 'FORGERY_COUNTERFEITING',13, 'FRAUD',14, 'GAMBLING',15, 'KIDNAPPING',16, 'LARCENY_THEFT',17, 'LIQUOR_LAWS',18, 'LOITERING',19, 'MISSING_PERSON',20, 'NON_CRIMINAL',21, 'OTHER_OFFENSES',22, 'PORNOGRAPHY_OBSCENE_MAT',23, 'PROSTITUTION',24, 'RECOVERED_VEHICLE',25, 'ROBBERY',26, 'RUNAWAY',27, 'SECONDARY_CODES',28, 'SEX_OFFENSES_FORCIBLE',29, 'SEX_OFFENSES_NON_FORCIBLE',30, 'STOLEN_PROPERTY',31, 'SUICIDE',32, 'SUSPICIOUS_OCC',33, 'TREA',34, 'TRESPASS',35, 'VANDALISM',36, 'VEHICLE_THEFT',37, 'WARRANTS',38, 'WEAPON_LAWS',39);
police_district_mapping = struct('BAYVIEW', 1, 'CENTRAL', 2, 'INGLESIDE', 3, 'MISSION', 4, 'NORTHERN', 5, 'PARK', 6, 'RICHMOND', 7, 'SOUTHERN', 8, 'TARAVAL', 9, 'TENDERLOIN', 10);


crime_matrix_hour = zeros(24, 39);	%rows: hours , cols: categories
crime_matrix_district = zeros(10,39); %rows: district, cols:categories
for ii = 1:N_train
    r_hour = strsplit(training_data(ii).Time, ':');
    r_hour = str2num(r_hour{1}) + 1;
    r_district = police_district_mapping.(training_data(ii).PdDistrict);
    cate = training_data(ii).Category;
    cate = strrep(cate, ' ', '_');
    cate = strrep(cate, '/', '_');
    cate = strrep(cate, '-', '_');
    c = category_mapping.(cate);
    crime_matrix_hour(r_hour, c) = crime_matrix_hour(r_hour, c) + 1;
    crime_matrix_district(r_district, c) = crime_matrix_district(r_district, c) + 1;
end

save('crime_matrix', 'crime_matrix_hour', 'crime_matrix_district');


%% Crime Matrix results
LOAD_FROM_VARIABLE = 0;
clc;

if LOAD_FROM_VARIABLE == 1
    clc;
	clear;
	load 'crime_matrix.mat'
end

category_mapping = struct('ARSON', 1, 'ASSAULT', 2, 'BAD_CHECKS', 3, 'BRIBERY', 4, 'BURGLARY', 5, 'DISORDERLY_CONDUCT', 6, 'DRIVING_UNDER_THE_INFLUENCE',7, 'DRUG_NARCOTIC',8, 'DRUNKENNESS',9, 'EMBEZZLEMENT',10, 'EXTORTION',11, 'FAMILY_OFFENSES',12, 'FORGERY_COUNTERFEITING',13, 'FRAUD',14, 'GAMBLING',15, 'KIDNAPPING',16, 'LARCENY_THEFT',17, 'LIQUOR_LAWS',18, 'LOITERING',19, 'MISSING_PERSON',20, 'NON_CRIMINAL',21, 'OTHER_OFFENSES',22, 'PORNOGRAPHY_OBSCENE_MAT',23, 'PROSTITUTION',24, 'RECOVERED_VEHICLE',25, 'ROBBERY',26, 'RUNAWAY',27, 'SECONDARY_CODES',28, 'SEX_OFFENSES_FORCIBLE',29, 'SEX_OFFENSES_NON_FORCIBLE',30, 'STOLEN_PROPERTY',31, 'SUICIDE',32, 'SUSPICIOUS_OCC',33, 'TREA',34, 'TRESPASS',35, 'VANDALISM',36, 'VEHICLE_THEFT',37, 'WARRANTS',38, 'WEAPON_LAWS',39);
police_district_mapping = struct('BAYVIEW', 1, 'CENTRAL', 2, 'INGLESIDE', 3, 'MISSION', 4, 'NORTHERN', 5, 'PARK', 6, 'RICHMOND', 7, 'SOUTHERN', 8, 'TARAVAL', 9, 'TENDERLOIN', 10);

all_categories = fieldnames(category_mapping);
all_districts = fieldnames(police_district_mapping);
for i = 1:39
    [max_val, max_index] = max(crime_matrix_hour(:,i));
    fprintf('%s is most likely to occur at hour %.0f\n', all_categories{i}, max_index); 
end

fprintf('\n\n');
for i = 1:10
    [max_value, max_index] = max(crime_matrix_district(i, :));
    fprintf('The crime most likely to occur in %s is %s\n', all_districts{i}, all_categories{max_index});
end

fprintf('\n\n');
fprintf('Matlab2_1a complete. (%.2fs) (ETT: %.2fs)\n', total_time, estimated_total_time);

    