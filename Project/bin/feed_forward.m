function [ layers ] = feed_forward( example, layers, weights, activation_functions )
	layers{1} = activate(example, activation_functions{1});
	for ii = 2:length(layers)
		nets = layers{ii-1}'*weights{ii-1};
		layers{ii} = activate(nets', activation_functions{ii});
	end
end
