function [ weights ] = back_propogate( label, layers, weights, activation_functions, learning_rate )
	weight_change = cell(length(weights), 1);
	for ii = 1:length(weights)
		[r, c] = size(weights{ii});
		weight_change{ii} = zeros(r, c);
	end

	deriv_E = cell(length(layers), 1);
	for ii = 1:length(layers)
		[r, c] = size(layers{ii});
		deriv_E{ii} = zeros(r, c);
	end

	deriv_E{length(deriv_E)} = (label - layers{length(layers)}) .* layers{length(layers)-1}'*weights{length(weights)};
	weight_change{length(weight_change)} = learning_rate .* layers{length(layers)-1} * deriv_E{length(deriv_E)}';

	for ii = length(layers)-1:-1:2
		deriv_E{ii} = (diff_activate(layers{ii-1}'*weights{ii-1}, activation_functions{ii}).* (deriv_E{ii+1} * weights{ii}'))';
        weight_change{ii-1} = learning_rate .* layers{ii-1} * deriv_E{ii}';
   
		
	end	



end

