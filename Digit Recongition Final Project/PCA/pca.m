tic
clear all
close all

N_images = 60000;
k=100;

images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');

% [vertsize,~]=size(images(:,1));

Xmean = mean(images,2);
Xmeanmatrix = repmat(Xmean,1,N_images);

images_bar = images - Xmeanmatrix;
Cov = (images_bar * images_bar')/(N_images-1);
[V, D] = eigs(Cov,k);

V = normc(V);
% Alpha matrix stores the components for each of the gallery images
alpha = V.' * images_bar;

%load test images
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

[~,testsize]=size(images_test);
minlocation=-1*ones(testsize,1);
parfor i=1:testsize
    alpha_test = V.' * images_test(:,i);
    rep_alpha_test = repmat(alpha_test,1,N_images);
    diff_matrix = alpha - rep_alpha_test;
    diff_norm = diff_matrix .* diff_matrix;
    diff_norm = sum(diff_norm);
    [~,minlocation(i)]=find(diff_norm==min(diff_norm));
end

recognized_digit = labels(minlocation);
numcorrect = sum(recognized_digit == labels_test);
percentageaccuracy = numcorrect/testsize*100;
toc