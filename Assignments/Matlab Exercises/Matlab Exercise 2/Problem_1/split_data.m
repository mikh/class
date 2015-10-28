function [X_train, Y_train, N_train, X_test, Y_test, N_test, TT, ETT] = split_data(data, N, DATA_LENGTH_MULTIPLIER, PERCENTAGE_TRAINING, FEATURE_LENGTH, TT, ETT, label_mapping)
	fprintf('Spliting data into 2 sets...\t');
	t1 = clock;

	N = ceil(N * DATA_LENGTH_MULTIPLIER);
	N_train = ceil(N*PERCENTAGE_TRAINING);
	N_test = N - N_train;

	X_train = zeros(N_train, FEATURE_LENGTH);
	Y_train = zeros(N_train, 1);
	X_test = zeros(N_test, FEATURE_LENGTH);
	Y_test = zeros(N_test, 1);

	rand_stream = RandStream('mt19937ar', 'Seed', 1);
	training_indices = sort(randperm(rand_stream, N, N_train));

	perm_index = 1;
	train_index = 1;
	test_index = 1;
	for ii = 1:N
		x_vector = data(ii).feature_vector(:);
		y_label = training_data(ii).Category;
		y_label = strrep(y_label, ' ', '_');
        y_label = strrep(y_label, '/', '_');
        y_label = strrep(y_label, '-', '_');
        y_label = label_mapping.(ylabel);
		if training_indices(perm_index) == ii
			X_train(train_index,:) = x_vector;
			Y_train(train_index) = y_label;
			train_index = train_index + 1;
			perm_index = perm_index + 1;
		else
			X_test(test_index, :) = x_vector;
			Y_test(test_index) = y_label;
			test_index = test_index + 1;
		end
	end

	if (train_index ~= N_train) || (test_index ~= N_test) || (perm_index ~= length(training_indices))
		fprintf('Invalid Indexing!\n\n');
	end

	t2 = clock;
	elapsed_time = etime(t2,t1);
	TT = TT + elapsed_time;
	ETT = ETT + (elapsed_time/DATA_LENGTH_MULTIPLIER);
	fprintf('Done. (%.2fs)\n', elapsed_time);
end