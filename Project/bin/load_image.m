function [ matrix ] = load_image( image_path )
	a = imread(image_path);
	matrix = double(squeeze(a(:,:,1))) + (double(squeeze(a(:,:,2))) .* 256) + (double(squeeze(a(:,:,3))) .* 65536);
	[r, c] = size(matrix);
	matrix = reshape(matrix, r*c, 1);
end

