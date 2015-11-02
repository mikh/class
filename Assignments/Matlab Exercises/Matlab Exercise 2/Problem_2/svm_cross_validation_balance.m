function [ CCR, con_mat, TT, ETT ] = svm_cross_validation( X, Y, N, folds, boxconstraint_exponent_low, boxconstraint_exponent_high, autoscale, kernel_function, TT, ETT )
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
    
    iteration_sets = cell(folds, 4);
    for ii = 1:folds
        iteration_sets{ii,1} = [];
        iteration_sets{ii,2} = [];
        iteration_sets{ii,3} = [];
        iteration_sets{ii,4} = [];
        for jj = 1:folds
            if ii == jj
                iteration_sets{ii,3} = increments{jj,1};
                iteration_sets{ii,4} = increments{jj,2};
            else
                iteration_sets{ii,1} = vertcat(iteration_sets{ii,1},increments{jj,1});
                iteration_sets{ii,2} = vertcat(iteration_sets{ii,2},increments{jj,2});
            end
        end
    end
    
    CCR = zeros(length(boxconstraint_exponent_low:boxconstraint_exponent_high),1);
    con_mat = cell(length(boxconstraint_exponent_low:boxconstraint_exponent_high),1);
    
    t4 = clock;
    fprintf('Done. (%.2fs)\n', etime(t4,t3));
    
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
            
            [N_train, ww] = size(iteration_sets{j,1});
            
            svm_classifier = svmtrain(iteration_sets{j,1}, iteration_sets{j,2}, 'autoscale', autoscale, 'boxconstraint', (2^exponent), 'kernel_function', kernel_function);
            prediction = svmclassify(svm_classifier, iteration_sets{j,3});
            num_correct = sum(prediction == iteration_sets{j,4});
            [r c] = size(testing_set);
            CCR(CCR_index) = CCR(CCR_index) + num_correct/r*100;
            con_mat{CCR_index} = con_mat{CCR_index} + confusionmat(iteration_sets{j,4}, prediction);
            
            
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

