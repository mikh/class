matlab1_2a;
fid = fopen('all_output.txt','a');

fprintf(fid, 'Part c running...\n\n');

fprintf(fid, 'Removing test-only words...\t');
for ii = 1:N_test
   r_index = length(words_only_in_testing);
   for jj = length(test_docs(ii).word_list):-1:1
      w = test_docs(ii).word_list(jj);
      w_r = words_only_in_testing(r_index);
      while (r_index > 1) && (w < w_r)
         r_index = r_index - 1;
         w_r = words_only_in_testing(r_index);
      end
      if w == w_r
          test_docs(ii).word_list(jj) = [];
          c = test_docs(ii).word_count(jj);
          test_docs(ii).word_count(jj) = [];
          test_docs(ii).total_words = test_docs(ii).total_words - c;
      end          
   end
end
test_unique_words = [];
for ii = 1:N_test
   test_unique_words = union(test_unique_words, test_docs(ii).word_list); 
end
fprintf(fid, 'Done.\n');
words_only_in_testing = setdiff(test_unique_words, train_unique_words);
fprintf(fid, 'Unique words in test set not in training set: %d\n', length(words_only_in_testing));

fprintf(fid, 'Training B_w_c...\t');
naiveBayes = train_Naive_Bayes(train_docs, l_N, N_train, l_V, 0);
fprintf(fid, 'Done.\n');

fprintf(fid, '%.0f (%.2f%%) Beta_w_c are non-zero\n', naiveBayes.non_zero, 100*naiveBayes.non_zero/(l_V * l_N - length(words_only_in_testing)*l_N));

fprintf(fid, 'Performing testing...\t');
[CCR, con_mat, unclassified] = test_Naive_Bayes(naiveBayes, test_docs, N_test, l_N);
fprintf(fid, 'Done.\n');

fprintf(fid, '%.0f (%.2f%%) test samples resulted in no class assignment\n', unclassified, 100*unclassified/N_test);
fprintf(fid, 'CCR = %.2f%%\n', CCR*100);
fclose(fid);