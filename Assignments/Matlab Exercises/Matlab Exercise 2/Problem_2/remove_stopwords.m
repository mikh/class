function [ X_train, X_test, N_train, N_test, TT, ETT ] = remove_stopwords( vocabulary, W, stoplist, l_S, X_train, X_test, N_train, N_test, TT, ETT)
    fprintf('Removing stopwords...\n');
    t1 = clock;

    fprintf('\tLoading stopword indices...\t');
    t3 = clock;
    index_list = zeros(l_S, 1);
    for i = 1:l_S
        word = stoplist{i};
        
        for j = 1:W
            if strcmp(word, vocabulary{j}) == 1
                index_list(i) = j;
                break;
            end
        end
    end
    t4 = clock;
    fprintf('Done. (%.2fs)\n', etime(t4,t3));
    
    fprintf('\tRemoving stopwords from training set...\t');
    t3 = clock;
    removed_words = 0;
    for j = N_train:-1:1
        for i = 1:l_S
            if X_train(j, 2) == index_list(i)
                X_train(j, :) = [];
                removed_words = removed_words + 1;
            end
        end
    end
    N_train = N_train - removed_words;
    t4 = clock;
    fprintf('Done. (%.2fs)\n', etime(t4, t3));
        
    fprintf('\tRemoving stopwords from testing set...\t');
    t3 = clock;
    removed_words = 0;
    for j = N_test:-1:1
        for i = 1:l_S
            if X_test(j, 2) == index_list(i)
                X_test(j, :) = [];
                removed_words = removed_words + 1;
            end
        end
    end
    N_test = N_test - removed_words;
    t4 = clock;
    fprintf('Done. (%.2fs)\n', etime(t4, t3));
    
    t2 = clock;
    elapsed_time = etime(t2, t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

