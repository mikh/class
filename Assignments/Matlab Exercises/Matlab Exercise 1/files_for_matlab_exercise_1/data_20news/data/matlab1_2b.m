matlab1_2a;
fid = fopen('all_output.txt','a');

fprintf(fid, 'Part b running...\n\n');

fprintf(fid, 'Training B_w_c...\t');
naiveBayes = train_Naive_Bayes(train_docs, l_N, N_train, l_V, 0);
fprintf(fid, 'Done.\n');

fprintf(fid, '%.0f (%.2f%%) Beta_w_c are non-zero\n', naiveBayes.non_zero, 100*naiveBayes.non_zero/(l_V * l_N));

fprintf(fid, 'Performing testing...\t');
[CCR, con_mat, unclassified] = test_Naive_Bayes(naiveBayes, test_docs, N_test, l_N);
fprintf(fid, 'Done.\n');

fprintf(fid, '%.0f (%.2f%%) test samples resulted in no class assignment\n', unclassified, 100*unclassified/N_test);
fprintf(fid, 'CCR = %.2f%%\n', CCR*100);


fclose(fid);