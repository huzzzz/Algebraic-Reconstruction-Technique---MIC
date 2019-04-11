function attenuation = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda)
	% Constructs the Attenuation Matrix %
	[h,w] = size(squeeze(imaging_matrix(1,:,:)));
	attenuation = zeros([h,w]);

	for i=1:n_iter
		fprintf('Iteration %d \n', i);
		for curr_view = 1:num_views
			
			curr_ang = start_ang + (curr_view - 1)*del_ang;
			curr_matrix = squeeze(imaging_matrix(curr_view,:,:));
			% size(curr_matrix)
			rotated_attenuation = imrotate(attenuation, curr_ang, 'bilinear', 'crop');
			batch_back_proj = sum(rotated_attenuation.*curr_matrix, 1);
			denominator = sum(curr_matrix.^2,1);
			denominator(denominator==0) = 1;
			update_term = (squeeze(radon_transform(curr_view, :)) - batch_back_proj)./denominator;
			% size(update_term)
			update_vector = repmat(update_term,[h,1]).*curr_matrix;
			% size(update_vector)
			attenuation = attenuation + lambda*imrotate(update_vector,-curr_ang,'bilinear','crop');

			% Non negativity constraint as projection onto convex set
			attenuation(attenuation<0) = 0;
			attenuation(attenuation>1) = 1;

			
		end
	end
end