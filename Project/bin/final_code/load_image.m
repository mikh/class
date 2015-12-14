function [ matrix ] = load_image( image_path )
    a = imread(image_path);
    [r,c,z] = size(a);
    if z == 3
        a = rgb2gray(imread(image_path));
    end
    matrix = double(a(:,:));
	[r, c] = size(matrix);
    
   % if minimize_matrix(1) ~= 0 && minimize_matrix(2) ~= 0
                
   % end
    
	matrix = reshape(matrix, r*c, 1);
end

