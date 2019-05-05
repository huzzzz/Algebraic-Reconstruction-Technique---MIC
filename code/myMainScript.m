%% MyMainScript
clc;
close all;
clear;
% warning('off','all');

% Setting the color scale %
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

% Set to_save to 1, if you want to save the generated pictures %
to_save  = 0;
is_color = 1;

tic;
%% Load Image to be reconstructed
% Loading the denoised image
original_image = phantom(128);
% original_image = im2double(imread('../data/brain_mri.jpg'));

savefig(my_color_scale,original_image,"Original Image","Original.png",1,to_save);
[h,w] = size(original_image);

% Optional - Adding Poisson Noise to the image as it's an MRI image

%% Setting parameters of Radon Transform
% Note : del_t has to be an integer and make sure the num_bins divide h perfectly and are themselves integers
num_bins  = h;
num_views = 180;
start_ang = 0;
stop_ang  = 180;
del_ang   = (stop_ang - start_ang)/num_views;
del_t     = h/num_bins;

lambda    = 1;
n_iter    = 100;
variant   = 'Additive';
% variant   = 'Multiplicative';
% variant   = 'SIRT';

%% Construct 'b' the radon transform
radon_transform = constructRadonTransform(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
% savefig(my_color_scale,radon_transform,"Radon Transform","RadonTransform.png",1,to_save);

%% Construct matrix A
imaging_matrix = constructImagingMatrix(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);

%% Find attenuation coefficients 'x' by ART variants
if strcmp(variant,'Additive')
	
	[attenuation, rrmse_list] = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);

elseif strcmp(variant,'Multiplicative')
	
	[attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
	
elseif strcmp(variant,'SIRT')
	
	[attenuation, rrmse_list] = simultaneousIRT(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);

else

	fprintf('Unknown Variant')

end

disp(size(attenuation));
savefig(my_color_scale,attenuation,"Reconstructed Image","ReconstructedImage.png",1,to_save);

toc;

% Helper function to save the figures %
function savefig(my_color_scale,modified_pic,title_name,file_name,is_color,to_save)
	if to_save==1
		fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
	else
		fig = figure; colormap(my_color_scale);
	end

	if is_color == 1
		colormap jet;
	else
		colormap(gray);
	end
	
	imagesc(modified_pic), title(title_name), colorbar, daspect([1 1 1]), axis tight;
	impixelinfo();
	if to_save == 1
		saveas(fig,file_name);
		% close(fig);
	end
end
