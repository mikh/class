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
    [vocabulary, W, TT, ETT] = mikh_load_txt_file('vocabulary.txt', '%s', 'Loading dictionary...\t', TT, ETT);
    [stoplist, l_S, TT, ETT] = mikh_load_txt_file('stoplist.txt', '%s', 'Loading stoplist...\t', TT, ETT);
    [newsgroups, M, TT, ETT] = mikh_load_txt_file('newsgrouplabels.txt', '%s', 'Loading newsgroups...\t', TT, ETT);
    [Y_train, N_train, TT, ETT] = mikh_load_txt_file('train.label', '%d', 'Loading training labels...\t', TT, ETT);
    [Y_test, N_test, TT, ETT] = mikh_load_txt_file('test.label', '%d', 'Loading testing labels...\t', TT, ETT);
    [X_train_doc, X_train_word, X_train_count, N_train_s, TT, ETT] = mikh_load_txt_file_into_3_ints('train.data', 'Loading training data...\t', TT, ETT);
    [X_test_doc, X_test_word, X_test_count, N_test_s, TT, ETT] = mikh_load_txt_file_into_3_ints('test.data', 'Loading testing data...\t', TT, ETT);
    X_train = [X_train_doc, X_train_word, X_train_count];
    X_test = [X_test_doc, X_test_word, X_test_count];
    
    [X_wf_train, TT, ETT] = mikh_transform_word_frequency(X_train, N_train_s, N_train, W, TT, ETT, 'Transforming training data to word frequency matrix...\t');
    [X_wf_test, TT, ETT] = mikh_transform_word_frequency(X_test, N_test_s, N_test, W, TT, ETT, 'Transforming testing data to word frequency matrix...\t');
    [X_wf_train, X_wf_test, TT, ETT] = mikh_remove_stopwords(vocabulary, W, stoplist, l_S, X_wf_train, X_wf_test, TT, ETT);

    clear stoplist l_S X_train_doc X_train_word X_train_count N_train_s X_test_doc X_test_word X_test_count X_test_s
    save('word_freq_data', 'X_wf_train', 'X_wf_test', 'N_train', 'N_test', 'Y_train', 'Y_test', 'W', 'M', 'TT', 'ETT', '-v7.3');
end

%% Part a


if RUN_PART_A == 1
    fprintf('Running part A\n');
    if LOAD_DATA_FOR_PART_A == 1
        fprintf('Loading base data...\t');
        t1 = clock;
        load 'word_freq_data.mat'
        fprintf('Done. (%.2fs)\n', etime(clock, t1));
        
    end
    
    [X_class_1, N_class_1, TT, ETT] = mikh_get_class_documents(X_wf_train, Y_train, N_train, 1, TT, ETT);
    [X_class_20, N_class_20, TT, ETT] = mikh_get_class_documents(X_wf_train, Y_train, N_train, 20, TT, ETT);
    [X_class_1_test, N_class_1_test, TT, ETT] = mikh_get_class_documents(X_wf_test, Y_test, N_test, 1, TT, ETT);
    [X_class_20_test, N_class_20_test, TT, ETT] = mikh_get_class_documents(X_wf_test, Y_test, N_test, 20, TT, ETT);

    X_a = vertcat(X_class_1, X_class_20);
    Y_a = vertcat(zeros(N_class_1, 1)+1, zeros(N_class_20, 1) + 20);
    N_a = N_class_1 + N_class_20;

    X_a_test = vertcat(X_class_1_test, X_class_20_test);
    Y_a_test = vertcat(zeros(N_class_1_test, 1) + 1, zeros(N_class_20_test,1)+20);
    N_a_test = N_class_1_test + N_class_20_test;

    [CCR, TT, ETT] = mikh_svm_cross_validation(X_a, Y_a ,N_a,5,-5, 15, false, 'linear', TT, ETT);
    mikh_plot_CCR(1,CCR,2.^(-5:15),'Binary SVM classifier CCR for classes 1 and 20', 'part_a_CV_CCR.png');
    [max_value, max_index] = max(CCR);
    [CCR, TT, ETT] = mikh_full_SVM(X_a, X_a_test, Y_a, Y_a_test, N_a, N_a_test, 2^(-5+max_index-1), 0, false, 'linear', TT, ETT);
    fprintf('Using constraint %d, with a value of 2^%d, CCR = %.2f%%\n', max_index, -5+max_index-1, CCR);

end


%% Code complete
fprintf('Done. (%.2fs) (ETT: %.2fs)\n', TT, ETT);
