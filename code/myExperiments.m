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
to_save  = 1;
is_color = 1;

tic;
%% Load Image to be reconstructed
% Loading the denoised image
original_image = phantom(128);
% original_image = im2double(imread('../data/brain_mri.jpg'));

% savefig(my_color_scale,original_image,"Original Image","Original.png",1,to_save);
[h,w] = size(original_image);

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

radon_transform = constructRadonTransform(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
%% Construct matrix A
imaging_matrix = constructImagingMatrix(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);

fig = figure;
[attenuation, rrmse_list] = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% savefig(my_color_scale,attenuation,"Reconstructed Image AART","ReconstructedImageAdditive.png",1,to_save);

plot(rrmse_list);
hold on

[attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% savefig(my_color_scale,attenuation,"Reconstructed Image MRT","ReconstructedImageMultiplicative.png",1,to_save);
plot(rrmse_list);
hold on

% n_iter    = 200;
% [attenuation, rrmse_list] = simultaneousIRT(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% savefig(my_color_scale,attenuation,"Reconstructed Image SIRT","ReconstructedImageSimultaneous.png",1,to_save);


xlabel('Iteration number');
ylabel('RRMSE values');
title("RRMSE vs Iteration for different variants of ART");
legend('Add','Mult')
saveas(fig,"RRMSE.png");
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% RRMSE of different algorithms on phantom image with noise
% %% Construct 'b' the radon transform
% radon_transform = constructRadonTransform(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
% radon_transform = imnoise(radon_transform*1e-12, 'poisson')*1e12;
% savefig(my_color_scale,radon_transform,"Radon Transform","RadonTransform.png",1,to_save);

% %% Construct matrix A
% imaging_matrix = constructImagingMatrix(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);

% fig = figure;

% [attenuation, rrmse_list] = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% file_name = 'ReconstructedImageAdditive_poisson.png';
% imwrite(attenuation, file_name);
% plot(rrmse_list);
% hold on
% [attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% file_name = 'ReconstructedImageMultiplicative_poisson.png';
% imwrite(attenuation, file_name);
% plot(rrmse_list);
% hold on
% [attenuation, rrmse_list] = simultaneousIRT(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% file_name = 'ReconstructedImageSimultaneous_poisson.png';
% imwrite(attenuation, file_name);
% plot(rrmse_list);
% hold on

% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for different variants of ART");
% legend('Add','Mult','Simul')
% saveas(fig,"RRMSE_poisson.png");
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% RRMSE of different algorithms on phantom image without noise
% %% Construct 'b' the radon transform
% radon_transform = constructRadonTransform(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
% % savefig(my_color_scale,radon_transform,"Radon Transform","RadonTransform.png",1,to_save);

% %% Construct matrix A
% imaging_matrix = constructImagingMatrix(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);

% fig = figure;

% [attenuation, rrmse_list] = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% file_name = 'ReconstructedImageAdditive.png';
% imwrite(attenuation, file_name);
% plot(rrmse_list);
% hold on
% [attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% file_name = 'ReconstructedImageMultiplicative.png';
% imwrite(attenuation, file_name);
% plot(rrmse_list);
% hold on
% [attenuation, rrmse_list] = simultaneousIRT(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% file_name = 'ReconstructedImageSimultaneous.png';
% imwrite(attenuation, file_name);
% plot(rrmse_list);
% hold on

% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for different variants of ART");
% legend('Add','Mult','Simul')
% saveas(fig,"RRMSE.png");
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% RRMSE of different algorithms on phantom image without poisson noise for different lambdas

% %% Construct 'b' the radon transform
% %% Adding poisson noise to original image
% radon_transform = constructRadonTransform(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
% savefig(my_color_scale,radon_transform,"Radon Transform","RadonTransform.png",1,to_save);

% %% Construct matrix A
% imaging_matrix = constructImagingMatrix(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);

% fig = figure;
% for lambda = [0.5, 1, 1.5]
% 	[attenuation, rrmse_list] = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% 	% savefig(my_color_scale,attenuation,strcat("Reconstructed Image lambda = ", num2str(lambda)),strcat("ReconstructedImageAdditive_lambda_",num2str(lambda),".png"),1,to_save);
% 	file_name = strcat('ReconstructedImageAdditive_lambda_',num2str(lambda), '.jpg');
% 	imwrite(attenuation, file_name);
% 	plot(rrmse_list);
% 	hold on
% end
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for ART");
% legend('lamb=0.5','lamb=1','lamb=1.5');
% saveas(fig,"RRMSE_ART_lambda.png");
% hold off;

% fig = figure;
% for lambda = [0.5, 1, 1.5]
% 	[attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% 	% savefig(my_color_scale,attenuation,strcat("Reconstructed Image lambda = ", num2str(lambda)),strcat("ReconstructedImageMultiplicative_lambda_",num2str(lambda),".png"),1,to_save);
% 	file_name = strcat('ReconstructedImageMultiplicative_lambda_',num2str(lambda), '.jpg');
% 	imwrite(attenuation, file_name);
% 	plot(rrmse_list);
% 	hold on
% end
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for MRT");
% legend('lamb=0.5','lamb=1','lamb=1.5');
% saveas(fig,"RRMSE_MRT_lambda.png");
% hold off;

% fig = figure;
% for lambda = [0.5, 1, 1.5]
% 	[attenuation, rrmse_list] = simultaneousIRT(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% 	% savefig(my_color_scale,attenuation,strcat("Reconstructed Image lambda = ", num2str(lambda)),strcat("ReconstructedImageSimultaneous_lambda_",num2str(lambda),".png"),1,to_save);
% 	file_name = strcat('ReconstructedImageSimultaneous_lambda_',num2str(lambda), '.jpg');
% 	imwrite(attenuation, file_name);
% 	plot(rrmse_list);
% 	hold on
% end
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for SIRT");
% legend('lamb=0.5','lamb=1','lamb=1.5');
% saveas(fig,"RRMSE_SIRT_lambda.png");
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% RRMSE of different algorithms on phantom image with poisson noise for different lambdas

% %% Construct 'b' the radon transform
% %% Adding poisson noise to original image
% radon_transform = constructRadonTransform(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
% radon_transform = imnoise(radon_transform*1e-12, 'poisson')*1e12;
% savefig(my_color_scale,radon_transform,"Radon Transform","RadonTransform.png",1,to_save);

% %% Construct matrix A
% imaging_matrix = constructImagingMatrix(original_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);

% fig = figure;
% for lambda = [0.5, 1, 1.5]
% 	[attenuation, rrmse_list] = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% 	% savefig(my_color_scale,attenuation,strcat("Reconstructed Image lambda = ", num2str(lambda)),strcat("ReconstructedImageAdditive_lambda_",num2str(lambda),".png"),1,to_save);
% 	file_name = strcat('ReconstructedImageAdditive_lambda_',num2str(lambda), '.jpg');
% 	imwrite(attenuation, file_name);
% 	plot(rrmse_list);
% 	hold on
% end
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for ART");
% legend('lamb=0.5','lamb=1','lamb=1.5');
% saveas(fig,"RRMSE_ART_lambda_poisson.png");
% hold off;

% fig = figure;
% for lambda = [0.5, 1, 1.5]
% 	[attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% 	% savefig(my_color_scale,attenuation,strcat("Reconstructed Image lambda = ", num2str(lambda)),strcat("ReconstructedImageMultiplicative_lambda_",num2str(lambda),".png"),1,to_save);
% 	file_name = strcat('ReconstructedImageMultiplicative_lambda_',num2str(lambda), '.jpg');
% 	imwrite(attenuation, file_name);
% 	plot(rrmse_list);
% 	hold on
% end
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for MRT");
% legend('lamb=0.5','lamb=1','lamb=1.5');
% saveas(fig,"RRMSE_MRT_lambda_poisson.png");
% hold off;

% fig = figure;
% for lambda = [0.5, 1, 1.5]
% 	[attenuation, rrmse_list] = simultaneousIRT(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% 	% savefig(my_color_scale,attenuation,strcat("Reconstructed Image lambda = ", num2str(lambda)),strcat("ReconstructedImageSimultaneous_lambda_",num2str(lambda),".png"),1,to_save);
% 	file_name = strcat('ReconstructedImageSimultaneous_lambda_',num2str(lambda), '.jpg');
% 	imwrite(attenuation, file_name);
% 	plot(rrmse_list);
% 	hold on
% end
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for SIRT");
% legend('lamb=0.5','lamb=1','lamb=1.5');
% saveas(fig,"RRMSE_SIRT_lambda_poisson.png");
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% lambda    = 1;

% % RRMSE of different algorithms on phantom image with Gaussian/Poisson noise
% % Adding gaussian noise to original image
% noisy_image = original_image;
% noise_sigma = 3.0;
% noise = randn(size(original_image))*noise_sigma/255;
% noisy_image = original_image + noise;
% savefig(my_color_scale,noisy_image,"Noisy Image","Noisy_Image.png",1,to_save);

% % Construct 'b' the radon transform
% radon_transform = constructRadonTransform(noisy_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);
% savefig(my_color_scale,radon_transform,"Radon Transform","RadonTransform.png",1,to_save);

% %% Adding poisson noise to original image
% radon_transform = imnoise(radon_transform*1e-12, 'poisson')*1e12;
% % savefig(my_color_scale,radon_transform,"Radon Transform","RadonTransform.png",1,to_save);


% %% Construct matrix A
% imaging_matrix = constructImagingMatrix(noisy_image, num_bins, num_views, start_ang, stop_ang, del_ang, del_t);

% [attenuation, rrmse_list] = additiveART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% savefig(my_color_scale,attenuation,"Reconstructed Image","ReconstructedImageAdditive_poisson.png",1,to_save);
% fig = figure;
% plot(rrmse_list);
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for ART");
% % saveas(fig,"Gauss_Noisy_RRMSE_ART.png");
% saveas(fig,"Poiss_Noisy_RRMSE_ART.png");


% [attenuation, rrmse_list] = multiplicativeART(radon_transform, imaging_matrix, n_iter, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% savefig(my_color_scale,attenuation,"Reconstructed Image","ReconstructedImageMultiplicative_poisson.png",1,to_save);
% fig = figure;
% plot(rrmse_list);
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for MRT");
% % saveas(fig,"Gauss_Noisy_RRMSE_MRT.png");
% saveas(fig,"Poiss_Noisy_RRMSE_MRT.png");

% [attenuation, rrmse_list] = simultaneousIRT(radon_transform, imaging_matrix, 100, num_views, start_ang, del_ang, stop_ang, lambda, original_image);
% savefig(my_color_scale,attenuation,"Reconstructed Image","ReconstructedImageSimultaneous_poisson.png",1,to_save);
% fig = figure;
% plot(rrmse_list);
% xlabel('Iteration number');
% ylabel('RRMSE values');
% title("RRMSE vs Iteration for SIRT");;


% % saveas(fig,"Gauss_Noisy_RRMSE_SIRT.png");
% saveas(fig,"Poiss_Noisy_RRMSE_SIRT.png");

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
		close(fig);
	end
end
