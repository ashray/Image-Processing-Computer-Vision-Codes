%% Runs questions 1 and generates the output

%%
addpath('../../export_fig-master/');

a=cell(1,2);
a{1}=load('../images/lionCrop.mat');
a{2}=load('../images/superMoonCrop.mat');

imageIn1=a{1}.imageOrig;
imageOut1=ImageSharpen(imageIn1,3,1);
imageIn2=a{2}.imageOrig;
imageOut2=ImageSharpen(imageIn2,5,4);

fig_orig1 = DisplayImage(imageIn1, 'Tag', 'export_fig_native');
fig_sharp1 = DisplayImage(imageOut1, 'Tag', 'export_fig_native');
fig_orig2 = DisplayImage(imageIn2, 'Tag', 'export_fig_native');
fig_sharp2 = DisplayImage(imageOut2, 'Tag', 'export_fig_native');

set([fig_orig1 fig_sharp1 fig_orig2 fig_sharp2], 'Color', 'w');

export_fig(fig_orig1, '../images/lionCrop_orig.png' ,'-q101', '-native', '-a1');
export_fig(fig_sharp1, '../images/lionCrop_sharp.png' ,'-q101', '-native', '-a1');
export_fig(fig_orig2, '../images/superMoonCrop_orig.png' ,'-q101', '-native', '-a1');
export_fig(fig_sharp2, '../images/superMoonCrop_sharp.png' ,'-q101', '-native', '-a1');

save('../images/Sharpening.mat', 'imageIn1', 'imageOut1', 'imageIn2', 'imageOut2');

%%
%close all;