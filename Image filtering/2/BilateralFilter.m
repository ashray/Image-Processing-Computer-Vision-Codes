%% Q2-CS 663 Assignment 2 Bilateral filtering

%% Code explanation
% 3d convolution 
% we create a 3d space with one more dimension(intensity).
% since gaussian is separable the convolution will be separated out into
% convolution over x, over y and then over Intensity dimension.
% this 3d convolution is done once for noisy image and once for weights.
% outptut of the convolution with noisy image is divided(point by point)
% with the output from convolution with the weights.
% could not vectorise the 'expansion of 2d space into 3d space'
% 
% The code employs downsampling to conserve both MEMORY (Important) and TIME.


%%

function [filteredImage]=BilateralFilter(inputImage, sigmaSpace, sigmaIntensity, samplingFactor)
	
	sigmaSpaceSub = sigmaSpace/samplingFactor;
	sigmaIntensitySub = sigmaIntensity/samplingFactor;
	
	sFilterSpace= ceil(4*sigmaSpace/samplingFactor);%size of Filter
	sFilterInt = ceil(4*sigmaIntensity/samplingFactor);
	
	x=1:size(inputImage,2);
	y=1:size(inputImage,1);
	I=1:256;
	
	inputImagePadded=zeros(ceil(length(y)/samplingFactor)*samplingFactor, ...
						   ceil(length(x)/samplingFactor)*samplingFactor);
	
	inputImagePadded(y,x) = inputImage;
	inputImage = inputImagePadded;
	clear inputImagePadded;

	spatioIntensitySpace=zeros(ceil(length(x)/samplingFactor),ceil(length(y)/samplingFactor),ceil(length(I)/samplingFactor));	
	weightSpace = zeros(size(spatioIntensitySpace));

	% Intensity Splitting 
	IntensitySplit = cell(1, 255);
	for i = 0:(ceil(256/samplingFactor)-1)
		IntensitySplit{i+1} = find(inputImage >= uint8(i*samplingFactor) & inputImage<=uint8((i+1)*samplingFactor-1));
	end

	% Resampling Section
	
	imageSlice = zeros(size(inputImage));
	for i = 0:(ceil(256/samplingFactor) - 1)
		% for spatioIntensitySpace
		imageSlice(IntensitySplit{i+1}) = inputImage(IntensitySplit{i+1});
		spatioIntensitySpace(:,:,i+1) = reshape(sum(sum(reshape(imageSlice, ...
										[samplingFactor, size(inputImage,1)/samplingFactor, ...
											samplingFactor, size(inputImage,2)/samplingFactor]),1),3), ...
										[size(inputImage,1)/samplingFactor, size(inputImage,2)/samplingFactor]);
		imageSlice(IntensitySplit{i+1}) = 0;
		
		% for weightSpace
		imageSlice(IntensitySplit{i+1}) = 1;
		weightSpace(:,:,i+1) = reshape(sum(sum(reshape(imageSlice, ...
										[samplingFactor, size(inputImage,1)/samplingFactor, ...
											samplingFactor, size(inputImage,2)/samplingFactor]),1),3), ...
										[size(inputImage,1)/samplingFactor, size(inputImage,2)/samplingFactor]);
		%disp(i);
		spatioIntensitySpace(:,:,i+1) = spatioIntensitySpace(:,:,i+1)/(samplingFactor^3);
		weightSpace(:,:,i+1) = weightSpace(:,:,i+1)/(samplingFactor^3);
		imageSlice(IntensitySplit{i+1}) = 0;
	end
	
	vertFilt = reshape(fspecial('gaussian',[sFilterSpace 1],sigmaSpaceSub),[sFilterSpace 1 1 ]);
	vertFiltered=single(imfilter(single(spatioIntensitySpace),vertFilt/sum(vertFilt),'conv'));
	clear spatioIntensitySpace;
	horiFilt = reshape(fspecial('gaussian',[1 sFilterSpace],sigmaSpaceSub),[1 sFilterSpace 1]);
	horiFiltered=single(imfilter(vertFiltered, horiFilt/sum(horiFilt),'conv'));
	clear vertFiltered;
	intenFilt = reshape(fspecial('gaussian',[sFilterInt 1],sigmaIntensitySub),[1 1 sFilterInt]);
	intenFiltered=single(imfilter(horiFiltered,intenFilt/sum(intenFilt),'conv'));
	clear horiFiltered;
	%gaussFilter=mvnpdf(spatioIntensitySpace,mean,stdDeviation);	
	
	weightVFilt = reshape(fspecial('gaussian',[sFilterSpace 1],sigmaSpaceSub),[sFilterSpace 1 1 ]);
	weightVFiltered=single(imfilter(single(weightSpace),weightVFilt/sum(weightVFilt),'conv'));
	clear weightSpace;
	weightHFilt = reshape(fspecial('gaussian',[1 sFilterSpace],sigmaSpaceSub),[1 sFilterSpace 1]);
	weightHFiltered=single(imfilter(weightVFiltered,weightHFilt/sum(weightHFilt),'conv'));
	clear weightVFiltered;
	weightIFilt = reshape(fspecial('gaussian',[sFilterInt 1],sigmaIntensitySub),[1 1 sFilterInt]);
	weightIFiltered=single(imfilter(weightHFiltered, weightIFilt/sum(weightIFilt),'conv'));
	clear weightHFiltered;

	filteredImage=zeros(size(inputImage));
	[ColIndices2D, RowIndices2D] = meshgrid(1:size(inputImage,2), 1:size(inputImage,1));
	IndexSequence = [reshape(RowIndices2D, 1, []);
					 reshape(ColIndices2D, 1, []);
					 reshape(single(inputImage)+1, 1, [])];
	
	spatioIntVectRel = TriNLinearInterp(intenFiltered, IndexSequence, samplingFactor);
	weightVectRel = TriNLinearInterp(weightIFiltered, IndexSequence, samplingFactor);
	
	% Linear Interpolation
	
	filteredImage(:,:) = reshape(spatioIntVectRel./weightVectRel, size(inputImage));
	filteredImage = filteredImage(1:length(y), 1:length(x));
	filteredImage = filteredImage/255;
end