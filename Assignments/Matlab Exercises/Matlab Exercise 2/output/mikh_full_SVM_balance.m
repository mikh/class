function [ CCR, con_mat, TT, ETT ] = mikh_full_SVM_balance( X_train, X_test, Y_train, Y_test, N_train, N_test, boxconstraint, rbf_sigma, autoscale, kernel_function, TT, ETT )
    fprintf('Running SVM on full set...\t');
    t1 = clock;

    svm_classifier = svmtrain(X_train, Y_train, 'autoscale', autoscale, 'boxconstraint', boxconstraint, 'kernel_function', kernel_function);
    prediction = svmclassify(svm_classifier, X_test);
    CCR = sum(prediction == Y_test);
    CCR = CCR/N_test*100;
    con_mat = confusionmat(Y_test, prediction);

    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

