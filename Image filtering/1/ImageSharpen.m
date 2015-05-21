%% Q1 CS663 Assignment 2-Image sharpening
% We will be using unsharp masking for this particular purpose
%% Code explanation
% filter the image with gaussian, invert it, scale it and add to original
% image
% normalise the resulting image
% no need to separate the gaussian filter and convolve because imfilter
% tests for separability in case of 2 dimensional filter
% normalising even after gaussian filtering as it seems that gaussian
% filtering does not keep the image in (0,1)
%% 
function [imageOut]=ImageSharpen(inputImage,standardDeviation,scalingRatio)	
	filterSize=25;			  
	GaussianFilt = fspecial('gaussian',filterSize,standardDeviation);
	GaussianFilt = GaussianFilt/sum(sum(GaussianFilt));
	
	blurredImage=normalise(imfilter(inputImage,GaussianFilt,'conv'),1.0);		
	sharpenedImage= ((inputImage-blurredImage)*scalingRatio+inputImage);
	
	imageOut=sharpenedImage;		

end
