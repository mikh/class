function [ layers, weights, activation_functions ] = create_neural_network( num_input, hidden_layers, num_outputs, input_activation, hidden_activations, output_activation )
	num_layers = 2+length(hidden_layers);
	layers = cell(num_layers, 1);
	weights = cell(num_layers - 1, 1);
	layers{1} = zeros(num_input, 1);
	for ii = 1:length(hidden_layers)
		layers{ii+1} = zeros(hidden_layers(ii), 1);
	end
	layers{num_layers} = zeros(num_outputs, 1);

	for ii = 1:num_layers-1
		weights{ii} = ones(length(layers{ii}), length(layers{ii+1}));
	end

	activation_functions = cell(num_layers);
	activation_functions{1} = input_activation;
	for ii = 1:length(hidden_layers)
		activation_functions{ii+1} = hidden_activations{ii};
	end
	activation_functions{num_layers} = output_activation;

end

