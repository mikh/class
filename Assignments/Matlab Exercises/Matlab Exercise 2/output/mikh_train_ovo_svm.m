function [SVM_classifiers, number_of_classifiers, training_time, TT, ETT] = mikh_train_ovo_svm(classes, class_lengths, num_classes, kernel_function, TT, ETT)
	tic;
	fprintf('Training One-Versus-One classfiers...\n');
	t1 = clock;

	fprintf('\tInitializing variables...\t');
	t2 = clock;
	number_of_classifiers = num_classes*(num_classes-1)/2;
	SVM_classifiers = cell(number_of_classifiers, 1);
	for ii = 1:num_classes
		classes{ii} = sparse(classes{ii});
	end
	fprintf('Done. (%.2fs)\n', etime(clock, t2));

    index = 1;
	for ii = 1:num_classes
		for jj = (ii+1):num_classes
			fprintf('\tTraining SVM %d...\t', index);
			t2 = clock;

			X = vertcat(classes{ii}, classes{jj});
			N = class_lengths(ii) + class_lengths(jj);
			Y = vertcat(zeros(class_lengths(ii),1) + ii, zeros(class_lengths(jj), 1) + jj);

			SVM_classifiers{index} = svmtrain(X, Y, 'autoscale', false, 'kernel_function', kernel_function, 'kernelcachelimit', 100000);

			fprintf('Done. (%.2fs)\n', etime(clock, t2));
            index = index + 1;
		end
	end


	e = etime(clock, t1);
	TT = TT + e;
	ETT = ETT + e;
	fprintf('Done. (%.2fs)\n', e);
	training_time = toc;
end