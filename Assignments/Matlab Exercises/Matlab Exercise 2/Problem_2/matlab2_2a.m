%% Init Variables

CLEAR_VARIABLES = 1;

if CLEAR_VARIABLES == 1
    clear
end
clc
fprintf('Running Matlab2 - 2a...\n');
TT = 0;
ETT = 0;

LOAD_BASE_DATA = 1;
RUN_PART_A = 0;
LOAD_DATA_FOR_PART_A = 1;

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
    
    [X_train, X_test, N_train_s, N_test_s, TT, ETT] = remove_stopwords(vocabulary, W, stoplist, l_S, X_train, X_test, N_train_s, N_test_s, TT, ETT);
    [X_wf_train, TT, ETT] = transform_word_frequency(X_train, N_train_s, N_train, TT, ETT, 'Transforming training data to word frequency matrix...\t');
    [X_wf_test, TT, ETT] = transform_word_frequency(X_test, N_test_s, N_test, TT, ETT, 'Transforming testing data to word frequency matrix...\t');
    clear stoplist l_S X_train_doc X_train_word X_train_count N_train_s X_test_doc X_test_word X_test_count X_test_s
    save('word_freq_data', 'X_wf_train', 'X_wf_test', 'N_train', 'N_test', 'Y_train', 'Y_test', 'W', 'M', 'TT', 'ETT');
end

%% Part a


if RUN_PART_A == 1
    fprintf('Running part A\n');
    if LOAD_DATA_FOR_PART_A == 1
        fprintf('Loading base data...\t');
        clear
        load 'word_freq_data.mat'
    end
end

%% Code complete
fprintf('Done. (%.2fs) (ETT: %.2fs)\n', TT, ETT);