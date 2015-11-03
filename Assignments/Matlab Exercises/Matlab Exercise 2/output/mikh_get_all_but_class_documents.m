function [ Y_class, TT, ETT ] = mikh_get_all_but_class_documents( Y, N, c, TT, ETT )
    fprintf('Extracting all samples of class %d...\n', c);
    t1 = clock;
   
    Y_class = zeros(N,1);
    for ii = 1:N
        if Y(ii) == c
            Y_class(ii) = c;
        else
            Y_class(ii) = c+1;
        end
    end
   
    
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

