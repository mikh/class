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

    ii = length(layers);
    for jj = 1:length(layers{ii})
    	deriv_E{ii}(jj) = -(label - layers{ii}(jj)) * diff_activate(layers{ii-1}'*weights{ii-1}(:, jj), activation_functions{ii});
    	weight_change{ii-1}(:, jj) = deriv_E{ii}(jj).*learning_rate.* layers{ii-1}(jj);
    end

    %ii = length(layers);
    %deriv_E{ii} = (label - layers{ii}) .* (layers{ii-1}' * weights{ii-1})';
    %weight_change{ii-1} = learning_rate .* layers{ii-1} * deriv_E{ii}';

    for ii = length(layers)-1:-1:2
    	for jj = 1:length(layers{ii})
    		deriv_E{ii}(jj) = diff_activate(layers{ii-1}'*weights{ii-1}(:, jj), activation_functions{ii}) * (deriv_E{ii+1}'*weights{ii}(jj, :)');
    		weight_change{ii-1}(:, jj) = deriv_E{ii}(jj) .* learning_rate .* layers{ii-1}(jj);
    	end
    end
    
	%for ii = length(layers)-1:-1:2
    %    deriv_E{ii} = diff_activate((layers{ii-1}' * weights{ii-1})', activation_functions{ii})   .*  (weights{ii}*deriv_E{ii+1});
    %    weight_change{ii-1} = learning_rate .* layers{ii-1} * deriv_E{ii}';		
    %end	

    for ii = 1:length(weights)
        weights{ii} = weights{ii} + weight_change{ii};
    end

end

