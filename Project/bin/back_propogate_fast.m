function [ weight_change ] = back_propogate_fast( label, layers, weights, activation_functions, learning_rate )
	weight_change = cell(length(weights), 1);
    for ii = 1:length(weights)
        [r,c] = size(weights{ii});
        weight_change{ii} = zeros(r,c);
    end

    delta = cell(length(layers), 1);
	for ii = 1:length(layers)
		[r, c] = size(layers{ii});
		delta{ii} = zeros(r, c);
	end
    
    %output layer
    ii = length(layers);
    delta{ii} = (label - layers{ii}) .* diff_activate(layers{ii}, activation_functions{ii});
    
    %hidden layers
    for ii = length(layers)-1:-1:2
        value = delta{ii+1}'*weights{ii}';
        delta{ii} = diff_activate(layers{ii}, activation_functions{ii}).*value';
    end
    
    %compute new weights
    for l = 1:length(weights)
        t1 = layers{l};
        t2 = delta{l+1};
        t3 = t1*t2';    
        t3 = t3 * learning_rate;
        weight_change{l} = t3;
    end
end

