%load 'data_iris.mat'

%LDA_model = LDA_train(X, Y, 3);
%Y_result = LDA_test(X, LDA_model, 3);

%QDAmodel = QDA_train(X, Y, 3);
%Y_result = QDA_test(X, QDAmodel, 3);

load 'data_cancer.mat'

M = range(Y) + 1;
LDAmodel = RDA_train(X, Y, .3, M);
Y_result = RDA_test(X, LDAmodel, M);
