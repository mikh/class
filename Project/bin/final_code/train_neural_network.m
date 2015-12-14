function [ layers, weights ] = train_neural_network( example, label, layers, weights, activation_functions, learning_rate )
	layers = feed_forward_fast(example, layers, weights, activation_functions);
	weights = back_propogate_fast(label, layers, weights, activation_functions, learning_rate);
end

