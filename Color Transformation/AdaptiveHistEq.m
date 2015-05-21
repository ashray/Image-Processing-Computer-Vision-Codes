function [ ImageMatOut ] = AdaptiveHistEq(ImageMat, WindowSize, varargin)
%ADAPTIVEHISTEQ Summary of this function goes here
%   Detailed explanation goes here

if isinteger(ImageMat)
	nbins = double(max(255, max(max(max(ImageMat))))) + 1;
	Range = [0 nbins-1];
else
	Range = [0 1];
	nbins = 256;
end

ContrastLimitThresh = 1;
nParams = floor(length(varargin)/2);
for i = 1:nParams
	if strcmpi(varargin{2*i-1}, 'Range')
		Range = varargin{2*i};
	elseif strcmpi(varargin{2*i-1}, 'CLAHEThresh')
		ContrastLimitThresh = varargin{2*i};
	elseif strcmpi(varargin{2*i-1}, 'nbins')
		nbins = varargin{2*i};
	end
end

QuantizedImg = round((double(ImageMat) - Range(1))*(nbins-1)/(Range(2) - Range(1)));

NRows = size(QuantizedImg, 1);
NCols = size(QuantizedImg, 2);
NChannels = size(QuantizedImg, 3);

ImgTransposed = false;
if NRows > NCols
	QuantizedImg = QuantizedImg';
	Temp = NRows;
	NRows = NCols;
	NCols = Temp;
	ImgTransposed = true;
end

[ColIndMat, RowIndMat] = meshgrid(1:NCols, 1:NRows);

% NPix = width of windows ...
%	   .*height of windows
NPix = (min(ColIndMat + WindowSize - 1, NCols) - max(ColIndMat - WindowSize + 1, 1) + 1) ...
	.* (min(RowIndMat + WindowSize - 1, NRows) - max(RowIndMat - WindowSize + 1, 1) + 1);

% For each pixel store contrast limit in terms of number of pixels allowed
if ContrastLimitThresh < 1
	CThreshCount = NPix*ContrastLimitThresh;
end

% CumulativeCount stores the number of pixels with intensity <= current
% pixel
% CurrentRowDiffPdf stores the 

CumulativeCount = zeros(size(QuantizedImg));
CurrentRowDiffPdf = zeros(nbins, NCols);

for j = 1:NChannels
for i = 1:NRows
	if i == 1	% Initializing the pdf difference arrays for the first row
		CurrentRowEachColPdf = hist(QuantizedImg(max(i - WindowSize + 1, 1):min(i + WindowSize - 1, NRows), :, j), 0:nbins-1);
		CurrentRowDiffPdf(:, 2:WindowSize) = CurrentRowEachColPdf(:, (2:WindowSize)+WindowSize-1);
		CurrentRowDiffPdf(:, end-WindowSize+2:end) = -CurrentRowEachColPdf(:, (end-WindowSize+2:end)-WindowSize);
		CurrentRowDiffPdf(:, WindowSize+1:end-WindowSize+1) ...
				= CurrentRowEachColPdf(:, (WindowSize+1:end-WindowSize+1)+WindowSize-1) ...
				  - CurrentRowEachColPdf(:, (WindowSize+1:end-WindowSize+1)- WindowSize);
		CurrentRowDiffPdf(:, 1) = sum(CurrentRowEachColPdf(:,1:WindowSize), 2);

	elseif i <= min(WindowSize, NRows - WindowSize + 1) % Calculating the pdf difference arrays for the Windows at the TOP
		LastWindRowHistInds = QuantizedImg(i+WindowSize-1,:, j)+1+(0:NCols-1)*nbins;
		CurrentRowDiffPdf(LastWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) ...
							= CurrentRowDiffPdf(LastWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) + 1;
		CurrentRowDiffPdf(LastWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) ...
							= CurrentRowDiffPdf(LastWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) - 1;
		CurrentRowDiffPdf(:, 1) = CurrentRowDiffPdf(:,1) + hist(QuantizedImg(i+WindowSize-1,1:WindowSize, j), 0:nbins-1)';
		
	elseif i <= NRows-WindowSize+1 % Calculating the pdf difference arrays for the MIDDLE Windows
		LastWindRowHistInds = QuantizedImg(i+WindowSize-1,:, j)+1+(0:NCols-1)*nbins;
		LastPrevWindRowHistInds = QuantizedImg(i-WindowSize,:, j)+1+(0:NCols-1)*nbins;
		
		CurrentRowDiffPdf(LastWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) ...
							= CurrentRowDiffPdf(LastWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) + 1;
		CurrentRowDiffPdf(LastWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) ...
							= CurrentRowDiffPdf(LastWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) - 1;
		
		CurrentRowDiffPdf(LastPrevWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) ...
							= CurrentRowDiffPdf(LastPrevWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) - 1;
		CurrentRowDiffPdf(LastPrevWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) ...
							= CurrentRowDiffPdf(LastPrevWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) + 1;
		
		CurrentRowDiffPdf(:, 1) = CurrentRowDiffPdf(:,1) + hist(QuantizedImg(i+WindowSize-1,1:WindowSize, j), 0:nbins-1)' ...
														 - hist(QuantizedImg(i-WindowSize,1:WindowSize, j), 0:nbins-1)';
	elseif i > WindowSize  % Calculating the pdf difference arrays for the Windows at the BOTTOM
		LastPrevWindRowHistInds = QuantizedImg(i-WindowSize,:, j)+1+(0:NCols-1)*nbins;
		CurrentRowDiffPdf(LastPrevWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) ...
							= CurrentRowDiffPdf(LastPrevWindRowHistInds(WindowSize+1:end) - (WindowSize-1)*nbins) - 1;
		CurrentRowDiffPdf(LastPrevWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) ...
							= CurrentRowDiffPdf(LastPrevWindRowHistInds(1:end-WindowSize) + WindowSize*nbins) + 1;

		CurrentRowDiffPdf(:, 1) = CurrentRowDiffPdf(:,1) - hist(QuantizedImg(i-WindowSize,1:WindowSize, j), 0:nbins-1)';
	end
	
	CurrentRowPdfCount = cumsum(CurrentRowDiffPdf, 2);
	
	% This is portion for contrast limiting
	if ContrastLimitThresh < 1
		ExcessValues = bsxfun(@minus, CurrentRowPdfCount, CThreshCount(i,:));
		ExcessInds = ExcessValues>0;
		CurrentRowPdfCount(ExcessInds) = CThreshCount(i, ceil(find(ExcessInds)/nbins));
		ExcessValues(~ExcessInds) = 0;
		
		PdfCountExcessSumPerInt = sum(ExcessValues)/nbins;
		CurrentRowPdfCount = bsxfun(@plus, PdfCountExcessSumPerInt, CurrentRowPdfCount);
	end
	
	CurrentRowCdf = cumsum(CurrentRowPdfCount);
	ReleventInds = QuantizedImg(i,:, j)+1 + (0:NCols-1)*256;

	CumulativeCount(i, :, j) = CurrentRowCdf(ReleventInds);
end
end
ImageMatOut = bsxfun(@rdivide,CumulativeCount*(Range(2) - Range(1)), NPix) + Range(1);

if ImgTransposed
	ImageMatOut = ImageMatOut';
end

end

