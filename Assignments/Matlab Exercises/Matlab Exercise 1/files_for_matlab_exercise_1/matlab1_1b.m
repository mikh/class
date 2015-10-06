clear

load 'data_iris.mat'

S = 10; %splits
R = 10; %repetitions
[N,D] = size(X); %number of samples

%find number of classes - assumes all classes are sequential
M = range(Y) + 1;

u_avg = zeros(M, D);
var_qda_avg = zeros(M, D);
var_lda_avg = zeros(1,D);
CCR_LDA_all = zeros(S, R, 1);
CCR_QDA_all = zeros(S, R, 1);
confusion_matrices_LDA = zeros( M, M, S);
confusion_matrices_QDA = zeros( M, M, S);

start_split = 30;   %30 training, 120 test
split_increment = 10;

split_index = 1;
for ii = start_split:split_increment:(start_split+split_increment*(S-1))
   CCR_LDA = zeros(R,1);
   CCR_QDA = zeros(R,1);
   u_split = zeros(M,D);
   var_qda_split = zeros(M, D);
   var_lda_split = zeros(1, D);
   conf_mat_split_lda = zeros(M, M);
   conf_mat_split_qda = zeros(M, M);
    
   for jj = 1:R 
       %perform split
       train_indices = sort(randperm(N, ii));
       training_samples = zeros(ii,D);
       training_labels = zeros(ii, 1);
       testing_samples = zeros(N-ii,D);
       testing_labels = zeros(N-ii, 1);
       index = 1;
       train_index = 1;
       test_index = 1;
       for kk = 1:N
           if (index <= ii) && (train_indices(index) == kk)
              training_samples(train_index, :) = X(kk, :);
              training_labels(train_index) = Y(kk);
              index = index + 1;
              train_index = train_index + 1;
           else
               testing_samples(test_index, :) = X(kk, :);
               testing_labels(test_index) = Y(kk);
               test_index = test_index + 1;
           end
       end
       
       %learn classifiers
       LDAmodel = LDA_train(training_samples, training_labels, M);
       QDAmodel = QDA_train(training_samples, training_labels, M);
       
       %get predictions
       LDA_predictions = LDA_test(testing_samples, LDAmodel, M);
       QDA_predictions = QDA_test(testing_samples, QDAmodel, M);
       
       %add in the mean
       u_split = u_split + LDAmodel.Mu;
       
       %add in the variances for QDA
       variances = QDAmodel.Sigma;
       for kk = 1:M
           var_qda_split(kk, :) = var_qda_split(kk, :) + diag(variances(:,:,kk))';
       end
       
       %add in the variances for LDA
       var_lda_split = var_lda_split + diag(LDAmodel.Sigmapooled)';
       
       %calculate CCR
       c_l = 0;
       c_q = 0;       
       for kk = 1:(N-ii)
          if LDA_predictions(kk) == testing_labels(kk)
              c_l = c_l +1;
          end
          if QDA_predictions(kk) == testing_labels(kk)
              c_q = c_q +1;
          end
       end
       CCR_LDA(jj) = c_l/(N-ii);
       CCR_QDA(jj) = c_q/(N-ii);  
       
       %calculate confusion matrix
       conf_mat_split_lda = conf_mat_split_lda + confusionmat(testing_labels, LDA_predictions);
       conf_mat_split_qda = conf_mat_split_qda + confusionmat(testing_labels, QDA_predictions);
   end
  
   %average mean vectors
   u_split = u_split ./ (R);
   u_avg = u_avg + u_split;
   
   %average variances QDA
   var_qda_split = var_qda_split ./ (R);
   var_qda_avg = var_qda_avg + var_qda_split;
   
   %average variances LDA
   var_lda_split = var_lda_split ./ (R);
   var_lda_avg = var_lda_avg + var_lda_split;
   
   %add in CCR
   CCR_LDA_all(split_index, :) =  CCR_LDA(:,1)';
   CCR_QDA_all(split_index, :) =  CCR_QDA(:,1)';
   
   %average confusion matrices
   conf_mat_split_lda = conf_mat_split_lda ./ (R);
   confusion_matrices_LDA(:, :, split_index) = conf_mat_split_lda;
   conf_mat_split_qda = conf_mat_split_qda ./ (R);
   confusion_matrices_QDA(:,:, split_index) = conf_mat_split_qda;
   
   split_index = split_index + 1;
end

%average all mean vectors
u_avg = u_avg ./ S;
fprintf('Average mean vector for each split\n');
disp(u_avg);
fprintf('\n');

%average all variances QDA
var_qda_avg = var_qda_avg ./ S;
fprintf('Average variances for QDA for each split\n');
disp(var_qda_avg);
fprintf('\n')

%average LDA variances
var_lda_avg = var_lda_avg ./ S;
fprintf('Average variances for LDA for each split\n');
disp(var_lda_avg);
fprintf('\n')


%get mean and variance of CCRs
CCR_LDA_mean = zeros(S,1);
CCR_QDA_mean = zeros(S,1);
CCR_LDA_var = zeros(S,1);
CCR_QDA_var = zeros(S,1);

for ii = 1:S
    CCR_LDA_mean(ii) = mean(CCR_LDA_all(ii,:));
    CCR_LDA_var(ii) = var(CCR_LDA_all(ii, :));
    CCR_QDA_mean(ii) = mean(CCR_QDA_all(ii,:));
    CCR_QDA_var(ii) = var(CCR_QDA_all(ii, :));
end

fprintf('Mean of CCR for LDA:\n');
disp(CCR_LDA_mean);
fprintf('Mean of CCR for QDA:\n');
disp(CCR_QDA_mean);
fprintf('Variance of CCR for LDA:\n');
disp(CCR_LDA_var);
fprintf('Variance of CCR for QDA:\n');
disp(CCR_QDA_var);

[max_ccr, max_index] = max(CCR_LDA_mean);
[min_ccr, min_index] = min(CCR_LDA_mean);

fprintf('MAX CCR=%d, index=%d\n', max_ccr, max_index);
disp(confusion_matrices_LDA(:,:,max_index));
fprintf('MIN CCR=%d, index=%d\n', min_ccr, min_index);
disp(confusion_matrices_LDA(:,:,min_index));

disp('Done');