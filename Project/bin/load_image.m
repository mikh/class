function [ matrix ] = load_image( image_path )
    a = imread(image_path);
    [r,c,z] = size(a);
    if z == 3
        a = rgb2gray(imread(image_path));
    end
    matrix = double(a(:,:));
	[r, c] = size(matrix);
	matrix = reshape(matrix, r*c, 1);
end

