function [ CCR, con_mat, TT, ETT ] = svm_cross_validation_balance( X, Y, N, folds, boxconstraint_exponent_low, boxconstraint_exponent_high, autoscale, kernel_function, TT, ETT )
    fprintf('Performing Cross Validation...\n');
    t1 = clock;
    
    inc_val = ceil(N/folds);
    q_length = length(boxconstraint_exponent_low:boxconstraint_exponent_high);
    CCR = zeros(q_length,1);
    con_mat = cell(q_length,1);
    for ii = 1:q_length
        con_mat{ii} = zeros(2,2);
    end
    X = sparse(X);

    for fold = 1:folds
        fprintf('\tPreforming fold %d...\n', fold);
        t3 = clock;

        fprintf('\t\tSetting up fields...\t');
        t4 = clock;

        testing_start_index = 1 + inc_val*(fold-1);
        testing_end_index = min(testing_start_index + inc_val-1, N);
        if testing_start_index == 1
            X_train = X(testing_end_index+1:N,:);
            Y_train = Y(testing_end_index+1:N,:);
        elseif testing_end_index == N
            X_train = X(1:testing_start_index-1, :);
            Y_train = Y(1:testing_start_index-1, :);
        else
            X_train = vertcat(X(1:testing_start_index-1, :), X(testing_end_index+1:N,:));
            Y_train = vertcat(Y(1:testing_start_index-1, :), Y(testing_end_index+1:N,:));
        end
        N_train = length(Y_train);
        X_test = X(testing_start_index:testing_end_index,:);
        Y_test = Y(testing_start_index:testing_end_index);
        N_test = length(Y_test);
        


        fprintf('Done. (%.2fs)\n', etime(clock,t4));

        fprintf('\t\tPerforming Cross Validation...\n');
        t4 = clock;

        CCR_index = 1;
        for exponent = boxconstraint_exponent_low:boxconstraint_exponent_high
            fprintf('\t\tSet boxconstraint to 2^%d\t', exponent);
            t5 = clock;
            svm_classifier = svmtrain(X_train, Y_train, 'autoscale', autoscale, 'boxconstraint', 2^exponent, 'kernel_function', kernel_function, 'kernelcachelimit', 100000);
            prediction = svmclassify(svm_classifier, X_test);
            num_correct = sum(prediction == Y_test);
            CCR(CCR_index) = CCR(CCR_index) + num_correct/N_test*100;
            con_mat{CCR_index} = con_mat{CCR_index} + confusionmat(Y_test, prediction);
            CCR_index = CCR_index + 1;

            fprintf('Done. (%.2fs)\n', etime(clock, t5));
        end


        fprintf('\t\tCross Validation complete. (%.2fs)\n', etime(clock,t4));

        clear X_train X_test Y_train Y_test N_train N_test prediction svm_classifier
        fprintf('\tFold Complete. (%.2fs)\n', etime(clock, t3));

    end

    CCR = CCR ./ folds;
    for ii = 1:q_length
        con_mat{ii} = con_mat{ii}./folds;
    end  

    t2 = clock;
    elapsed_time = etime(t2, t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

