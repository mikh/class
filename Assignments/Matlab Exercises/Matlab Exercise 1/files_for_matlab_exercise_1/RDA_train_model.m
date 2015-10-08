function [LDAmodel]= RDA_train_model(LDA_model, gamma)
% Training LDA
%
% EC 500 Learning from Data
% Fall semester, 2015
% by Prakash Ishwar
%
% alternative form of RDA_train which takes in the LDA_model as a
% parameter, allowing for faster training calculations when multiple gamma
% values are used

	%now regularize the matrix
	S = LDA_model.Sigmapooled;
	diag_matrix = diag(diag(S));

	S_new = gamma*diag_matrix + (1-gamma)*S;
    LDAmodel = LDA_model;
	LDAmodel.Sigmapooled = S_new;
end

