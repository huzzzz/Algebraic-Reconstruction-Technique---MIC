function rrmse = RRMSE(image1, image2)
	min1 = min(min(image1));
	min2 = min(min(image2));
	max1 = max(max(image1));
	max2 = max(max(image2));
	
	image1 = (image1 - min1)/(max1 - min1);
	image2 = (image2 - min2)/(max2 - min2);

	rrmse = sqrt(sum(sum((abs(image1) - abs(image2)).^2))/sum(sum((abs(image1).^2))));
end