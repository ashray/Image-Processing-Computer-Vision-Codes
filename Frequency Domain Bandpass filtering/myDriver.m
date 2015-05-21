%% Frequency Domain Filtering
%%
tic
clear all
close all
%%
% Getting the input image
load('../images/boat.mat');
[nrow, ncol] = size(imageOrig);
a = min(min(imageOrig));
b = max(max(imageOrig));
intensityLevels = b-a;

new = (imageOrig/b);
imshow(new),title('Original Image');
newRange = a/b:1/intensityLevels:1;
%%
% Since after normalisation the maximum intensity is 1 and the minimum
% intensity sould be a/b, we have the standard deviation as given below
stDeviation = 0.1*(1 - a/b);

noise = stDeviation.*randn(nrow,ncol);
noisyImage = new + noise;

figure, imshow(noisyImage),title('noisyImage');
Im = double(noisyImage);

%%
% After adding the noise, some pixels might have attained values greater
% than 1 or less than 0. We want to clip those values back to 1 or 0. Hence
% we create masks gt and lt and set the values of those pixels which come
% in this mask to 1 and 0 respectively.
gt = Im>1;
lt = Im<0;
Im(gt) = 1;
Im(lt) = 0;

%% Noisy Image
% We take the fft of the noisy image
X = fft2(Im);
X = fftshift(X);

%%
% We call the filter function with n=2, D0=0.8 To calculate this value of
% D0, we plotted the value of RMSD for different values of D0 and obtained
% the below graph. Since the minimum is at D0=0.8, we used that value.
%%
% 
% <<RMSDvsDgraph.jpg>>
% 
H = BWfilter(2,.8,nrow,ncol);

%% Butterworth Filter
% This is the code of the BWfilter.m file.
%%
% 
%   function H = BWfilter(n,D0,nrow,ncol)
% u = -1:2/(ncol):1-2/(ncol);
% v = -1:2/(nrow):1-2/(nrow);
% D = zeros(nrow,ncol);
% %%
% % Below code is the algorithm, and below it is the vectorised
% % implementation of it.
% % for i=1:ncol
% %     for j=1:nrow
% %         D(i,j) = u(i)^2 + v(j)^2;
% %     end
% % end
% vMatrix = repmat(v, [nrow, 1]);
% uMatrix = repmat(u', [1, ncol]);
% vMatrixSquare = vMatrix.*vMatrix;
% uMatrixSquare = uMatrix.*uMatrix;
% D = vMatrixSquare + uMatrixSquare;
% H = 1./((1 + D./D0).^(2*n));
% end
% 

%%
outf = H.*X;
outf = fftshift(outf);
out = ifft2(outf);

%% Filtered Image
% Find below the Filtered Image
figure, imshow(out);
title('Filtered Image')
colormap(gray(256));
daspect ([1 1 1]);
colorbar;

%% Frequency domain representation of filter
% Below is the frequency domain representation of the filter
figure, imshow(H);
colormap(gray(256));
daspect ([1 1 1]);
colorbar;
%%
figure, surf(H);

%%
% Below you can see the optimum value of RMSD for the best possible value
% of D0.
RMSD = sqrt(sum((new(:)-out(:)).^2)/nrow*ncol)

%% Images for side by side comparision
% All the images side by side for comparision
subplot(1,3,1), imshow(imageOrig/256), title('Original Image')
subplot(1,3,2), imshow(noisyImage), title('Noisy image')
subplot(1,3,3), imshow(out), title('Filtered Image')
colormap(gray(256));
daspect ([1 1 1]);
colorbar;

%% RMSD values for other values of D0
% RMSD value for D0= 0.75 is around 22.44. RMSD value for D0=0.85 is 22.46.
% The optimum value is D0 = 0.8, for which RMSD is minimum which is 22.4.
% Note that the RSMD can change relative to the range of D that we have
% taken. So say if we had considered D from -0.5 to 0.5 instead of -1 to 1,
% our min RSMD would have been around 11 instead of around 22 as in this
% case.

%%
% We are looking for the center pixel in H so that we can find the centre
% points of the mask. Centre pixel turns out to be (257, 257), which we
% expected since the butterworth filter is symmetric.

Hsquare = H.*H;
TotalEnergyOriginal = sum(Hsquare(:));
centreX = 257;
centreY = 257;
radius = 250;
width = 512;
height = 512;
[Y,X] = meshgrid(1:width,1:height);

%%
% To compute which values of Radius should be chosen to get the required
% values of energy we used the follwing code
%%
% radiusArray = 0;
% percentageEnergyArray = 0;
% for radius = 100:5:250
% mask = sqrt((Y-centreY).^2 + (X-centreX).^2) > radius;
% Hdash = H;
% Hdash(mask) = 0;
% Hsquare = Hdash.*Hdash;
% TotalEnergyModified = sum(Hsquare(:));
% PercentageEnergy = TotalEnergyModified/TotalEnergyOriginal*100;
% radiusArray = [radiusArray, radius];
% percentageEnergyArray = [percentageEnergyArray, PercentageEnergy];
% end
% plot(radiusArray(2:end), percentageEnergyArray(2:end));
% xlabel('Radius of the mask'), ylabel('Percentage of energy')
% 
%%
% 
% <<RadiusSelection.jpg>>
% 

%%
% From the graph, it is clear that for 88 percentage energy, we need radius
% to be around 136 pixels, for 91 around 146 pixels, for 94 we need 160
% pixels, for 97 we need 183 pixels and for 99 we need 216 pixels.
for radius = [136, 146, 160, 183, 216]
    mask = sqrt((Y-centreY).^2 + (X-centreX).^2) > radius;
    Hdash = H;
    Hdash(mask) = 0;

    outf = Hdash.*X;
    outf = fftshift(outf);
    out = ifft2(outf);
    disp('The value of radius is ');
    disp(radius);
    disp('For the previous mentioned value of radius, the RMSD is ');
    RMSD = abs(sqrt(sum((new(:)-out(:)).^2)/nrow*ncol));
    disp(RMSD);
end

toc
