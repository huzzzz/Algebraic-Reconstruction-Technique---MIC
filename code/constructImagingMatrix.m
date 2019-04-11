function imaging_matrix = constructImagingMatrix(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
	% Constructs the Acquisition Matrix %
	[h,w] = size(original_image);
	imaging_matrix = zeros([num_views, h, w]);
	for ang=start_ang:del_ang:stop_ang-del_ang
		rotated_image = imrotate(original_image, ang, 'bilinear', 'crop');
		% imaging_matrix(ang+1,:,:) = rotated_image > 0.01;
		imaging_matrix(ang+1,:,:) = ones(size(rotated_image));
	end
end