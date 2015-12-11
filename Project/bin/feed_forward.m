function [ layers ] = feed_forward( example, layers, weights, activation_functions )
	layers{1} = activate(example, activation_functions{1});
    for ii = 2:length(layers)
        for jj = 1:length(layers{ii})
            value = 0;
            for kk = 1:length(layers{ii-1})
                value = value + (layers{ii-1}(kk)*weights{ii-1}(kk, jj));
            end
            layers{ii}(jj) = activate(value, activation_functions{ii});
        end
    end
end
