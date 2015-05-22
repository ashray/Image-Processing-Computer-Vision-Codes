tic
clear all
close all

N_images = 60000;
k = 250;
eigenspace_count = 10;
breadth = 784;
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');

% mask = -1*ones(eigenspace_count,1);
% image_category = -1*ones(eigenspace_count,1);
% for i=1:eigenspace_count
% imageArray(i) = -1*ones(1, breadth);
% end
% alpha(:, :, eigenspace_count) = zeros(:,:,10);

for i=1:eigenspace_count;
    V_array{i} = [];
%   alpha{i}=[];
    Xmean{i}=[];
end

for i=0:eigenspace_count-1
    mask = labels==i;
    images_temp = images(:, mask);      % Take only the images 
                                        % corresponding to a particular
                                        % digit
    Xmean{i+1} = mean(images_temp,2);
    image_count = size(images_temp, 2);
    Xmeanmatrix = repmat(Xmean{i+1},1,image_count);    
    images_bar = images_temp - Xmeanmatrix;
    Cov = (images_bar * images_bar')/(image_count-1);
    [V, D] = eigs(Cov,k);
    V = normc(V);
    V_array{i+1}=V;
%   Alpha matrix stores the components for each of the gallery images
%   alpha{i+1} = V.' * images_bar;
%   mask(i) = labels==i;
%   image_category(i) = images(:, mask(i));
end

% load test images
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

[~,testsize]=size(images_test);
recognised_digit = -1*ones(testsize, 1);

for i=1:testsize
    min_diff_norm_global = inf;
    for j = 1:eigenspace_count
        alpha_test = V_array{j}.' * (images_test(:,i)-Xmean{j});
        reconstructed = V_array{j}*alpha_test + Xmean{j};
        squared_error = sum( (reconstructed - images_test(:,i)).*(reconstructed - images_test(:,i)) );
        if squared_error < min_diff_norm_global
            min_diff_norm_global = squared_error;
            recognised_digit(i) = j-1;
        end
    end
end

% recognized_digit = labels(minlocation);
numcorrect = sum(recognised_digit == labels_test);
percentageaccuracy = (numcorrect/testsize)*100;
toc