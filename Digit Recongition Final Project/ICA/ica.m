tic
clear all
close all

images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');

% Since we want each row to be an image!!
images = images';
test_images_count = 13000;
[icasig, A, W] = fastica(images(1:test_images_count, :));


%load test images
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

[~,testsize]=size(images_test);
seperated_signal_inverse = pinv(icasig);

actual_digit = zeros(1, testsize);
predicted_digit = zeros(1, testsize);

for i = 1:testsize
    selected_test_image = images_test(:, i);
    selected_test_image = selected_test_image';
%     array_to_match = selected_test_image*pinv(icasig);
    array_to_match = selected_test_image*seperated_signal_inverse;
    F = repmat(array_to_match, test_images_count, 1);
    temp_sum = sum((A - F).*(A - F), 2);
    [X, Y] = min(temp_sum);
    predicted_digit(i) = labels(Y);
    actual_digit(i) = labels_test(i);
end

bool_count = actual_digit==predicted_digit;
percentage_accuracy = sum(bool_count)/testsize;
fprintf('The percentage accuracy of correct detection is %f \n', percentage_accuracy)
toc