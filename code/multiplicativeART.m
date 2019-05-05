function [attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image)
	% Constructs the Attenuation Matrix %
	fprintf('Multiplicative Algorithm \n');
	
	[h,w] = size(squeeze(imaging_matrix(1,:,:)));
	attenuation = ones([h,w]);

	rrmse_list = zeros(size([n_iter,1]));

	for i=1:n_iter
		fprintf('Iteration %d \n', i);
		for curr_view = 1:num_views
			curr_ang = start_ang + (curr_view - 1)*del_ang;
			curr_matrix = squeeze(imaging_matrix(curr_view,:,:));
			% size(curr_matrix)
			rotated_attenuation = imrotate(attenuation, curr_ang, 'bilinear', 'crop');
			batch_back_proj = sum(rotated_attenuation.*curr_matrix, 1);
			denominator = squeeze(batch_back_proj(batch_back_proj > 0));
			radon_term  = squeeze(radon_transform(curr_view, :));
			update_term = ones(size(batch_back_proj));
			update_term(batch_back_proj > 0) = radon_term(batch_back_proj > 0)./denominator;
			% size(update_term)
			update_vector = repmat(update_term,[h,1]).*curr_matrix;
			% size(update_vector)
			attenuation = attenuation.*(imrotate(update_vector,-curr_ang,'bilinear','crop').^lambda);

			% Non negativity constraint as projection onto convex set
			attenuation(attenuation<0) = 0;
			attenuation(attenuation>1) = 1;

% 			imagesc(attenuation);
% 			waitforbuttonpress;
		end
		rrmse_list(i) = RRMSE(original_image, attenuation);
	end
end