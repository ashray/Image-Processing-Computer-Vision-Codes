%% ImageShrinking(ImageMat, RowShrinkFactor, ColShrinkFactor)
% Variants:
% 
%    ImageMatOut = ImageShrinking(ImageMat, RowShrinkFactor, ColShrinkFactor)
%    ImageMatOut = ImageShrinking(ImageMat, ShrinkFactor)
% 
% Shrinks the image given in ImageMat by the factor specified in RowShrinkFactor
% , ColShrinkFactor. if only one argument is specified (i.e. ShrinkFactor),
% the both dimentions are shrunk by the same amount
% 
% ImageMat - Image (B&W or Color)
% RowShrinkFactor (ShrinkFactor) - Scalar Integer
% ColShrinkFactor - Scalar Integer
% 

function [ImageMatOut]=ImageShrinking(ImageMat, RowShrinkFactor, ColShrinkFactor)

if nargin < 3
	ColShrinkFactor = RowShrinkFactor;
end

origDim = size(ImageMat);
ImageMatOut = ImageMat(1:RowShrinkFactor:origDim(1),1:ColShrinkFactor:origDim(2),:);
ImageMatOut = squeeze(ImageMatOut);

end