tic
clear all
close all

N_images = 60000;
k=250;
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

for i =1:10
    V_array{i} = [];
    alpha{i}=[];
end
for i=0:eigenspace_count-1
    mask = labels==i;
    images_temp = images(:, mask);
    Xmean = mean(images_temp,2);
    image_count = size(images_temp, 2);
    Xmeanmatrix = repmat(Xmean,1,image_count);    
%     iteration_array = 1:length;
    images_bar = images_temp - Xmeanmatrix;
    Cov = (images_bar * images_bar')/(image_count-1);
    [V, D] = eigs(Cov,k);
    
    V = normc(V);
    V_array{i+1}=V;
    % Alpha matrix stores the components for each of the gallery images
    alpha{i+1} = V.' * images_bar;
%     mask(i) = labels==i;
%     image_category(i) = images(:, mask(i));
end

%load test images
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

[~,testsize]=size(images_test);
minlocation=-1*ones(testsize,eigenspace_count);
recognised_digit = -1*ones(testsize, 1);
for i=1:testsize
    diff_norm_global = inf;
    for j = 1:eigenspace_count
        alpha_test = V_array{j}.' * (images_test(:,i)-Xmean);
        image_count = size(alpha{j}, 2);
        rep_alpha_test = repmat(alpha_test,1,image_count);
        diff_matrix = alpha{j} - rep_alpha_test;
        diff_norm = diff_matrix .* diff_matrix;
        diff_norm = sum(diff_norm);
        diff_norm = sqrt(diff_norm);
       % [~,minlocation(i, j)]=find(diff_norm==min(diff_norm));
        if(min(diff_norm) < diff_norm_global)
            recognised_digit(i) = j-1;
            diff_norm_global = min(diff_norm);
        end
%         if(mean(diff_norm) < diff_norm_global)
%             recognised_digit(i) = j-1;
%             diff_norm_global = mean(diff_norm);
%         end
    end
end

% recognized_digit = labels(minlocation);
numcorrect = sum(recognised_digit == labels_test);
percentageaccuracy = (numcorrect/testsize)*100;
toc