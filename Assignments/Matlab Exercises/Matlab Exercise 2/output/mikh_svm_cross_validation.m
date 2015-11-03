function [ CCR, TT, ETT ] = mikh_svm_cross_validation( X, Y, N, folds, boxconstraint_exponent_low, boxconstraint_exponent_high, autoscale, kernel_function, TT, ETT )
    fprintf('Performing Cross Validation...\n');
    t1 = clock;
    
    fprintf('\tSetting up fields...\t');
    t3 = clock;
    
    increments = cell(folds,2);
    start_index = 1;
    inc_val = ceil(N/folds);
    for i = 1:folds-1
        increments{i,1} = X(start_index:(start_index + inc_val - 1),:);
        increments{i,2} = Y(start_index:(start_index + inc_val - 1),:);
        start_index = start_index + inc_val;
    end;
    increments{folds,1} = X(start_index:N, :);
    increments{folds,2} = Y(start_index:N, :);
    CCR = zeros(length(boxconstraint_exponent_low:boxconstraint_exponent_high),1);
    
    t4 = clock;
    fprintf('Done. (%.2fs)\n', etime(t4,t3));
    
    fprintf('\tPerforming Cross Validation...\n');
    t3 = clock;
        
    CCR_index = 1;
    for exponent = boxconstraint_exponent_low:boxconstraint_exponent_high
        fprintf('\t\tSet boxconstraint to 2^%d\n', exponent);
        t4 = clock;
        
        for j = 1:folds
            fprintf('\t\t\tPreforming fold %d...\t', j);
            t5 = clock;
            
            training_set = [];
            training_validation_set = [];
            for k = 1:folds
                if k ~= j
                    training_set = vertcat(training_set, increments{k,1});
                    training_validation_set = vertcat(training_validation_set, increments{k,2});
                else
                    testing_set = increments{k,1};
                    testing_validation_set = increments{k,2};
                end
            end
            [N_train, ww] = size(training_set);
            
            svm_classifier = svmtrain(training_set, training_validation_set, 'autoscale', autoscale, 'boxconstraint', ones(N_train,1) .* (2^exponent), 'kernel_function', kernel_function);
            prediction = svmclassify(svm_classifier, testing_set);
            num_correct = sum(prediction == testing_validation_set);
            [r c] = size(testing_set);
            CCR(CCR_index) = CCR(CCR_index) + num_correct/r*100;
            
            
            fprintf('\t\t\tDone. (%.2fs)\n', etime(clock, t5));
        end

        
        
        CCR(CCR_index) = CCR(CCR_index)/folds;
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

