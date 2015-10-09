function [ CCR, con_mat, unclassified ] = test_Naive_Bayes( naiveBayes, test_docs , N_test, M)
%tests using MAP rule
    y_predicted = zeros(N_test,1);
    y_correct = zeros(N_test,1);
    CCR = 0;
    unclassified = 0;
    
    for ii = 1:N_test
       y_correct(ii) = test_docs(ii).document_label;
       y_rule = zeros(M, 1);
       
       for jj = 1:M
          %using ln rule
          pref = log(naiveBayes.p_y(jj));
          
          total_value = 0;
          for kk = 1:length(test_docs(ii).word_list)
             w = test_docs(ii).word_list(kk);
             c = test_docs(ii).word_count(kk);
             b_w_y = naiveBayes.beta(w,jj);
             
             %since ln(0) is undefined, we remember these are originally
             %multiplications, so if we have b_w_y = 0, then the result is
             %0
             if b_w_y == 0
                 total_value = 0;
                 break;
             end
             total_value = total_value + log(b_w_y)*c;
          end
          if total_value ~= 0
              total_value = total_value + pref;
          end
          y_rule(jj) = total_value;
       end
       
       %scale so we don't get negative values used
       minimum_value = abs(min(y_rule)) + 1;
       for jj = 1:M
           if y_rule(jj) ~= 0
               y_rule(jj) = y_rule(jj) + minimum_value;
           end
       end
       
       
       [best_label_value, best_label] = max(y_rule);
       if best_label_value == 0
           best_label = 0;
           unclassified = unclassified + 1;
       end
       test_docs(ii).predicted_label = best_label;
       y_predicted(ii) = best_label;
       if best_label == test_docs(ii).document_label
           CCR = CCR + 1;
       end
    end
    
    CCR = CCR/N_test;
    con_mat = confusionmat(y_correct, y_predicted);
    
end

