function [W, f_theta TT, ETT] = training_wrapper(X, Y, N, M, FEATURE_LENGTH, t_max, lambda, TT, ETT)
	fprintf('Training...\n');
	t1 = clock;

	W = zeros(t_max + 1, FEATURE_LENGTH, M);
	f_theta = zeros(t_max+1, 1);
	w_current = zeros(FEATURE_LENGTH, M);
	C = zeros(FEATURE_LENGTH, M);

	for j = 1:N
    	C(:,Y(j)) = C(:,Y(j)) + X(j,:)';
	end

	for t = 1:t_max;
		t3 = clock;
		[obj_fnc, grad_obj_fnc] = train(X, Y, C, w_current, N, M, FEATURE_LENGTH, lambda);   
		f_theta(t) = obj_fnc;
		w_current = w_current - (grad_obj_fnc .* step_size);
		W(t+1, :,:) = w_current;
		t4 = clock;
    	fprintf('\tLoop Iteration %d/%d complete. (%.2fs)\n', t, t_max, etime(t4,t3));
	end;
	save('W_matrix_data', 'W', 'f_theta');

	t2 = clock;
	elapsed_time = etime(t2, t1);
	TT = TT + elapsed_time;
	ETT = ETT + elapsed_time;
	fprintf('Done. (%.2fs)\n', elapsed_time);
end