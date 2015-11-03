function [ X_train, X_test, TT, ETT ] = mikh_remove_stopwords( vocabulary, W, stoplist, l_S, X_train, X_test, TT, ETT)
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
    for i = l_S:-1:1
        if index_list(i)==0
            index_list(i)=[];
            l_S = l_S-1;
        end
    end
    index_list = sort(index_list);
    t4 = clock;
    fprintf('Done. (%.2fs)\n', etime(t4,t3));
    
    fprintf('\tRemoving stopwords...\n');
    t3 = clock;
    
    for i = l_S:-1:1
        t5 = clock;
        
        X_train(:,index_list(i)) = 0;
        X_test(:,index_list(i)) = 0;        
        t6 = clock;
        fprintf('\t\ti = %d, index = %d (%.2fs)\n', i, index_list(i), etime(t6,t5));
    end
    
    t4 = clock;
    fprintf('Done. (%.2fs)\n', etime(t4, t3));
    
    t2 = clock;
    elapsed_time = etime(t2, t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

