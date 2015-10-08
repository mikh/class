matlab1_2a;

fprintf('Part c running...\n\n');

fprintf('Training B_w_c...\t');
beta = zeros(l_V, l_N);
n_c = zeros(l_N);
n_y = zeros(l_N);
non_zero = 0;

for ii = 1:N_train
    y = train_docs(ii).document_label;
	n_y(y) = n_y(y) + 1;
    n_c(y) = n_c(y) + train_docs(ii).total_words;
    for jj = 1:length(train_docs(ii).word_list)
        w = train_docs(ii).word_list(jj);
        if beta(w,y) == 0
            non_zero = non_zero + 1;
        end
        beta(w, y) = beta(w,y) + train_docs(ii).word_count(jj);        
    end
end

for ii = 1:l_N
    beta(:,ii) = beta(:,ii) ./ n_c(ii);
end
clear ii jj w y;
fprintf('Done.\n');

fprintf('%.0f (%.2f%%) Beta_w_c are non-zero\n', non_zero, 100*non_zero/((l_V * l_N) - length(words_only_in_testing)*l_N));

fprintf('Removing unused test words...\t');
for ii = 1:N_test
	remove_index = length(words_only_in_testing);
	for jj = length(test_docs(ii).word_list):-1:1
		if remove_index == 0
			break;
		end
		k = test_docs(ii).word_list(jj);
		r_k = words_only_in_testing(remove_index);
		while (k < r_k) && (remove_index > 1)
			remove_index = remove_index - 1;
			r_k = words_only_in_testing(remove_index);
		end

		if k == r_k
			test_docs(ii).word_list(jj) = [];
			test_docs(ii).word_count(jj) = [];
		end
	end
end
fprintf('Done\n\n');

fprintf('Performing testing...\t');
no_class = 0;
CCR = 0;

for ii = 1:N_test
	best_prob_value = -1;
	best_label = 0;
	num_words = length(test_docs(ii).word_list);

	for jj = 1:l_N
		current_value = 0;
		for kk = 1:num_words
            if beta(test_docs(ii).word_list(kk), jj) == 0
                current_value = 0;
                break;
            end
			t_value = log(beta(test_docs(ii).word_list(kk), jj))*test_docs(ii).word_count(kk);
			current_value = current_value + t_value;
		end
		current_value = current_value * log(n_y(jj)/N_train);	
		if (current_value ~= 0 ) && ((best_prob_value == -1) || (current_value > best_prob_value))
			best_prob_value = current_value;
			best_label = jj;
		end	
	end

	test_docs(ii).predicted_label = best_label;
	if best_label == 0
		no_class = no_class + 1;
	end

	if test_docs(ii).predicted_label == test_docs(ii).document_label
		CCR = CCR + 1;
	end
end
clear ii jj kk best_prob_value best_label num_words current_value
fprintf('Done.\n');

fprintf('%.0f (%.2f%%) test samples resulted in no class assignment\n', no_class, 100*no_class/N_test);
fprintf('CCR = %.2f%%\n', CCR/N_test*100);