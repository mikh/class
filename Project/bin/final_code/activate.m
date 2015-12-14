function [ z ] = activate( values, activation_function )
	if strcmp(activation_function, 'LINEAR') == 1
		z = values;
	elseif strcmp(activation_function, 'SIGMOID') == 1
		z = logsig(values);
	elseif strcmp(activation_function, 'TANH') == 1
		e_p = exp(values);
		e_m = exp(-values);
		z = (e_p-e_m)./(e_p+e_m);
	else
		fprintf('Activation Function not recognized.\n');
	end
end

