function [Y_pred, CCR,  TT, ETT ] = testing_wrapper( X, Y, N, W, t_max, TT, ETT )
    fprintf('Running testing...\t');
    t1 = clock;
   
    w_current = squeeze(W(t_max+1,:,:));
    Y_pred = test(X, w_current, N);   

    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);

    fprintf('Getting CCR...\t');
    t1 = clock;
   
    correct = 0;
    for ii = 1:N
        if Y_pred(ii) == Y(ii)
            correct = correct + 1;
        end
    end
    CCR = correct/N*100;
   
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
    save('test_results', 'Y_pred', 'CCR');
end

