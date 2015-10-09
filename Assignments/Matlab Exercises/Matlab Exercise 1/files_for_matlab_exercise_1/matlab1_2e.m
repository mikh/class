matlab1_2a;

fprintf( 'Part e running...\n\n');

CCR_all = zeros(length(-5:.5:1.5));
CCR_index = 1;

for exponent = -5:.5:1.5
   fprintf( 'Runnning test with exponent = %.1f\n',exponent);
   fprintf( 'Training B_w_c...\t');
   naiveBayes = train_Naive_Bayes(train_docs, l_N, N_train, l_V, 10^(exponent));
   fprintf( 'Done.\n');
   fprintf( '%.0f (%.2f%%) Beta_w_c are non-zero\n', naiveBayes.non_zero, 100*naiveBayes.non_zero/(l_V * l_N));
   fprintf( 'Performing testing...\t');
   [CCR, con_mat, unclassified] = test_Naive_Bayes(naiveBayes, test_docs, N_test, l_N);
   CCR_all(CCR_index) = CCR;
   CCR_index = CCR_index + 1;
   fprintf( 'Done.\n');

   fprintf( '%.0f (%.2f%%) test samples resulted in no class assignment\n', unclassified, 100*unclassified/N_test);
   fprintf( 'CCR = %.2f%%\n', CCR*100);

end

x = 10.^(-5:.5:1.5);
semilogx(x, CCR_all);
title('CCR vs alpha plot');
xlabel('alpha');
ylabel('CCR');
