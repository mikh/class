function [ X_wf, TT, ETT ] = transform_word_frequency( X, N, doc_count, W , TT, ETT, run_string)
    fprintf(run_string);
    t1 = clock;
    
    X_wf = zeros(doc_count, W);
    for i = 1:N
        X_wf(X(i, 1), X(i, 2)) = X(i, 3);
    end
    words_in_doc = sum(X_wf');
    for i = 1:doc_count
        X_wf(i, :) = X_wf(i,:)./words_in_doc(i);
    end
    
    t2 = clock;
    elapsed_time = etime(t2, t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

