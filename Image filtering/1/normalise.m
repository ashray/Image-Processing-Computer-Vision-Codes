%% Normalise-helping function to make code readability in Q2 better
% normalises the resulting image between 0 and maxValue
% the normalise functoin used in this example is specifically different
% from others. This function does contrast strecthing along with 
% normalisation. In the question it is specifically asked that we do linear
% contrast stretching for comparing

%% 
function [normalisedImage]=normalise(inputImage,maxValue)
    normalisedImage = inputImage*maxValue/(max(max(inputImage))-min(min(inputImage)));
end