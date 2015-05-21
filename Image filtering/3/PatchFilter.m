%% Q3 Assignment 2 CS 663 
%% Patch Based Filtering
% we first generate a 4d matrix containing the patches for each pixel and
% then compute the disatances between patches
% sigma4gaussPatch= std deviation for the gassian for the patch to make it
% isotropic.
% image is zero padded so that the patch can go outside the image when the
% pixel lies on the edge or on the corner. Couldn't vectorise the saving of
% the patches in |patchesEveryPixel| matrix. As it seems a 2d array cannot
% be directly extracted from a 4d array, a function called |squeeze| is
% essential. I wish i could have computed the output of gaussian weighting
% of patches and giving new value to our center pixel, but i guess it will
% have a lot of overhead. The patches are stored in planes and the actual
% pixel locations is a 2d vector, so the multidimensional array planes is
% actually a matrix of planes, where planes are the patches.
% (ref:http://www.mathworks.in/help/matlab/math/multidimensional-arrays.html#f1-87200)
% Also assumed that patch length and window length are odd. dont know what
% will happen if they are even. 
% Also one problem is that if size of patches4Com
% preallocated then we cant effectively subtracts the patch for the center
% pixel from all the patches, since some of the patches corresponding to
% outside the image will be 0 and we will essentially subtract a non zero
% value from a zero value. This will be a problem because later on we are
% squaring it.
% assigning values to patches4Com was the most difficult to code without
% instantiating a new array.
% I realised that we do not need a gaussian filter for weighting the
% patches in the window but we need a gaussian function.
% patchWeights contains only those weights for which the center point of 
% the patch was inside the image. patchWeights could not be normalised.

% patches4Com = save patches temporarily for computation purposes of
% distances.
% sigma4PsInWindow = sigma for gaussian, for patches in window.
% findNonZero = logical array to find which of the patches are non zero.
% convention for naming: variables and functions in camelcase, variables 
% start with lowercase and functions start with uppercase
%% To be done
% Make the program memory efficient. allocate the bigger vectors before the
% smaller vectors. Try if batch processing is possible.
% combinations of sigma tried (5,9),(5,1),(5,0.1)->blurred,(4,0.001)->same
% image,(4,0.01)->same image,image,(4,0.1)->very smooth type of
% image,(4,0.06)->good but a little blurred rmsd=40,
%% 
function [imageOut,rmsd]=PatchFilter(imageIn, patchLength, sigma4GaussPatch, windowLength, sigma4Window)
	border=floor(patchLength/2);
	paddedImage=single(padImage(imageIn,border));	
	DisplayImage(fspecial('gaussian',[patchLength patchLength],sigma4GaussPatch),1);	
	
	M = size(imageIn, 1);
	N = size(imageIn, 2);
	
	imageIn = single(imageIn);
	
	% multiply patches by gaussian and save them (fast)
	patchCenter = floor((patchLength+1)/2); % floor is just for the sake.
											% This should be an integer
	Indices4D = 1:M*N*patchLength*patchLength;
	patchesEveryPixel= zeros(M, N, patchLength*patchLength,'single');
	
	patchValImgIndex = (mod(Indices4D-1, M) + 1 ...
					+ floor(mod(Indices4D-1, M*N*patchLength)/(M*N))) + ...
					   (floor(mod(Indices4D-1,M*N)/M) ...
					+ floor((Indices4D-1)/(M*N*patchLength)))*(M+patchLength-1);
	patchesEveryPixel(:,:,:) = single(reshape( ...
									paddedImage(patchValImgIndex), ...
								[M,N,patchLength*patchLength]));
	
	clear  patchValImgIndex;
	
	patchesEveryPixel(:,:,:,:) = bsxfun(@times, ...
			patchesEveryPixel,...
			reshape( ...
				single(fspecial('gaussian',[patchLength patchLength],sigma4GaussPatch)), ...
				[1 1 patchLength*patchLength]));
	
	% Fast Patch Filterin
	WeightImage = zeros(size(imageIn,1),size(imageIn,2),'single');
	IntensityImage = zeros(size(imageIn,1),size(imageIn,2),'single');
	
	winCenter = floor((windowLength+1)/2);
	tic;

	for winColNo = 1:windowLength
		for winRowNo = 1:windowLength
			
			RelCoreRows = single(max(winCenter-winRowNo+1,1):min(size(imageIn,1)+winCenter-winRowNo,size(imageIn,1)));
			RelCoreCols = single(max(winCenter-winColNo+1,1):min(size(imageIn,2)+winCenter-winColNo,size(imageIn,2)));
			
			RelNeighRows = single(max(winRowNo-winCenter+1,1):min(size(imageIn,1)-winCenter+winRowNo,size(imageIn,1)));
			RelNeighCols = single(max(winColNo-winCenter+1,1):min(size(imageIn,2)-winCenter+winColNo,size(imageIn,2)));

			patchWeights = (exp(-sum( ...
						 (patchesEveryPixel(RelNeighRows, RelNeighCols,:) ...
					   - patchesEveryPixel(RelCoreRows, RelCoreCols,:)).^2, ...
								3,'native')/(2*sigma4Window^2)));
			
			WeightImage(RelCoreRows,RelCoreCols) = ...
						WeightImage(RelCoreRows,RelCoreCols) + patchWeights;
			IntensityImage(RelCoreRows,RelCoreCols) = ...
						IntensityImage(RelCoreRows,RelCoreCols) ...
					  + patchWeights.*imageIn(RelNeighRows,RelNeighCols);
		end
		fprintf('Done Col No. %d\n', winColNo);
	end
	toc;
	
	imageOut = IntensityImage./WeightImage;
end