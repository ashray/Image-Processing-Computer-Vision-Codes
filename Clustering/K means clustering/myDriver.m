%% Image segmentation
%
%%
tic
clear all
close all
%% Image 1
%
Im1 = imread('flower.png');
imshow(Im1);
Im1 = double(Im1);
[m,n,~] = size(Im1);

red1 = Im1(:,:,1);
green1 = Im1(:,:,2);
blue1 = Im1(:,:,3);
NewImage = zeros(size(Im1));

%%
%
for i=1:m
    for j=1:n
     XiMat{i,j} = [i;j;red1(i,j);green1(i,j);blue1(i,j)];   
    end
end

win = 23;
d = (win-1)/2;
spatial_sigma = 12;
intensity_sigma = 20;
h = waitbar(0,'Filtering flower image...');
set(h,'Name','Mean-shift filtering progress');
for i=1:m
    for j=1:n
        X = [i;j;red1(i,j);green1(i,j);blue1(i,j)];     
        XiWin = XiMat( max(1,i-d):min(m,i+d) , max(1,j-d):min(n,j+d));
        new_X = mean_shift_imagesmooth(X, XiWin, spatial_sigma, intensity_sigma);
        NewImage(i,j,1)=new_X(3);
        NewImage(i,j,2)=new_X(4);
        NewImage(i,j,3)=new_X(5);
    end
    waitbar(i/m);
end
close(h);
out1 = NewImage/255;
figure('Name', 'New Image Flower')
imshow(out1);
title('Smoothed Image')

for i=1:m
    for j=1:n
     X1Mat{i,j} = [i;j;NewImage(i,j,1);NewImage(i,j,2);NewImage(i,j,3)];   
    end
end

%% Image 2
%
Im2 = imread('parrot.png');
figure, imshow(Im2);
Im2 = double(Im2);
[p,q,~] = size(Im2);

red2 = Im2(:,:,1);
green2 = Im2(:,:,2);
blue2 = Im2(:,:,3);
NewImage = zeros(size(Im2));

%%
%
for i=1:p
    for j=1:q
     XiMat{i,j} = [i;j;red2(i,j);green2(i,j);blue2(i,j)];   
    end
end

win = 23;
d = (win-1)/2;
spatial_sigma = 12;
intensity_sigma = 20;
h = waitbar(0,'Filtering parrot image...');
set(h,'Name','Mean-shift filtering progress');
for i=1:p
    for j=1:q
        X = [i;j;red2(i,j);green2(i,j);blue2(i,j)];     
        XiWin = XiMat( max(1,i-d):min(p,i+d) , max(1,j-d):min(q,j+d));
        new_X = mean_shift_imagesmooth(X, XiWin, spatial_sigma, intensity_sigma);
        NewImage(i,j,1)=new_X(3);
        NewImage(i,j,2)=new_X(4);
        NewImage(i,j,3)=new_X(5);
    end
    waitbar(i/p);
end
close(h);
out2 = NewImage/255;
figure('Name', 'New Image parrot')
imshow(out2);
title('Smoothed Image')

for i=1:p
    for j=1:q
     X2Mat{i,j} = [i;j;NewImage(i,j,1);NewImage(i,j,2);NewImage(i,j,3)];   
    end
end

%% The mean-shift filter
% 'mean_shift_imagesmooth' function definition:

%%
% 
%   function out = mean_shift_imagesmooth(input_pixel_vector, input_matrix, spatial_sigma, intensity_sigma)
%   error=inf;
%   temp1 = input_pixel_vector;
%   [nrows, ncols] = size(input_matrix);
%   N = nrows*ncols;
%   points_matrix=zeros(2,N);
%   intensity_matrix = zeros(3, N);
%   X_values = zeros(5, N);
%   loop_iterator = 0;
%     for i = 1:nrows
%         for j = 1:ncols
%             loop_iterator = loop_iterator + 1;
%             temp2 = input_matrix{i,j};
%             points_matrix(:, loop_iterator)=temp2(1:2);
%             intensity_matrix(:, loop_iterator) = temp2(3:5);
%             X_values(:, loop_iterator) = temp2;
%         end
%     end
%     out = temp1;
%   while error>0.001
%       old_out = out;
%       repeated_coordinates = repmat(out(1:2), 1, N);
%       repeated_intensity = repmat(out(3:5), 1 ,N);
%       weight1 = -1*sum((points_matrix - repeated_coordinates).*(points_matrix - repeated_coordinates),1)/(2*spatial_sigma*spatial_sigma);
%       weight2 = -1*sum((intensity_matrix - repeated_intensity).*(intensity_matrix - repeated_intensity),1)/(2*intensity_sigma*intensity_sigma);
%       numerator = X_values*(exp(weight1).*exp(weight2))';
%       denominator = exp(weight1)*exp(weight2)';
%       out = numerator./denominator;
%       error = norm(old_out - out);
%   end
%   end
% 


%% K-means applied on filtered images
%
K = 100;
xi = unidrnd(n,[1,K]);
yi = unidrnd(m,[1,K]);
r = unidrnd(255,[1,K]);
g = unidrnd(255,[1,K]);
b = unidrnd(255,[1,K]);
centroids = [xi;yi;r;g;b];

%%
% Applying K-means on filtered image of flower
out3 = compute_Kmeans(centroids,X1Mat,K);
figure('Name', 'Clustered Image flower')
out3 = out3/255;
imshow(out3);
title('Segmented Image')

%%
%
xi = unidrnd(q,[1,K]);
yi = unidrnd(p,[1,K]);
r = unidrnd(255,[1,K]);
g = unidrnd(255,[1,K]);
b = unidrnd(255,[1,K]);
centroids = [xi;yi;r;g;b];

%%
% Applying K-means on filtered image of parrot
out4 = compute_Kmeans(centroids,X2Mat,K);
out4 = out4/255;
figure('Name', 'Clustered Image parrot')
imshow(out4);
title('Segmented Image')

%% The K-means computing function
% 'compute_Kmeans' function definition:

%%
% 
%   function out = compute_Kmeans(centroid,XiMat,K)
%     [nrows,ncols] = size(XiMat);
%     labelMat = zeros(nrows,ncols);
%     new_centroid = centroid;
%     old_centroid = inf;
%     h = waitbar(0,'K-means');
%     set(h,'Name','K-means progress');
%     while norm(old_centroid - new_centroid)>0.01
%         for i=1:nrows
%             for j=1:ncols
%                 cell = XiMat{i,j};
%                 repeat = repmat(cell,1,K);
%                 error = sum((centroid-repeat).*(centroid-repeat));
%                 [~,ind] = min(error);
%                 labelMat(i,j) = ind;
%             end
%             waitbar(i/nrows);
%         end
%         old_centroid = new_centroid;
%         for label=1:K
%             bool = (labelMat==label);
%             if sum(sum(bool))==0
%                 continue;
%             else
%                 qicells = XiMat(bool);
%                 qiMat = zeros(5,length(qicells));
%                 for i=1:length(qicells)
%                     qiMat(:,i) = qicells{i,1};
%                 end
%                 new_centroid(:,label) = sum(qiMat,2)/sum(sum(bool));
%             end
%         end
%     end
%     close(h);
%     out = ones(nrows,ncols,3);
%     for label=1:K
%         bool = (labelMat==label);
%         r = new_centroid(3,label);
%         g = new_centroid(4,label);
%         b = new_centroid(5,label);
%             for i=1:nrows
%                 for j=1:ncols
%                     if bool(i,j) == 1
%                         out(i,j,1) = r;
%                         out(i,j,2) = g;
%                         out(i,j,3) = b;
%                     end
%                 end
%             end 
%     end
%     end
% 

%%
toc


