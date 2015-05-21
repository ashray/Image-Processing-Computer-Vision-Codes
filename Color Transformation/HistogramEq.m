function [ ImageMatOut ] = HistogramEq(ImageMat, Range, nbins)
% HISTOGRAMEQ Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
	if isinteger(ImageMat)
		nbins = double(max(255, max(max(max(ImageMat))))) + 1;
		Range = [0 nbins-1];
	else
		Range = [0 1];
		nbins = 256;
	end
end

if isinteger(ImageMat)
	IntensityList = Range(1):Range(2);
else
	IntensityList = linspace(Range(1), Range(2), nbins);
end

NChannels = size(ImageMat, 3);
ImageMatOut = zeros(size(ImageMat));

Range = double(Range);

for i = 1:NChannels
	probmass = sum(hist(double(ImageMat(:,:,i)), double(IntensityList)), 2)/numel(ImageMat(:,:,i));
	amplitudemap = cumsum(probmass);

	QuantizedImg = round((double(ImageMat(:,:,i)) - Range(1))*(nbins-1)/(Range(2) - Range(1)) + 1);
	ImageMatOut(:,:, i) = amplitudemap(int16(QuantizedImg)).*double(Range(2) - Range(1)) + double(Range(1));
end

