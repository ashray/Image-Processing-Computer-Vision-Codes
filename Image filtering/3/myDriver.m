 %% Runs question 2 and generates the output
% normalise 
%%
%image=load('../images/barbara.mat');
%[imageOut,rmsd]=PatchFilter(image.imageOrig);
%for debugging
addpath('../../export_fig-master/');
clear 
ourimage=load('../images/barbara.mat');
imageRaw=ourimage.imageOrig;
%rng(25);
imageIn=CorruptImage(imageRaw/100,0.05);

% % For experimenting with various values of standard deviation of gaussian
% sigmas=0.0025:0.0005:0.0045;
% bestRmsd=Inf;
% bestSigma=0;
% for sigVal=sigmas
%     [imageOut] = PatchFilter(imageIn,  9, 4, 25, sigVal);
%     currentRmsd=sqrt(sumsqr(imageOut-imageRaw/100)/numel(imageOut));
%     if currentRmsd<bestRmsd
%         bestRmsd=currentRmsd;
%         bestSigma=sigVal;
%     end
% end
bestSigma=0.0045;

%for reporting 0.9 and 1.1 times stanadard deviation
% [imageOut] = PatchFilter(imageIn,  9, 4, 25, bestSigma*0.9);
% fprintf('Root Mean Square Difference = %f at sigma=0.9*OptimumSigma\n', rootMeanSqDiff(imageOut,imageRaw/100));
% [imageOut] = PatchFilter(imageIn,  9, 4, 25, bestSigma*1.1);
% fprintf('Root Mean Square Difference = %f at sigma=1.1*OptimumSigma\n', rootMeanSqDiff(imageOut,imageRaw/100));

tic;
[imageOut] = PatchFilter(imageIn,  9, 4, 25, bestSigma);
toc;
%WeightImage/max(max(WeightImage)
%fprintf('Root Mean Square Difference = %f\n', sqrt(sumsqr(imageOut-imageRaw/100)/numel(imageOut)));
fprintf('Root Mean Square Difference = %f\n', rootMeanSqDiff(imageOut,imageRaw/100));

% figures saving
fig_orig = DisplayImage(imageRaw/100, 'Tag', 'export_fig_native');
fig_noise = DisplayImage(imageIn, 'Tag', 'export_fig_native');
fig_filtered = DisplayImage(imageOut, 'Tag', 'export_fig_native');

set([fig_orig fig_noise fig_filtered], 'Color', 'w');

export_fig(fig_orig, '../images/barbara_orig.png' ,'-q101', '-native', '-a1');
export_fig(fig_noise, '../images/barbara_noise.png' ,'-q101', '-native', '-a1');
export_fig(fig_filtered, '../images/barbara_patchFilt.png' ,'-q101', '-native', '-a1');

save('../images/Patch.mat', 'imageRaw', 'imageIn', 'imageOut');
%%
%close all