%% Q1 CS663 Assignment 2-Image sharpening
% We will be using unsharp masking for this particular purpose
%% Code explanation
% filter the image with gaussian, invert it, scale it and add to original
% image
% normalise the resulting image
% no need to separate the gaussian filter and convolve because imfilter
% tests for separability in case of 2 dimensional filter
%% 
function [sharpenedImage]=Q1(inputImage,varargin)    
    DisplayImage(inputImage);

    standardDeviation=[0.001 0.5 3 9 15 25 40];
    filterSize=25;
    scalingRatio=[0.001 0.01 0.1 0.2 0.5];
    
    if nargin>=2 && strcmp(cell2mat(varargin{1}),'experiment')
        
    else        
        blurredImage=imfilter(inputImage,fspecial('gaussian',filterSize,standardDeviation(5)),'conv');        
        DisplayImage(blurredImage);                       
        sharpenedImage=(1-blurredImage)*scalingRatio(5)+inputImage;
                        
        sharpenedImage=normalise(sharpenedImage,1);
                
        DisplayImage(sharpenedImage);
    end    
end