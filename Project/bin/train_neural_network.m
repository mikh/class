function [ layers, weights ] = train_neural_network( example, label, layers, weights, activation_functions, learning_rate )
	layers = feed_forward(example, layers, weights, activation_functions);
	weights = back_propogate(label, layers, weights, activation_functions, learning_rate);
end
