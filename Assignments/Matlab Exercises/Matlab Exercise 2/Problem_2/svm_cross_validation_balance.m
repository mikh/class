function [ CCR, con_mat, TT, ETT ] = svm_cross_validation_balance( X, Y, N, folds, boxconstraint_exponent_low, boxconstraint_exponent_high, autoscale, kernel_function, TT, ETT )
    fprintf('Performing Cross Validation...\n');
    t1 = clock;
    
    fprintf('\tSetting up fields...\n');
    t3 = clock;
    
    increments = cell(folds,4);  
    start_index = 1;
    inc_val = ceil(N/folds);

    for i = 1:folds
        fprintf('\t\tFold = %d\n',i);
        testing_start_index = 1 + inc_val*(i-1);
        testing_end_index = min(testing_start_index + inc_val-1, N);
        if testing_start_index == 1
            increments{i,1} = X(testing_end_index+1:N,:);
            increments{i,2} = Y(testing_end_index+1:N,:);
        elseif testing_end_index == N
            increments{i,1} = X(1:testing_start_index-1, :);
            increments{i,2} = Y(1:testing_start_index-1, :);
        else
            increments{i,1} = vertcat(X(1:testing_start_index-1, :), X(testing_end_index+1:N,:));
            increments{i,2} = vertcat(Y(1:testing_start_index-1, :), Y(testing_end_index+1:N,:));
        end
        increments{i,3} = X(testing_start_index:testing_end_index);
        increments{i,4} = Y(testing_start_index:testing_end_index);
    end
   
    CCR = zeros(length(boxconstraint_exponent_low:boxconstraint_exponent_high),1);
    con_mat = cell(length(boxconstraint_exponent_low:boxconstraint_exponent_high),1);
    
    t4 = clock;
    fprintf('\tDone. (%.2fs)\n', etime(t4,t3));
    
    fprintf('\tPerforming Cross Validation...\n');
    t3 = clock;
        
    CCR_index = 1;
    for exponent = boxconstraint_exponent_low:boxconstraint_exponent_high
        fprintf('\t\tSet boxconstraint to 2^%d\n', exponent);
        t4 = clock;
        con_mat{CCR_index} = zeros(2,2);
        
        for j = 1:folds
            fprintf('\t\t\tPreforming fold %d...\t', j);
            t5 = clock;
            
            [N_train, ww] = size(increments{j,1});
            
            svm_classifier = svmtrain(increments{j,1}, increments{j,2}, 'autoscale', autoscale, 'boxconstraint', (2^exponent), 'kernel_function', kernel_function);
            prediction = svmclassify(svm_classifier, increments{j,3});
            num_correct = sum(prediction == increments{j,4});
            [r c] = size(testing_set);
            CCR(CCR_index) = CCR(CCR_index) + num_correct/r*100;
            con_mat{CCR_index} = con_mat{CCR_index} + confusionmat(increments{j,4}, prediction);
            
            
            fprintf('\t\t\tDone. (%.2fs)\n', etime(clock, t5));
        end

        
        
        CCR(CCR_index) = CCR(CCR_index)/folds;
        con_mat{CCR_index} = con_mat{CCR_index}./folds;
        fprintf('\t\tDone. (%.2fs)\n', etime(clock, t4));
            
        CCR_index = CCR_index + 1;
    end
    
    fprintf('\tDone. (%.2fs)\n', etime(clock, t3));
    
    

    t2 = clock;
    elapsed_time = etime(t2, t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

