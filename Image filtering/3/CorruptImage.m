%% Corrupt the image with noise
% should we normalise the image after adding noise or not???
%%
function [imageOut]=CorruptImage(imageIn,percentageInten)    
    maxIntenOriginal=max(max(imageIn));
    imageOut=percentageInten*maxIntenOriginal*randn(size(imageIn))+imageIn;
end