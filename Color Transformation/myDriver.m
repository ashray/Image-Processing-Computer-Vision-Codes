%% Q2a Linear contrast stretching
names={'barbara.png';'TEM.png';'canyon.png'};
for i=1:length(names)
    ourIm=imread(cell2mat(names(i)));
    DisplayImage(ourIm);
    ourDispIm=DisplayImage(AutoLinearContrastStretch(ourIm));
    save(strrep(cell2mat(names(i)),'.png','.mat'),'ourDispIm');
end
%% Q2.b Histogram Equalization
% Calls the function HistogramEq(BarbaraImg, Range) with default range
% being 0-255 for integral image matrices. plots the resulting images

% Displaying barbara.png
BarbaraImg = imread('barbara.png');
BarbaraImgHEq = HistogramEq(BarbaraImg);

DisplayImage(uint8(BarbaraImg));
DisplayImage(uint8(BarbaraImgHEq));

%% Displaying TEM.jpg
TEMImg = imread('TEM.png');
TEMImgHEq = HistogramEq(TEMImg);

DisplayImage(uint8(TEMImg));
DisplayImage(uint8(TEMImgHEq));
%
%% Displaying canyon.png
CanyonImg = imread('canyon.png');
CanyonImgHEq = HistogramEq(CanyonImg);

DisplayImage(uint8(CanyonImg));
DisplayImage(uint8(CanyonImgHEq));

%% Q2.c and Q2.d Adaptive Histogram Equalization and CLAHE
BarbaraImg = imread('barbara.png');
BarbaraImgAHEq = AdaptiveHistEq(BarbaraImg, 50);

DisplayImage(uint8(BarbaraImg));
DisplayImage(uint8(BarbaraImgAHEq));
%%
TEMImg = imread('TEM.png');
TEMImgHE = HistogramEq(TEMImg);
TEMImgCLAHE = AdaptiveHistEq(TEMImg,30, 'CLAHEThresh', 0.02);
TEMImgAHE = AdaptiveHistEq(TEMImg, 75);
TEMImgCLAHEHE = HistogramEq(TEMImgCLAHE, [0 255], 256);
DisplayImage(uint8(TEMImgHE));
DisplayImage(uint8(TEMImgAHE));
DisplayImage(uint8(TEMImgCLAHE));
%% Observations
% Linear contrast stretching provided a great improvement over the original
% image. HistogramEqualisation seems to have acheived more or less the same
% output without the tuning of parameters. The only difference is that 
% Histogram Equalisation seems to have acheived a bit more contrast than
% Linear Contrast Stretching
%Adaptive Histogram Equalisation seems to have magnified the noise to a large extent.
% But that again is dependent on tunining the parameters. Contrast Limited
% Adaptive Histogram Equalisation seems to have acheived a far better
% output than all others.