function [ num_correct, result ] = test_neural_network( example, label, num_correct, layers, weights, activation_functions, threshold  )
    layers = feed_forward_fast(example, layers, weights, activation_functions);
    result = layers{length(layers)};
    
    correct_id = 0;
    for ii = 1:length(label)
        if label(ii) == 1
            correct_id = ii;
            break;
        end
    end
    
    if abs(result(correct_id) - label(correct_id)) < threshold
        num_correct = num_correct + 1;
    end
    result = correct_id;
end

