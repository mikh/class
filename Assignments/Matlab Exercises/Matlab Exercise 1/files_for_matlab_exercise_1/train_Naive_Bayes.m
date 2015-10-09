function [naiveBayes] = train_Naive_Bayes(train_docs, M, N_train, W, alpha)
% trains the naive Bayes
    beta = zeros(W, M);
    n_y = zeros(M, 1);
    n_words = zeros(M, 1);
    
    for ii = 1:N_train
       y = train_docs(ii).document_label;   %y-label
       n_y(y) = n_y(y) + 1; %n_y being the number of documents with class y
       n_words(y) = n_words(y) + train_docs(ii).total_words;
       %go through all words in the document
       for jj = 1:length(train_docs(ii).word_list)
           w = train_docs(ii).word_list(jj);   %this is the word id
           %add up the word counts
           beta(w,y) = beta(w,y) + train_docs(ii).word_count(jj);
       end
    end
    
    for ii = 1:M
       beta(:,ii) = (beta(:, ii) + alpha) ./ (n_words(ii) + W*alpha); 
    end
    
    non_zero = 0;
    for ii = 1:W
        for jj = 1:M
            if beta(ii, jj) ~= 0
                non_zero = non_zero + 1;
            end
        end
    end
    
    p_y = n_y./N_train;
    naiveBayes = struct('beta', beta, 'p_y', p_y, 'non_zero', non_zero);  
end

