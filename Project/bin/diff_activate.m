function [ z ] = diff_activate( values, activation_function )
	if strcmp(activation_function, 'LINEAR') == 1
		z = ones(length(values), 1);
	elseif strcmp(activation_function, 'SIGMOID') == 1
		ss = logsig(values);
		z = ss*(1-ss);
	elseif strcmp(activation_function, 'TANH') == 1
		e_p = exp(values);
		e_m = exp(-values);
		z = 1 - ((e_p-e_m)/(e_p+e_m)).^2;
	else
		fprintf('Activation Function not recognized.\n');
	end
end

