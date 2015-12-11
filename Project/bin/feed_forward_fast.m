function [ layers ] = feed_forward_fast( example, layers, weights, activation_functions )
    layers{1} = activate(example, activation_functions{1});
    for ii = 2:length(layers)
        layers{ii} = activate((layers{ii-1}'*weights{ii-1})', activation_functions{ii});
    end
end

