matlab1_2a;
fid = fopen('all_output.txt','a');

fprintf(fid, 'Part e running...\n\n');

CCR_all = zeros(length(-5:.5:1.5));
CCR_index = 1;

for exponent = -5:.5:1.5
   fprintf(fid, 'Runnning test with exponent = %.1f\n',exponent);
   fprintf(fid, 'Training B_w_c...\t');
   naiveBayes = train_Naive_Bayes(train_docs, l_N, N_train, l_V, 10^(exponent));
   fprintf(fid, 'Done.\n');
   fprintf(fid, '%.0f (%.2f%%) Beta_w_c are non-zero\n', naiveBayes.non_zero, 100*naiveBayes.non_zero/(l_V * l_N));
   fprintf(fid, 'Performing testing...\t');
   [CCR, con_mat, unclassified] = test_Naive_Bayes(naiveBayes, test_docs, N_test, l_N);
   CCR_all(CCR_index) = CCR;
   CCR_index = CCR_index + 1;
   fprintf(fid, 'Done.\n');

   fprintf(fid, '%.0f (%.2f%%) test samples resulted in no class assignment\n', unclassified, 100*unclassified/N_test);
   fprintf(fid, 'CCR = %.2f%%\n', CCR*100);

end

x = 10.^(-5:.5:1.5);
semilogx(x, CCR_all);
fclose(fid);