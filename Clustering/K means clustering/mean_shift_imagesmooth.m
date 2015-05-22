function out = mean_shift_imagesmooth(input_pixel_vector, input_matrix, spatial_sigma, intensity_sigma)
error=inf;
temp1 = input_pixel_vector;
% input_coordinates = temp1(1:2);
% input_intensity = temp1(3:5);
[nrows, ncols] = size(input_matrix);
N = nrows*ncols;
points_matrix=zeros(2,N);
intensity_matrix = zeros(3, N);
X_values = zeros(5, N);

% repeated_coordinates = repmat(input_coordinates, 1, N);
% repeated_intensity = repmat(input_intensity, 1 ,N);

    loop_iterator = 0;
    for i = 1:nrows
        for j = 1:ncols
            loop_iterator = loop_iterator + 1;
            temp2 = input_matrix{i,j};
            points_matrix(:, loop_iterator)=temp2(1:2);
            intensity_matrix(:, loop_iterator) = temp2(3:5);
            X_values(:, loop_iterator) = temp2;
        end
    end
    out = temp1;
while error>0.001
    % --------------We dont know the location of the given point in the
    % matrix, so we are only updating the given point but not the
    % corresponding value in the matrix but it shouldnt cause for too much
    % error in the output since its just one vector!!--------------
    
    old_out = out;
    repeated_coordinates = repmat(out(1:2), 1, N);
    repeated_intensity = repmat(out(3:5), 1 ,N);
    weight1 = -1*sum((points_matrix - repeated_coordinates).*(points_matrix - repeated_coordinates),1)/(2*spatial_sigma*spatial_sigma);
    weight2 = -1*sum((intensity_matrix - repeated_intensity).*(intensity_matrix - repeated_intensity),1)/(2*intensity_sigma*intensity_sigma);
    numerator = X_values*(exp(weight1).*exp(weight2))';
    denominator = exp(weight1)*exp(weight2)';
    
    out = numerator./denominator;
    error = norm(old_out - out);
end
end


