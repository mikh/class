function [ num_correct ] = test_neural_network( example, label, num_correct, layers, weights, activation_functions, threshold  )
    layers = feed_forward(example, layers, weights, activation_functions);
    result = layers{length(layers)};
    
    if abs(result - label) < threshold
        num_correct = num_correct + 1;
    end
end

