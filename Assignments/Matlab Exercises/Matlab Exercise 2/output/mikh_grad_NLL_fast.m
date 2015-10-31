function [result] = grad_NLL_fast(X, Y, W, n, m, d)
	%Gradient of NLL function 
    %X - input samples [n x d]
    %Y - labesl for input samples [n x 1]
    %W - Theta parameters [d x M]
    %n - number of input samples
    %m - number of classes
    %d - number of parameters

    % result = [dxm] calculates all y at the same time

	result = zeros(d,m);

	for j = 1:n
		class_exponent = exp(W'*X(j,:)');
		alpha = sum(class_exponent);
		class_exponent = class_exponent ./ alpha;
		class_exponent(Y(j)) = class_exponent(Y(j))-1;
		result = result + (class_exponent * X(j,:))';
	end
end