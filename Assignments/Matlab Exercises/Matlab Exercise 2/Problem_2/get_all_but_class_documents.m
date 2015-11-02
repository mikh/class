function [ X_class, N_class, TT, ETT ] = get_all_but_class_documents( X, Y, N, c, TT, ETT )
    fprintf('Extracting all samples of class %d...\t', c);
    t1 = clock;
   
    X_class = [];
    for ii = 1:N
        if Y(ii) ~= c
            X_class = vertcat(X_class, X(ii,:));
        end
    end
    [N_class,cols] = size(X_class);
   
    
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

