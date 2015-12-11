function [ weights ] = back_propogate( label, layers, weights, activation_functions, learning_rate )
	weight_change = cell(length(weights), 1);
	for ii = 1:length(weights)
		[r, c] = size(weights{ii});
		weight_change{ii} = zeros(r, c);
	end

	delta = cell(length(layers), 1);
	for ii = 1:length(layers)
		[r, c] = size(layers{ii});
		delta{ii} = zeros(r, c);
	end

    %output layer
    ii = length(layers);
    for jj = 1:length(layers{ii})
        delta{ii}(jj) = (label(jj) - layers{ii}(jj)) * diff_activate(layers{ii}(jj), activation_functions{ii});
    end
    
    %hidden layers
    for ii = length(layers)-1:-1:2
        for jj = 1:length(layers{ii})
            value = 0;
            for kk = 1:length(layers{ii+1})
                value = value + (delta{ii+1}(kk)*weights{ii}(jj, kk));
            end
            delta{ii}(jj) = diff_activate(layers{ii}(jj), activation_functions{ii})*value;
        end
    end
    
    %compute new weights
    for l = 1:length(weights)
        for ii = 1:length(layers{l})
            for jj = 1:length(layers{l+1})
                weights{l}(ii, jj) = weights{l}(ii, jj) + (learning_rate * delta{l+1}(jj) * layers{l}(ii));
            end
        end
    end

end

