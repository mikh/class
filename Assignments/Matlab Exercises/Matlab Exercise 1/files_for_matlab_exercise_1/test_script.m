load 'data_iris.mat'

%LDA_model = LDA_train(X, Y, 3);
%Y_result = LDA_test(X, LDA_model, 3);

QDAmodel = QDA_train(X, Y, 3);
Y_result = QDA_test(X, QDAmodel, 3);
