%% Q2.a Linear Contrast Stretching

%%% Displaying barbara.png
BarbaraImg = imread('barbara.png');
BarbaraImgLCS = AutoLinearContrastStretch(BarbaraImg);

%%% Displaying TEM.png
TEMImg = imread('TEM.png');
TEMImgLCS = AutoLinearContrastStretch(TEMImg);

%%% Displaying canyon.png
CanyonImg = imread('canyon.png');
CanyonImgLCS = AutoLinearContrastStretch(CanyonImg);

%% Q2.b Histogram Equalization
% Calls the function HistogramEq(BarbaraImg, Range) with default range
% being 0-255 for integral image matrices. plots the resulting images

%%% Displaying barbara.png
BarbaraImg = imread('barbara.png');
BarbaraImgHE = HistogramEq(BarbaraImg);

%%% Displaying TEM.jpg
TEMImg = imread('TEM.png');
TEMImgHE = HistogramEq(TEMImg);

%%% Displaying canyon.png
CanyonImg = imread('canyon.png');
CanyonImgHE = HistogramEq(CanyonImg);

%% Q2.c Adaptive Histogram Equalization
% Calls the function AdaptiveHistEq(ImageMat, WindowSize) with default range
% being 0-255 for integral image matrices. plots the resulting images

BarbaraImg = imread('barbara.png');
BarbaraImgAHE = AdaptiveHistEq(BarbaraImg, 75);
BarbaraImgAHELargeWin = AdaptiveHistEq(BarbaraImg, 200);
BarbaraImgAHESmallWin = AdaptiveHistEq(BarbaraImg, 30);

TEMImg = imread('TEM.png');
TEMImgAHE = AdaptiveHistEq(TEMImg, 75);
TEMImgAHELargeWin = AdaptiveHistEq(TEMImg, 200);
TEMImgAHESmallWin = AdaptiveHistEq(TEMImg, 30);

CanyonImg = imread('canyon.png');
CanyonImgAHE = AdaptiveHistEq(CanyonImg, 75);
CanyonImgAHELargeWin = AdaptiveHistEq(CanyonImg, 200);
CanyonImgAHESmallWin = AdaptiveHistEq(CanyonImg, 30);


%% Q2.d Contrast Limited Adaptive Histogram Equalization.
% Calls the AdaptiveHistEq(ImageMat, WindowSize) with the 'CLAHEThresh'
% option specified to perform CLAHE

BarbaraImg = imread('barbara.png');
BarbaraImgCLAHE = AdaptiveHistEq(BarbaraImg, 30, 'CLAHEThresh', 0.02);
BarbaraImgCLAHELowerThresh = AdaptiveHistEq(BarbaraImg, 30, 'CLAHEThresh', 0.01);

TEMImg = imread('TEM.png');
TEMImgCLAHE = AdaptiveHistEq(TEMImg, 30, 'CLAHEThresh', 0.02);
TEMImgCLAHELowerThresh = AdaptiveHistEq(TEMImg, 30, 'CLAHEThresh', 0.01);

CanyonImg = imread('canyon.png');
CanyonImgCLAHE = AdaptiveHistEq(CanyonImg, 30, 'CLAHEThresh', 0.01);
CanyonImgCLAHELowerThresh = AdaptiveHistEq(CanyonImg, 30, 'CLAHEThresh', 0.005);

%% Creating The Plots
%% For barbara.png
fig_BarbaraImg = DisplayImage(BarbaraImg, 'Tag', 'export_fig_native');
fig_BarbaraImgLCS = DisplayImage(uint8(BarbaraImgLCS), 'Tag', 'export_fig_native');
fig_BarbaraImgHE = DisplayImage(uint8(BarbaraImgHE), 'Tag', 'export_fig_native');
fig_BarbaraImgAHE = DisplayImage(uint8(BarbaraImgAHE), 'Tag', 'export_fig_native');
fig_BarbaraImgAHELargeWin = DisplayImage(uint8(BarbaraImgAHELargeWin), 'Tag', 'export_fig_native');
fig_BarbaraImgAHESmallWin = DisplayImage(uint8(BarbaraImgAHESmallWin), 'Tag', 'export_fig_native');
fig_BarbaraImgCLAHE = DisplayImage(uint8(BarbaraImgCLAHE), 'Tag', 'export_fig_native');
fig_BarbaraImgCLAHELowerThresh = DisplayImage(uint8(BarbaraImgCLAHELowerThresh), 'Tag', 'export_fig_native');
set([fig_BarbaraImg, fig_BarbaraImgLCS, fig_BarbaraImgHE, ...
	fig_BarbaraImgAHE, ...
	fig_BarbaraImgAHELargeWin, fig_BarbaraImgAHESmallWin, ...
	fig_BarbaraImgCLAHE, fig_BarbaraImgCLAHELowerThresh], 'Color', 'w');

%% For Canyon.png
fig_CanyonImg = DisplayImage(CanyonImg, 'Tag', 'export_fig_native');
fig_CanyonImgLCS = DisplayImage(uint8(CanyonImgLCS), 'Tag', 'export_fig_native');
fig_CanyonImgHE = DisplayImage(uint8(CanyonImgHE), 'Tag', 'export_fig_native');
fig_CanyonImgAHE = DisplayImage(uint8(CanyonImgAHE), 'Tag', 'export_fig_native');
fig_CanyonImgAHELargeWin = DisplayImage(uint8(CanyonImgAHELargeWin), 'Tag', 'export_fig_native');
fig_CanyonImgAHESmallWin = DisplayImage(uint8(CanyonImgAHESmallWin), 'Tag', 'export_fig_native');
fig_CanyonImgCLAHE = DisplayImage(uint8(CanyonImgCLAHE), 'Tag', 'export_fig_native');
fig_CanyonImgCLAHELowerThresh = DisplayImage(uint8(CanyonImgCLAHELowerThresh), 'Tag', 'export_fig_native');
set([fig_CanyonImg, fig_CanyonImgLCS, fig_CanyonImgHE, ...
	fig_CanyonImgAHE, ...
	fig_CanyonImgAHELargeWin, fig_CanyonImgAHESmallWin, ...
	fig_CanyonImgCLAHE, fig_CanyonImgCLAHELowerThresh], 'Color', 'w');

%% For TEM.png
fig_TEMImg = DisplayImage(TEMImg, 'Tag', 'export_fig_native');
fig_TEMImgLCS = DisplayImage(uint8(TEMImgLCS), 'Tag', 'export_fig_native');
fig_TEMImgHE = DisplayImage(uint8(TEMImgHE), 'Tag', 'export_fig_native');
fig_TEMImgAHE = DisplayImage(uint8(TEMImgAHE), 'Tag', 'export_fig_native');
fig_TEMImgAHELargeWin = DisplayImage(uint8(TEMImgAHELargeWin), 'Tag', 'export_fig_native');
fig_TEMImgAHESmallWin = DisplayImage(uint8(TEMImgAHESmallWin), 'Tag', 'export_fig_native');
fig_TEMImgCLAHE = DisplayImage(uint8(TEMImgCLAHE), 'Tag', 'export_fig_native');
fig_TEMImgCLAHELowerThresh = DisplayImage(uint8(TEMImgCLAHELowerThresh), 'Tag', 'export_fig_native');
set([fig_TEMImg, fig_TEMImgLCS, fig_TEMImgHE, ...
	fig_TEMImgAHE, ...
	fig_TEMImgAHELargeWin, fig_TEMImgAHESmallWin, ...
	fig_TEMImgCLAHE, fig_TEMImgCLAHELowerThresh], 'Color', 'w');

%% Saving The Figures
%% Saving Figures of Barbara.png
export_fig(fig_BarbaraImg, '..\images\barbara\barbara.png','-q101', '-native', '-a1');
export_fig(fig_BarbaraImgLCS, '..\images\barbara\barbara_LCS.png','-q101', '-native', '-a1');
export_fig(fig_BarbaraImgHE, '..\images\barbara\barbara_HE.png','-q101', '-native', '-a1');
export_fig(fig_BarbaraImgAHE, '..\images\barbara\barbara_AHE.png','-q101', '-native', '-a1');
export_fig(fig_BarbaraImgAHELargeWin, '..\images\barbara\barbara_AHE_LargeWin.png' ,'-q101', '-native', '-a1');
export_fig(fig_BarbaraImgAHESmallWin, '..\images\barbara\barbara_AHE_SmallWin.png' ,'-q101', '-native', '-a1');
export_fig(fig_BarbaraImgCLAHE, '..\images\barbara\barbara_CLAHE.png','-q101', '-native', '-a1');
export_fig(fig_BarbaraImgCLAHELowerThresh, '..\images\barbara\barbara_CLAHE_LowerThresh.png' ,'-q101', '-native', '-a1');

%% Saving Figures of Canyon.png
export_fig(fig_CanyonImg, '..\images\canyon\canyon.png','-q101', '-native', '-a1');
export_fig(fig_CanyonImgLCS, '..\images\canyon\canyon_LCS.png','-q101', '-native', '-a1');
export_fig(fig_CanyonImgHE, '..\images\canyon\canyon_HE.png','-q101', '-native', '-a1');
export_fig(fig_CanyonImgAHE, '..\images\canyon\canyon_AHE.png','-q101', '-native', '-a1');
export_fig(fig_CanyonImgAHELargeWin, '..\images\canyon\canyon_AHE_LargeWin.png' ,'-q101', '-native', '-a1');
export_fig(fig_CanyonImgAHESmallWin, '..\images\canyon\canyon_AHE_SmallWin.png' ,'-q101', '-native', '-a1');
export_fig(fig_CanyonImgCLAHE, '..\images\canyon\canyon_CLAHE.png','-q101', '-native', '-a1');
export_fig(fig_CanyonImgCLAHELowerThresh, '..\images\canyon\canyon_CLAHE_LowerThresh.png' ,'-q101', '-native', '-a1');

%% Saving Figures of TEM.png
export_fig(fig_TEMImg, '..\images\TEM\TEM.png','-q101', '-native', '-a1');
export_fig(fig_TEMImgLCS, '..\images\TEM\TEM_LCS.png','-q101', '-native', '-a1');
export_fig(fig_TEMImgHE, '..\images\TEM\TEM_HE.png','-q101', '-native', '-a1');
export_fig(fig_TEMImgAHE, '..\images\TEM\TEM_AHE.png','-q101', '-native', '-a1');
export_fig(fig_TEMImgAHELargeWin, '..\images\TEM\TEM_AHE_LargeWin.png' ,'-q101', '-native', '-a1');
export_fig(fig_TEMImgAHESmallWin, '..\images\TEM\TEM_AHE_SmallWin.png' ,'-q101', '-native', '-a1');
export_fig(fig_TEMImgCLAHE, '..\images\TEM\TEM_CLAHE.png','-q101', '-native', '-a1');
export_fig(fig_TEMImgCLAHELowerThresh, '..\images\TEM\TEM_CLAHE_LowerThresh.png' ,'-q101', '-native', '-a1');

%% Export Variables
save('..\images\barbara\barbara.mat', 'BarbaraImg', ...
'BarbaraImgLCS', ...
'BarbaraImgHE', ...
'BarbaraImgAHE', ...
'BarbaraImgAHELargeWin', ...
'BarbaraImgAHESmallWin', ...
'BarbaraImgCLAHE', ...
'BarbaraImgCLAHELowerThresh');

save('..\images\TEM\TEM.mat', 'TEMImg', ...
'TEMImgLCS', ...
'TEMImgHE', ...
'TEMImgAHE', ...
'TEMImgAHELargeWin', ...
'TEMImgAHESmallWin', ...
'TEMImgCLAHE', ...
'TEMImgCLAHELowerThresh');

save('..\images\Carbara\Canyon.mat', 'CanyonImg', ...
'CanyonImgLCS', ...
'CanyonImgHE', ...
'CanyonImgAHE', ...
'CanyonImgAHELargeWin', ...
'CanyonImgAHESmallWin', ...
'CanyonImgCLAHE', ...
'CanyonImgCLAHELowerThresh');

%%
close all