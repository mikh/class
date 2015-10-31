function [Y_pred, CCR, logloss,  TT, ETT ] = testing_wrapper( X, Y, N, W, t_max, TT, ETT )
    fprintf('Running testing...\n');
    t1 = clock;
    
    
    Y_pred = zeros(N, t_max);
    for ii = 1:t_max
        t3 = clock;
        w_current = squeeze(W(ii+1,:,:));
        Y_pred(:,ii) = test(X, w_current, N);
        t4 = clock;
        fprintf('\tTesting iteration %d/%d. (%.2fs)\n', ii, t_max, etime(t4,t3));
    end

    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);

    fprintf('Getting CCR...\t');
    t1 = clock;
   
    CCR = zeros(t_max, 1);
    for ii = 1:t_max
        CCR(ii) = sum(Y_pred(:,ii)==Y)/N*100;
    end
    
    f2 = figure(2);
    plot(1:t_max, CCR);
    title('CCR over iterations');
    xlabel('Iterations');
    ylabel('CCR %%');
    saveas(f2, 'CCR.png');
    
    logloss = zeros(t_max, 1);
    for ii = 1:t_max
        w_current = squeeze(W(ii+1,:,:));
        logloss(ii) = calculate_logloss(X,Y,w_current,N);
    end
    
    f3 = figure(3);
    plot(1:t_max, logloss);
    title('Logloss over iterations');
    xlabel('Iterations');
    ylabel('logloss');
    saveas(f3, 'logloss.png');
    
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
    save('test_results', 'Y_pred', 'CCR', 'logloss');
end

