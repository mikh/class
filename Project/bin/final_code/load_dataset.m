function [ file_list_training, training_labels, file_list_testing, testing_labels, categories ] = load_dataset( location, num_categories, num_training, num_testing )
	file_list_training = cell(num_categories*num_training, 1);
	training_labels = zeros(num_categories*num_training, 1);
	file_list_testing = cell(num_categories*num_testing, 1);
	testing_labels = zeros(num_categories*num_testing, 1);
	categories = cell(num_categories, 1);


	file_list = dir(location);
	cats_to_use = randi([1 length(file_list)], 1, length(file_list));
	num_cats_used = 0;
	index_tr = 1;
	index_te = 1;
	for ii = 1:length(cats_to_use)
		category = file_list(cats_to_use(ii)).name;
		if (strcmp(category, '.') == 0) && (strcmp(category, '..') == 0)
			num_cats_used = num_cats_used + 1;
			categories{ii} = category;
			images = dir(sprintf('%s\\%s\\*.jpg', location, category));
			num_training_temp = num_training;
			num_testing_temp = num_testing;

			if length(images) < (num_training + num_testing)
				num_training_temp = floor(length(images)*num_training/(num_training+num_testing));
				num_testing_temp = floor(length(images)*num_testing/(num_training+num_testing));
			end
			image_list = randi([1 length(images)], 1, length(images));
			for jj = 1:num_training_temp
				file_list_training{index_tr} = sprintf('%s\\%s\\%s', location, category, images(image_list(jj)).name);
				training_labels(index_tr) = ii;
				index_tr = index_tr + 1;
			end
			for kk = jj+1:jj+num_testing_temp
				file_list_testing{index_te} = sprintf('%s\\%s\\%s', location, category, images(image_list(kk)).name);
				testing_labels(index_te) = ii;
				index_te = index_te+1;
			end
		end
		if num_cats_used == num_categories
			break;
		end
	end
	if index_tr < length(file_list_training)
		file_list_training{index_tr+1:length(file_list_training)} = [];
		training_labels(index_tr+1:length(training_labels)) = [];
	end
	if index_te < length(file_list_testing)
		file_list_testing{index_te+1:length(file_list_testing)} = [];
		testing_labels(index_te+1:length(testing_labels)) = [];
	end

end

