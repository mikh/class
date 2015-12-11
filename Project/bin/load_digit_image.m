function [ matrix, fid ] = load_digit_image( fid )
    [matrix, N] = fread(fid, [28 28], 'uint8');
    [r,c] = size(matrix);
    for ii = 1:r
        for jj = 1:c
            if matrix(ii, jj) > 0
                matrix(ii, jj) = 1;
            end
        end
    end
    
    matrix = reshape(matrix, r*c, 1);

end

