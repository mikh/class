matlab1_2a;

fprintf('Part b running...\n\n');

fprintf('Training B_w_c...\t');
beta = zeros(l_V, l_N);
n_c = zeros(l_N);
non_zero = 0;

for ii = 1:N_train
    y = train_docs(ii).document_label;
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

fprintf('%.0f Beta_w_c are non-zero\n', non_zero);

