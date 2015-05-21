%% Runs question 2 and generates the output

%%
addpath('../../export_fig-master/');

image=load('../images/barbara.mat');
imageMat = image.imageOrig;
samplingFactor=3;

normInputImage=imageMat/100;
noisyImage = uint8((0.05*100*randn(size(imageMat))+imageMat)*255/100);

% %best parameters experiment to be uncommented for checking
% sigmaSpace=[3 4 6 9 12 15 20];
% sigmaIntensity=[6 10 14 18 22 26 30];
% bestRmsd=Inf;%bestRmsd observed is 37.67
% bestParameters=zeros(1,2);
bestParameters(1)=5;
bestParameters(2)=20;
% for sS=1:length(sigmaSpace)
%     for sI=1:length(sigmaIntensity)
%         filteredImage=BilateralFilter(single(noisyImage), sigmaSpace(sS), sigmaIntensity(sI), samplingFactor);
%         currentRmsd=rootMeanSqDiff(filteredImage,normInputImage);
%         if(currentRmsd<bestRmsd)
%             bestRmsd=currentRmsd;
%             bestParameters(:)=[sigmaSpace(sS), sigmaIntensity(sI)];
% 		end
% 		fprintf('Current RMSD = %f, finished entry %d\n', currentRmsd, (sS-1)*length(sigmaIntensity) + sI);
%     end
% end
 
% actual filtering
filteredImage = BilateralFilter(single(noisyImage), bestParameters(1), bestParameters(2), samplingFactor);
bestRmsd=rootMeanSqDiff(filteredImage,normInputImage);
disp(strcat('The best standard deviation for Space and Intensity are ',num2str(bestParameters(1)),' and ',num2str(bestParameters(2)),' respectively'));
disp(strcat('The optimum root mean square difference is ',num2str(bestRmsd)));

% figures saving
fig_orig = DisplayImage(normInputImage, 'Tag', 'export_fig_native');
fig_noise = DisplayImage(noisyImage, 'Tag', 'export_fig_native');
fig_filtered = DisplayImage(filteredImage, 'Tag', 'export_fig_native');

%for reporting Rmsd values
scaleDevia=[0.9 1; 1.1 1; 1 0.9; 1 1.1];
for cases=1:size(scaleDevia,1)    

	filteredImage=BilateralFilter(single(noisyImage), scaleDevia(cases,1)*bestParameters(1), scaleDevia(cases,2)*bestParameters(2), samplingFactor);
    experimentRmsd=rootMeanSqDiff(filteredImage,normInputImage);    
    disp(strcat('The rmsd for SigmaSpace=',num2str(scaleDevia(cases,1)), 'optimum and SigmaIntensity=',num2str(scaleDevia(cases,2)),'optimum is ',num2str(experimentRmsd)));
end

set([fig_orig fig_noise fig_filtered], 'Color', 'w');

export_fig(fig_orig, '../images/barbara_orig.png' ,'-q101', '-native', '-a1');
export_fig(fig_noise, '../images/barbara_noise.png' ,'-q101', '-native', '-a1');
export_fig(fig_filtered, '../images/barbara_bifilt.png' ,'-q101', '-native', '-a1');

save('../images/Bilateral.mat', 'normInputImage', 'noisyImage', 'filteredImage');
%%
%close all;