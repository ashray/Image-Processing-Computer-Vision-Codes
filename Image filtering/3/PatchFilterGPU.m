function [imageOut]=PatchFilterGPU(imageIn, patchLength, sigma4GaussPatch, windowLength, sigma4Window)
	border=floor(patchLength/2);
	paddedImage=single(padImage(imageIn,border));	
	DisplayImage(fspecial('gaussian',[patchLength patchLength],sigma4GaussPatch),1);	
	
	M = size(imageIn, 1);
	N = size(imageIn, 2);
	
	imageIn = single(imageIn);
	imageInGPU = gpuArray(imageIn);
	sigma4WindowGPU = gpuArray(single(sigma4Window));
	
	% multiply patches by gaussian and save them (fast)
	tic;
	gd=gpuDevice();
	Indices4D = 1:M*N*patchLength*patchLength;
	patchesEveryPixel= gpuArray.zeros(M, N, patchLength*patchLength,'single');
	
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
			gpuArray(single(reshape( ...
				fspecial('gaussian',[patchLength patchLength],sigma4GaussPatch), ...
				[1 1 patchLength*patchLength]))));
	wait(gd);
	toc;
	
% 	% Fast Patch Filterin
% 	WeightImage = gpuArray.zeros(1,size(imageIn,1)*size(imageIn,2),'single');
% 	IntensityImage = gpuArray.zeros(1,size(imageIn,1)*size(imageIn,2),'single');
	Mgpu = gpuArray(single(M));
	Ngpu = gpuArray(single(N));
	
	function [weightOut, IntOut] = getWeight(in)
		winColNo = -12;
		winRowNo = -12;
		Row = mod(in-1,Mgpu) + 1;
		Col = ceil(in/Mgpu);
		weightOut = 0;
		IntOut = 0;
		
		while winColNo <= 12
			while winRowNo <= 12
				patchWeights=0;
				if  Row + winRowNo > 0 && Col + winColNo > 0 ...
						&& Row + winRowNo <= Mgpu && Col + winColNo <= Ngpu
					for i = 1:81
						patchWeights(1) = patchWeights(1) + (patchesEveryPixel(Row+winRowNo,Col+winColNo,i)- ...
											patchesEveryPixel(Row,Col,i))^2;
					end
					patchWeights(1) = exp(-patchWeights(1)/(2*sigma4WindowGPU^2));
					weightOut = weightOut + patchWeights(1);
					IntOut = IntOut + imageInGPU(in)*patchWeights(1);
				end
				winRowNo = winRowNo+1;
			end
			winColNo = winColNo+1;
		end
	end
% 
% 			RelCoreRows = single(max(winCenter-winRowNo+1,1):min(size(imageIn,1)+winCenter-winRowNo,size(imageIn,1)));
% 			RelCoreCols = single(max(winCenter-winColNo+1,1):min(size(imageIn,2)+winCenter-winColNo,size(imageIn,2)));
% 			
% 			RelNeighRows = single(max(winRowNo-winCenter+1,1):min(size(imageIn,1)-winCenter+winRowNo,size(imageIn,1)));
% 			RelNeighCols = single(max(winColNo-winCenter+1,1):min(size(imageIn,2)-winCenter+winColNo,size(imageIn,2)));
% 
% 			patchWeights = (exp(-sum( ...
% 						 (patchesEveryPixel(RelNeighRows, RelNeighCols,:) ...
% 					   - patchesEveryPixel(RelCoreRows, RelCoreCols,:)).^2, ...
% 								3,'native')/(2*sigma4Window^2)));
% 			
% 			WeightImage(RelCoreRows,RelCoreCols) = ...
% 						WeightImage(RelCoreRows,RelCoreCols) + patchWeights;
% 			IntensityImage(RelCoreRows,RelCoreCols) = ...
% 						IntensityImage(RelCoreRows,RelCoreCols) ...
% 					  + patchWeights.*imageIn(RelNeighRows,RelNeighCols);
% 		fprintf('Done Col No. %d\n', winColNo);
	
	indexarray = gpuArray(1:size(imageIn,1)*size(imageIn,2));
	tic;
	[WeightImage, IntensityImage] = arrayfun(@getWeight, indexarray);
	wait(gd);
	toc;
	imageOut = reshape(gather(IntensityImage./WeightImage), size(image,1), size(image,2));
end

