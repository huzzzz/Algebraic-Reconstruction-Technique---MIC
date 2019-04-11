function radon_transform = constructRadonTransform(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
	% Calculates the radon transform of the image for given angle range and given t value range %
	radon_transform = zeros([num_views, num_bins]);
	for ang=start_ang:del_ang:stop_ang-del_ang
		radon_transform(ang+1,:) = projectImage(original_image, ang, del_t, num_bins);
	end
end