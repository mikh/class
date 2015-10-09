matlab1_2a
fid = fopen('all_output.txt','a');

fprintf(fid, 'Part f running...\n');

fprintf(fid, 'Determining new word indicies...\t');
vil = 1:l_V;
for ii = 1:l_S
   index = -1;
   for jj = 1:l_V
       if strcmp(stoplist{ii}, vocabulary{jj}) == 1
           index = jj;
           break;
       end
   end
   if index ~= -1
       vil(index) = -1;
       for jj = (index + 1):l_V
           if vil(jj) ~= -1
               vil(jj) = vil(jj) - 1;
           end
       end
   end
end
fprintf(fid, 'Done.\n');

fprintf(fid, 'Removing words...\t');
for ii = l_V:-1:1
    if vil(ii) == -1
        vocabulary(ii) = [];
    end
end
l_V = length(vocabulary);
fprintf(fid, '%.0f words in vocabulary\n', l_V);
fprintf(fid, 'Done.\n');

fprintf(fid, 'Editing training document words...\t');
training_set_words = 0;
for ii = 1:N_train
    for jj = length(train_docs(ii).word_list):-1:1
        w = train_docs(ii).word_list(jj);
        if vil(w) == -1
            c = train_docs(ii).word_count(jj);
            train_docs(ii).word_list(jj) = [];
            train_docs(ii).word_count(jj) = [];
            train_docs(ii).total_words = train_docs(ii).total_words - c;
        else
            train_docs(ii).word_list(jj) = vil(w);
        end
    end
    training_set_words = training_set_words + train_docs(ii).total_words;
end
fprintf(fid, 'Done.\n');

fprintf(fid, 'Editing testing document words...\t');
testing_set_words = 0;
for ii = 1:N_test
    for jj = length(test_docs(ii).word_list):-1:1
        w = test_docs(ii).word_list(jj);
        if vil(w) == -1
            c = test_docs(ii).word_count(jj);
            test_docs(ii).word_list(jj) = [];
            test_docs(ii).word_count(jj) = [];
            test_docs(ii).total_words = test_docs(ii).total_words - c;
        else
            test_docs(ii).word_list(jj) = vil(w);
        end
    end
    testing_set_words = testing_set_words + test_docs(ii).total_words;
end
fprintf(fid, 'Done.\n');

fprintf(fid, 'Average words in training set documents: %.2f\n', training_set_words/N_train);
fprintf(fid, 'Average words in test set documents: %.2f\n', testing_set_words/N_test);

fprintf(fid, 'Training B_w_c...\t');
naiveBayes = train_Naive_Bayes(train_docs, l_N, N_train, l_V, 1/l_V);
fprintf(fid, 'Done.\n');

fprintf(fid, '%.0f (%.2f%%) Beta_w_c are non-zero\n', naiveBayes.non_zero, 100*naiveBayes.non_zero/(l_V * l_N));

fprintf(fid, 'Performing testing...\t');
[CCR, con_mat, unclassified] = test_Naive_Bayes(naiveBayes, test_docs, N_test, l_N);
fprintf(fid, 'Done.\n');

fprintf(fid, '%.0f (%.2f%%) test samples resulted in no class assignment\n', unclassified, 100*unclassified/N_test);
fprintf(fid, 'CCR = %.2f%%\n', CCR*100);

fprintf(fid, 'Confusion Matrix:\n\n');
disp(con_mat);
fclose(fid);