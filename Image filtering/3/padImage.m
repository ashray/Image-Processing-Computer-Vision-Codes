%% Zero pad image
% zero padding the image is useful in various border computation cases.
% This code currently pads the input image with a fixed width border. The
% code for a different size border for the width and the length of the
% image is not yet implemented. Ideally if such parameters are not
% metioned(in future code) then the code should automatically assume fixed
% size border for both
% imageSidePad=padding on the side of image
% convention for naming: variables and functions in camelcase, variables 
% start with lowercase and functions start with uppercase
%%
function [imageOut]=padImage(imageIn,border)
    heightImage=size(imageIn,1);
    widthImage=size(imageIn,2);
    
    imageSidePad=[zeros(heightImage,border) imageIn zeros(heightImage,border)];
    imageOut=[zeros(border,widthImage+2*border) ; imageSidePad ; zeros(border,widthImage+2*border)];
end