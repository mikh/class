function [ X_class, N_class, TT, ETT ] = get_class_documents( X, Y, N, c, w, TT, ETT )
    fprintf('Extracting all samples of class %d...\t', c);
    t1 = clock;
    
    X_class = zeros(N,w);
    index = 1;
    for ii = 1:N
        if Y(ii) == c
            X_class(index, :) = X(ii,:);
            index = index + 1;
        end
    end
    N_class = index-1;
    
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

