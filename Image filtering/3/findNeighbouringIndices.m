%% Find the neighbouring indices
% just a helper function for PatchFilter
% If a window around a pixel in an image is constructed, the window may not
% lie entirely within the image. This function finds out the indices of the
% pixels in the image which lie inside the window.
% This function accepts the dimensions of the window and the image and
% gives out 2 vectors which indicate the neighbouring indices. Note that we
% can specify 2 separate vectors as output(and not an array of tuples) 
% since the neighbouring pixels are contiguous and not separated out.

% centerPixel = the main pixel around which we are calculating neighbouring
% pixels
% winSize = window size arounf the center pixel, window assumed to be of
% odd length
%%
function [rowNeighbours,colNeighbours]=findNeighbouringIndices(imSize,centerPixel,winSize)
    border=floor(winSize/2);
    rowNeighbours=max(centerPixel(1)-border,1):min(centerPixel(1)+border,imSize(1));
    colNeighbours=max(centerPixel(2)-border,1):min(centerPixel(2)+border,imSize(2));
end