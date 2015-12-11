function [ layers, weights ] = train_neural_network_by_epoch( examples, labels, layers, weights, activation_functions, learning_rate, iterations )
    weight_change = cell(length(weights), 1);
    for ii = 1:length(weights)
        [r,c] = size(weights{ii});
        weight_change{ii} = zeros(r,c);
    end

    for ii = 1:iterations
        %fprintf('Iteration %d of %d\n', ii, iterations);
        for jj = 1:length(examples)
            layers = feed_forward_fast(examples{jj}, layers, weights, activation_functions);
            weight_change_new = back_propogate_fast(labels{jj}, layers, weights, activation_functions, learning_rate);
            for kk = 1:length(weight_change)
                weight_change{kk} = weight_change{kk} + weight_change_new{kk};
            end
        end  
        for kk = 1:length(weight_change)
            weight_change{kk} = weight_change{kk}./length(examples);
            weights{kk} = weights{kk} + weight_change{kk};
        end

    end
   % layers = feed_forward_fast(example, layers, weights, activation_functions);
	%weights = back_propogate_fast(label, layers, weights, activation_functions, learning_rate);
end