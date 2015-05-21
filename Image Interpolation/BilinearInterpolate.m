%% BILINEARINTERPOLATE(ImageMat, NRowsScale, NColsScale)
% Performs enlargement of the image stored in the matrix ImageMat by
% using Bilinear Interpolation.
% 
% Bilinear Interpolation is here implemented using the idea that it is
% basically a convolution of a delta pulse train with a triangular
% impulse response that is 1 at the centre and goes to zero near the
% adjacent pixel of the original image.
% 
% The Covolution computation is not done using the generalized convolution
% algorithm and instead is done specially keeping in mind the special
% nature of the signals convolved in order to get an implementastion that
% works in O(NM) where N,M are dimensions of the final image
% 
% Detailed explanation goes here

function [ ImageMatOut ] = BilinearInterpolate(ImageMat, NRowsScale, NColsScale)

NRowsInitial = size(ImageMat, 1);
NColsInitial = size(ImageMat, 2);

NRowsFinal = ceil(1 + (NRowsInitial - 1)*NRowsScale);
NColsFinal = ceil(1 + (NColsInitial-1)*NColsScale);
NChannels = size(ImageMat, 3);

% To adjust the values of the scaling factor such that
% 
%    NRowsFinal = 1 + (NRowsInitial - 1)*NRowsScale AND
%    NColsFinal = 1 + (NColsInitial - 1)*NColsScale

NRowsScale = (NRowsFinal - 1)/(NRowsInitial - 1);
NColsScale = (NColsFinal - 1)/(NColsInitial - 1);

ImageMatOut = zeros(NRowsFinal, NColsFinal, NChannels); % Final Image Matrix Initialized

% Creating Row and Column index Meshgrid Matrices. Useful later for array
% indexing
ColsInds = 1:NColsFinal;
RowsInds = 1:NRowsFinal;


% LeftColInds: LeftColInds(i) = The Index of the first Column in ImageMat
%			   which is to the Left (or Equal) to the column i in Final
%			   Image.
% RightColInds: RightColInds(i) = The Index of the first Column in ImageMat
%			   which is to the Right (or Equal) to the column i in Final
%			   Image.
% UpRowInds: UpRowInds(i) = The Index of the first Row in ImageMat
%			   which is to the Top (has lesser index) (or Equal) to the row 
%			   i in Final Image.
% DownRowInds: UpRowInds(i) = The Index of the first Row in ImageMat
%			   which is Below (has greater index) (or Equal) to the row 
%			   i in Final Image.

LeftColInds = floor((0:NColsFinal-1)/NColsScale) + 1;
RightColInds = ceil((0:NColsFinal-1)/NColsScale) + 1;
UpRowInds = floor((0:NRowsFinal-1)/NRowsScale) + 1;
DownRowInds = ceil((0:NRowsFinal-1)/NRowsScale) + 1;

% Performing the convolution by splitting the impulse response from 0 to
% Peak (excluding Peak) and from Peak to 0 (excluding 0). 

% Note that the general convolution algorithm is suboptimal in this case
% due to the delta nature of ImageMatOut and the Space bounded nature of
% the triangle windows. (the time below takes O(NRowsFinal x NColsFinal) as
% opposed to O(NRowsFinal x NColsFinal x log(NColsScale) x log(NRowsScale))

% Also, the interpolation is done one channel at a time for colored images

for i = 1:NChannels
	% This Step performs the interpolation across all the columns in
	% ImageMat i.e. horizontal interpolation and stores the result in
	% ImageTemp which is a NRowsInitial x NColsFinal matrix
	ImageTemp = ones(NRowsInitial,1)*(1 - mod(ColsInds-1, NColsScale)/NColsScale) ...
											.*double(ImageMat(:, LeftColInds, i)) ...
			  + ones(NRowsInitial,1)*(mod(ColsInds-1, NColsScale)/NColsScale)...
											.*double(ImageMat(:, RightColInds, i));

	% This step now performs Interpolation across the rows of ImageTemp.
	ImageMatOut(:,:, i) ...
				= (1 - mod(RowsInds - 1, NRowsScale)/NRowsScale)'*ones(1, NColsFinal) ...
										.*ImageTemp(UpRowInds, :) ...
				+ (mod(RowsInds - 1, NRowsScale)/NRowsScale)'*ones(1, NColsFinal) ...
										.*ImageTemp(DownRowInds, :);
end
ImageMatOut = squeeze(ImageMatOut);

end