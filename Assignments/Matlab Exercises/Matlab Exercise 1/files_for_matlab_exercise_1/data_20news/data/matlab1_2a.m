clc
clear

GET_UNIQUE_WORDS = 1;
GET_TOTAL_NUMBER_OF_WORDS = 1;

fprintf('Loading vocabulary...\t');
vocabulary = textread('vocabulary.txt','%s');
l_V = length(vocabulary);
fprintf('Done.\n');

fprintf('Loading newsgroups...\t');
newsgroups = textread('newsgrouplabels.txt', '%s');
l_N = length(newsgroups);
fprintf('Done.\n');

blank_doc = struct('document_id', -1, 'document_label', -1, 'predicted_label', -1, 'word_list', [], 'word_count', [], 'total_words', 0);

if GET_UNIQUE_WORDS == 1
    train_unique_words = [];
    test_unique_words = [];
end

if GET_TOTAL_NUMBER_OF_WORDS == 1
    train_total_words = 0;
    test_total_words = 0;
end
    
fprintf('Loading training samples...\t');
[train_d_id, train_w_id, train_w_c] = textread('train.data', '%d %d %d');
train_labels = textread('train.label', '%d');
N_train = length(train_labels);
train_docs(N_train) = blank_doc;
data_index = 1;
for ii = 1:N_train
   train_docs(ii) = blank_doc;
   train_docs(ii).document_id = ii;
   train_docs(ii).document_label = train_labels(ii);
   while (data_index <= length(train_d_id)) && (train_d_id(data_index) == ii)
       train_docs(ii).word_list = [train_docs(ii).word_list train_w_id(data_index)];
       train_docs(ii).word_count = [train_docs(ii).word_count train_w_c(data_index)];
       data_index = data_index + 1;
   end
   
   if GET_UNIQUE_WORDS == 1
       train_unique_words = union(train_unique_words, train_docs(ii).word_list);
   end
   if GET_TOTAL_NUMBER_OF_WORDS == 1
       words_in_doc = sum(train_docs(ii).word_count);
       train_docs(ii).total_words = words_in_doc;
       train_total_words = train_total_words + words_in_doc;
   end
end
clear train_d_id train_w_id train_w_c train_labels data_index ii words_in_doc;
fprintf('Done.\n');

fprintf('Loading testing samples...\t');
[test_d_id, test_w_id, test_w_c] = textread('test.data', '%d %d %d');
test_labels = textread('test.label', '%d');
N_test = length(test_labels);
test_docs(N_test) = blank_doc;
data_index = 1;
for ii = 1:N_test
   test_docs(ii) = blank_doc;
   test_docs(ii).document_id = ii;
   test_docs(ii).document_label = test_labels(ii);
   while (data_index <= length(test_d_id)) && (test_d_id(data_index) == ii)
       test_docs(ii).word_list = [test_docs(ii).word_list test_w_id(data_index)];
       test_docs(ii).word_count = [test_docs(ii).word_count test_w_c(data_index)];
       data_index = data_index + 1;
   end
   if GET_UNIQUE_WORDS == 1
       test_unique_words = union(test_unique_words, test_docs(ii).word_list);
   end
   if GET_TOTAL_NUMBER_OF_WORDS == 1
       words_in_doc = sum(test_docs(ii).word_count);
       test_docs(ii).total_words = words_in_doc;
       test_total_words = test_total_words + words_in_doc;
   end
end
clear test_d_id test_w_id test_w_c test_labels data_index ii words_in_doc;
fprintf('Done.\n');

fprintf('Loading stoplist...\t');
stoplist = textread('stoplist.txt', '%s');
l_S = length(stoplist);
fprintf('Done\n');

fprintf('\n\n');

%get number of unique words
if GET_UNIQUE_WORDS == 1
    fprintf('Unique words in training set: %d\n', length(train_unique_words));
    fprintf('Unique words in testing set: %d\n', length(test_unique_words));
    fprintf('Unique words in entire data set: %d\n', length(union(train_unique_words, test_unique_words)));
    fprintf('Unique words in test set not in training set: %d\n', length(setdiff(test_unique_words, train_unique_words)));
end
    
%average document length
if GET_TOTAL_NUMBER_OF_WORDS == 1
    fprintf('Average words in training set documents: %.2f\n', train_total_words/N_train);
    fprintf('Average words in test set documents: %.2f\n', test_total_words/N_test);
end
fprintf('\n\n');

fprintf('Done.\n');