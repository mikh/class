%% Init Variables

CLEAR_VARIABLES = 0;

if CLEAR_VARIABLES == 1
    clear
end
clc
fprintf('Running Matlab2 - 2...\n');
TT = 0;
ETT = 0;

LOAD_BASE_DATA = 0;
RUN_PART_A = 0;
LOAD_DATA_FOR_PART_A = 1;
RUN_PART_B = 0;
RUN_PART_CD = 0;
RUN_PART_E = 0;
RUN_CLASS_SEPERATION = 0;
RUN_PART_F = 1;

%% Load Data
if LOAD_BASE_DATA == 1
    fprintf('Loading base data\n');
    [vocabulary, W, TT, ETT] = load_txt_file('vocabulary.txt', '%s', 'Loading dictionary...\t', TT, ETT);
    [stoplist, l_S, TT, ETT] = load_txt_file('stoplist.txt', '%s', 'Loading stoplist...\t', TT, ETT);
    [newsgroups, M, TT, ETT] = load_txt_file('newsgrouplabels.txt', '%s', 'Loading newsgroups...\t', TT, ETT);
    [Y_train, N_train, TT, ETT] = load_txt_file('train.label', '%d', 'Loading training labels...\t', TT, ETT);
    [Y_test, N_test, TT, ETT] = load_txt_file('test.label', '%d', 'Loading testing labels...\t', TT, ETT);
    [X_train_doc, X_train_word, X_train_count, N_train_s, TT, ETT] = load_txt_file_into_3_ints('train.data', 'Loading training data...\t', TT, ETT);
    [X_test_doc, X_test_word, X_test_count, N_test_s, TT, ETT] = load_txt_file_into_3_ints('test.data', 'Loading testing data...\t', TT, ETT);
    X_train = [X_train_doc, X_train_word, X_train_count];
    X_test = [X_test_doc, X_test_word, X_test_count];
    
    [X_wf_train, TT, ETT] = transform_word_frequency(X_train, N_train_s, N_train, W, TT, ETT, 'Transforming training data to word frequency matrix...\t');
    [X_wf_test, TT, ETT] = transform_word_frequency(X_test, N_test_s, N_test, W, TT, ETT, 'Transforming testing data to word frequency matrix...\t');
    [X_wf_train, X_wf_test, TT, ETT] = remove_stopwords(vocabulary, W, stoplist, l_S, X_wf_train, X_wf_test, TT, ETT);

    clear stoplist l_S X_train_doc X_train_word X_train_count N_train_s X_test_doc X_test_word X_test_count X_test_s
    save('word_freq_data', 'X_wf_train', 'X_wf_test', 'N_train', 'N_test', 'Y_train', 'Y_test', 'W', 'M', 'TT', 'ETT', '-v7.3');
end



%% part c d
if RUN_PART_CD == 1
    fprintf('Running part C and D\n');
    if LOAD_DATA_FOR_PART_A == 1
        fprintf('Loading base data...\t');
        t1 = clock;
        load 'word_freq_data.mat'
        fprintf('Done. (%.2fs)\n', etime(clock, t1));
        
    end

    X_a = X_wf_train;
    N_a = N_train;
    [Y_a, TT, ETT] = get_all_but_class_documents(Y_train, N_train, 17, TT, ETT);
    
    X_a_test = X_wf_test;
    N_a_test = N_test;
    [Y_a_test, TT, ETT] = get_all_but_class_documents(Y_test, N_test, 17, TT, ETT);

    [CCR, con_mat, TT, ETT] = svm_cross_validation_balance(X_a, Y_a ,N_a,5,-5, 15, false, 'linear', TT, ETT);
    plot_CCR(1,CCR,2.^(-5:15),'Binary SVM classifier CCR for classes 17 and the rest', 'part_c_CV_CCR.png');
    plot_confusion_matrix(2, con_mat, 2.^(-5:15), 'Binary SVM classfier Precision, Recall, and F-Score', 'part_d_CV_CCR.png');
    [max_value, max_index] = max(CCR);
    [CCR, con_mat, TT, ETT] = full_SVM_balance(X_a, X_a_test, Y_a, Y_a_test, N_a, N_a_test, 2^(-5+max_index-1), 0, false, 'linear', TT, ETT);
    fprintf('Using constraint %d, with a value of 2^%d, CCR = %.2f%%\n', max_index, -5+max_index-1, CCR);
    disp(con_mat);
end



%% Code complete
fprintf('Done. (%.2fs) (ETT: %.2fs)\n', TT, ETT);
