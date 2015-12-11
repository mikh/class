clc;
clear;

test_mat = magic(20);

example = test_mat(:, 1);
layers = cell(4, 1);
layers{1} = zeros(20, 1);
layers{2} = zeros(10, 1);
layers{3} = zeros(10, 1);
layers{4} = zeros(1,1);
weights = cell(3, 1);
weights{1} = zeros(20,10) + (1/(20*10));
weights{2} = zeros(10,10)+ 1/100;
weights{3} = zeros(10,1)+1/10;

result_slow = feed_forward(example, layers, weights, {'LINEAR', 'SIGMOID', 'SIGMOID', 'LINEAR'});
layers = cell(4, 1);
layers{1} = zeros(20, 1);
layers{2} = zeros(10, 1);
layers{3} = zeros(10, 1);
layers{4} = zeros(1,1);

result_fast = feed_forward_fast(example, layers, weights, {'LINEAR', 'SIGMOID', 'SIGMOID', 'LINEAR'});

if length(result_slow) ~= length(result_fast)
    fprintf('Dimension mismatch 1\n');
end

for ii = 1:length(result_slow)
    [r,c] = size(result_slow{ii});
    [r_f, c_f] = size(result_fast{ii});
    if (r ~= r_f) || (c ~= c_f)
        fprintf('Dimensions mismatch 2 %d\n', ii);
    end
    
    for jj = 1:r
        for kk = 1:c
            if result_slow{ii}(jj, kk) ~= result_fast{ii}(jj, kk)
                fprintf('Value mismatch %d %d %d\n', ii, jj, kk);
            end
        end
    end
end
fprintf('Done.\n\n');



fprintf('backpropogate\n');
slow_weights = back_propogate(3, result_fast, weights, {'LINEAR', 'SIGMOID', 'SIGMOID', 'LINEAR'}, .2);
fast_weights = back_propogate_fast(3, result_fast, weights, {'LINEAR', 'SIGMOID', 'SIGMOID', 'LINEAR'}, .2);


if length(slow_weights) ~= length(fast_weights)
    fprintf('Dimension mismatch 1\n');
end

for ii = 1:length(slow_weights)
    [r,c] = size(slow_weights{ii});
    [r_f, c_f] = size(fast_weights{ii});
    if (r ~= r_f) || (c ~= c_f)
        fprintf('Dimensions mismatch 2 %d\n', ii);
    end
    
    for jj = 1:r
        for kk = 1:c
            if slow_weights{ii}(jj, kk) ~= fast_weights{ii}(jj, kk)
                fprintf('Value mismatch %d %d %d\n', ii, jj, kk);
            end
        end
    end
end
fprintf('Done\n\n');


