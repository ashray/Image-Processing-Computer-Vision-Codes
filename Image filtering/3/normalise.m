%% Normalise-helping function to make code readability in Q2 better
% normalises the resulting image between 0 and 255

%% 
function [normalisedImage]=normalise(inputImage,maxValue)
    normalisedImage = inputImage*maxValue/max(max(inputImage));
end