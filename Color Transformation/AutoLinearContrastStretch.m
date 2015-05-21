%% LinearContrastStretch function
% This function increases contrast with the help of a piecewise defined
% linear function. The function takes the intensity range where all
% intensities are grouped together and linearly spreads out those grouped
% intensities.
% The range of intensities in the input image to spread out is decided
% beuristically. In our case the intensities corresponding to 80 percentile
% of the total pixels are spread out in the range of [0.1,0.9]
%% Code Explanation 
% we first conver the image  to the range of [0,1] so that pixels will not
% get rounded off while doing computations on them.
% Then for finding the range of intensities which cover 80% of the pixels
% we compute the histogram of the image. We then find the first intensity
% which is greater than 10 percentile and the first intensity which is
% greater than 90 percentile
% |outputRatio| is the fraction of the *output* intensities over which the 
% contrast is going to be  stretched. Then we find the slopes of 
% the piecewise defined functions based on the values of |alpha|, |beta| and 
% |outputRatio|.
% we then apply the transform to all pixels within [0,|alpha|), [|alpha|,|beta|)
% and [|beta|,1]
%%

function [contrastStretchedImage]=AutoLinearContrastStretch(ImageMat, varargin)
	
	if isinteger(ImageMat)
		nbins = double(max(255, max(max(max(ImageMat))))) + 1;
		Range = [0 nbins-1];
	else
		Range = [0 1];
		nbins = 256;
	end
	percentile = 90;
	nParams = floor(length(varargin)/2);
	for i = 1:nParams
		if strcmpi(varargin{2*i-1}, 'Range')
			Range = varargin{2*i};
		elseif strcmpi(varargin{2*i-1}, 'nbins')
			nbins = varargin{2*i};
		elseif strcmpi(varargin{2*i-1}, 'percentile')
			percentile = varargin{2*i};
		end
	end


	if isinteger(ImageMat)
		IntensityList = Range(1):Range(2);
	else
		IntensityList = linspace(Range(1), Range(2), nbins);
	end

    outputRatio=0.9;
    NChannels = size(ImageMat, 3);
    doubleImage=(double(ImageMat) - Range(1))/(Range(2) - Range(1)) ;
    contrastStretchedImage=zeros(size(ImageMat));
	
	beginFraction = (100-percentile)/200;
    for i=1:NChannels  

		doubleImageChannel = doubleImage(:,:,i);
        cumulativeIntensity=cumsum(sum(hist(double(ImageMat(:,:,i)),IntensityList), 2));
        fractionCumIntensity=cumulativeIntensity/numel(ImageMat(:,:,i));
        alpha = (IntensityList(find(fractionCumIntensity>=beginFraction,1)) - Range(1))/(Range(2) - Range(1));
        beta = (IntensityList(find(fractionCumIntensity>=1-beginFraction,1)) - Range(1))/(Range(2) - Range(1));
        
        [slopeSmall,slopeBig,coordinates]=AutoFindTransformParameters(alpha,beta,outputRatio);
        
		% Separating the three intensity ranges O(MN) into boolean matrices
        lowInten = doubleImageChannel <= alpha;
		midInten = doubleImageChannel > alpha & doubleImageChannel <= beta;
		highInten = doubleImageChannel > beta;
		
        doubleImageChannel(lowInten) = doubleImageChannel(lowInten)*slopeSmall;
        doubleImageChannel(midInten) = coordinates(1).y + (doubleImageChannel(midInten) - coordinates(1).x)*slopeBig;
        doubleImageChannel(highInten) = coordinates(2).y + (doubleImageChannel(highInten) - coordinates(2).x)*slopeSmall;
        
        contrastStretchedImage(:,:,i)= doubleImageChannel*(Range(2) - Range(1)) + Range(1);
    end
   contrastStretchedImage=squeeze(contrastStretchedImage) ;
end