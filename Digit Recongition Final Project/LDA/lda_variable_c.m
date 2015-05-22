tic
clear all
close all

percentageaccuracy = zeros(1, 10);
for c = 2:10
images = loadMNISTImages('train-images.idx3-ubyte');
% images = 1e3*images;
images_filter = (images<0.05);
images(images_filter) = 0.01*rand(size(images(images_filter),1), 1);
labels = loadMNISTLabels('train-labels.idx1-ubyte');

[image_size, N_images] = size(images);
% For us x matrix is the images matrix(input data matrix)
%
% Now we need the w matrix(projection matrix)
%
% w matrix has the top c-1 eigenvectors of (Sw(inverse)*Sb), where each
% eigenvector is a column

% Calculating Sb
% ---------Parallelise this code---------------
mean_matrix = zeros(image_size, c);
size_vector = zeros(1, c);
for i=1:c
    selection_images_mask = labels==(i-1);
    selected_images = images(:, selection_images_mask);
    size_vector(1,i) = size(selected_images, 2);
    mean_matrix(:, i) = mean(selected_images, 2);
end
% Note the first column stores the index of decimal digit 0 and so on

Sw = 0;
for i=1:c
    selection_images_mask = labels==(i-1);
    selected_images = images(:, selection_images_mask);    
    mean_matrix_subtraction = repmat(mean_matrix(:, i), 1, size(selected_images, 2));
    Sw = Sw + (selected_images - mean_matrix_subtraction)*(selected_images - mean_matrix_subtraction)';
end

% Sb = 0;
Xmean = mean(images,2);
% Xmean_replicated = repmat(Xmean, c);
% Sb = (Xmean - Xmean_replicated)*(Xmean - Xmean_replicated)';
Sb = 0;
for i=1:c
    Sb = Sb + size_vector(i)*(mean_matrix(:,i)-Xmean)*(mean_matrix(:,i)-Xmean)';
end

% Nowe we have calculated Sw and Sb. w matrix has the top c-1 eigenvectors
% of (Sw(inverse)*Sb), where each eigenvector is a column
[V, d] = eigs(Sw\Sb, c-1);

% In Y we store the 9 coefficients of each image
alpha = V'*images;


%load test images
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

[~,testsize]=size(images_test);

minlocation=-1*ones(testsize,1);
for i=1:testsize
    alpha_test = V.' * images_test(:,i);
    rep_alpha_test = repmat(alpha_test,1,N_images);
    diff_matrix = alpha - rep_alpha_test;
    diff_norm = diff_matrix .* diff_matrix;
    diff_norm = sum(diff_norm);
    [~,minlocation(i)]=find(diff_norm==min(diff_norm));
end

recognized_digit = labels(minlocation);
numcorrect = sum(recognized_digit == labels_test);
percentageaccuracy(1,c) = numcorrect/testsize*100;
end
toc


