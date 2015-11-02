function [CCR, confusion_matrix, testing_time, TT, ETT] = test_OVO_SVM(SVM_classifiers, num_classifiers, X, Y, N, TT, ETT)
	tic;
	fprintf('Testing One-Versus-One classfiers...\n');
	t1 = clock;

	fprintf('\tInitializing variables...\t');
	X = sparse(X);
	t2 = clock;
	Y_r = zeros(N, num_classifiers);
	fprintf('Done. (%.2fs)\n', etime(clock, t2));

	for ii = 1:num_classifiers
		fprintf('\tTesting classifier %d...\n', ii);
		t2 = clock;
		Y_r(:, ii) = svmclassify(SVM_classifiers{ii}, X);
		fprintf('Done. (%.2fs)\n', etime(clock, t2));
	end

	fprintf('\tExtracting results...\t');
	t2 = clock;
	prediction = zeros(N,1);
	for ii = 1:N
		prediction(ii) = mode(Y_r(ii,:));
	end
	CCR = sum(Y == prediction)/N*100;
	confusion_matrix = confusionmat(Y, prediction);
	fprintf('Done. (%.2fs)\n', etime(clock, t2));

	e = etime(clock, t1);
	TT = TT + e;
	ETT = ETT + e;
	fprintf('Done. (%.2fs)\n', e);
	testing_time = toc;
end