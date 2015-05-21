%% Q1.a Image Shrinking
% This cell imports the image circles_concentric.png, calls the function
% 
%  ImageShrinking(ImageMat, ShrinkFactor)
% 
% with:
% 
%  ImageMat = matrix of pixels from circles_concentric.png|
%  ShrinkFactor = 2 , 3
% 
% and plots the two images

CCImageOrig = imread('circles_concentric.png');
CCImage1by2 = ImageShrinking(CCImageOrig, 2);
CCImage1by3 = ImageShrinking(CCImageOrig, 3);

figorig1a = DisplayImage(uint8(CCImageOrig), 'Tag', 'export_fig_native');
fig1by2 = DisplayImage(uint8(CCImage1by2), 'Tag', 'export_fig_native');
fig1by3 = DisplayImage(uint8(CCImage1by3), 'Tag', 'export_fig_native');
set([figorig1a fig1by2 fig1by3], 'Color', 'w');

save('..\images\circles_concentric.mat', 'CCImageOrig','CCImage1by2','CCImage1by3');

export_fig(figorig1a, '..\images\circles_concentric_orig.png' ,'-q101', '-native', '-a1');
export_fig(fig1by2, '..\images\circles_concentric_1by2.png' ,'-q101', '-native', '-a1');
export_fig(fig1by3, '..\images\circles_concentric_1by3.png' ,'-q101', '-native', '-a1');

%% Q1.b Image Enlargement
% This cell imports the image barbaraSmall.png, calls the function
% 
%  BilinearInterpolate(ImageMat, NRowsScale, NColsScale)
% 
% with: 
%  NRowsScale = 3
%  NColsScale = 2
% 
% and plots the Enlarged and Original image

BarbaraImageOrig = imread('barbaraSmall.png');
BarbaraImageLargeBI = BilinearInterpolate(BarbaraImageOrig, 3, 2);

figorig1b = DisplayImage(BarbaraImageOrig, 'Tag', 'export_fig_native');
fig_Enl = DisplayImage(uint8(BarbaraImageLargeBI), 'Tag', 'export_fig_native');
set([figorig1b fig_Enl], 'Color', 'w');

export_fig(figorig1b, '..\images\barbaraSmall_orig.png' ,'-q101', '-native', '-a1');
export_fig(fig_Enl, '..\images\barbaraSmall_Enlarged_BI.png' ,'-q101', '-native', '-a1');


%% Q1.c Nearest Neighbor

BarbaraImageOrig = imread('barbaraSmall.png');
BarbaraImageLargeNN = NearestNeighbourInterpolate(BarbaraImageOrig, 3, 2);

figorig1b = DisplayImage(BarbaraImageOrig, 'Tag', 'export_fig_native');
fig_Enl = DisplayImage(uint8(BarbaraImageLargeNN), 'Tag', 'export_fig_native');
set([figorig1b fig_Enl], 'Color', 'w');

export_fig(figorig1b, '..\images\barbaraSmall_orig.png' ,'-q101', '-native', '-a1');
export_fig(fig_Enl, '..\images\barbaraSmall_Enlarged_NN.png' ,'-q101', '-native', '-a1');

%Final Variable Save
save('..\images\barbaraSmall.mat', 'BarbaraImageOrig', 'BarbaraImageLargeBI', 'BarbaraImageLargeNN');