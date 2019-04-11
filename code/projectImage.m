function projection = projectImage(original_image, theta, del_t, num_bins)
	% Calculates the radon transform values for a particular angle for all t values %
	[h,w] = size(original_image);
	rotated_image = imrotate(original_image, theta, 'bilinear', 'crop');
	projection = sum(rotated_image, 1);
	projection = projection(1:del_t:w);
	projection = projection(1:num_bins);
end