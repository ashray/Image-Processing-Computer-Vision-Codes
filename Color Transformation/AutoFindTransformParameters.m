%% FindTransformParameters function
% this fucntion returns the parameters of the piecewise linear transform
% slopeSmall1=slope of the 1st piecewise function
% slopeBig=slope of the main middle part of linear transform(2nd piecewise fn)
% slopeSmall2=slope of the 3rd piecewise function
% coordinates=(x,y) for the first shoulder of the transform and (x,y) for
% the second shoulder of the transform, in an array
%% Code explanation
% outptuRatio=outputRatio is the fraction of the *output* intensities over
% which the contrast is stretched 
% for coordinates(1) we have a straight line starting at x=0 and
% terminating at x=alpha which is calculated earlier from histogram
% for coordinates(2) we have a straight line starting at x=beta
% and terminating at x=1
% this code doesn't handle the case when alpha=1
%%

function [slopeSmall,slopeBig,coordinates]=AutoFindTransformParameters(alpha,beta,outputRatio)
    slopeSmall=(1-outputRatio)/(1-(beta-alpha));
    slopeBig=outputRatio/(beta-alpha);
    
    coordinates(1).x=alpha;
    coordinates(1).y= slopeSmall*alpha;
    coordinates(2).x=beta;
    coordinates(2).y= 1 - slopeSmall*(1-beta);