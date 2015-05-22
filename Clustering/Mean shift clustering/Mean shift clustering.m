%% Q1
% We apply the mean shift algorithm for clustering
%%
tic
clear all
close all
clc

x1=0;
y1=0;
C1=[2,0; 0,2];
x2=5;
y2=5;
C2=[2,1;1,2];

N = 3000; %Number of points
sigma = 2;

points_matrix=zeros(2,N);
clustered_points_matrix=zeros(2,N);


for i=1:N
    p1 = mvnrnd([x1 y1],C1); % sample from 1st Gaussian
    p2 = mvnrnd([x2 y2],C2); % sample from 2nd Gaussian
    a = rand(1); % samples from a uniform random distribution
    if (a <= 0.4) 
        points_matrix(:,i) = p1'; 
    else points_matrix(:,i) = p2'; 
    end
end

figure;
scatter(points_matrix(1,:),points_matrix(2,:),'b');
title('Original points');

original_points_matrix = points_matrix;

iterations=0;
%%
%Waitbar
h = waitbar(0,'Clustering');
set(h,'Name','Clustering progress');
for i=1:N                    %For each point
%     old_point=points_matrix(:,i);
    error=inf;
    while error>0.001
        iterations=iterations+1;
%         repeated = repmat(old_point,1,N);
        repeated = repmat([points_matrix(1,i); points_matrix(2,i)], 1, N);
        
        weights = -1*sum((points_matrix - repeated).*(points_matrix - repeated),1)/(2*sigma*sigma);
        weights = exp(weights);
        sum_of_weights = sum(weights,2);
		
        old_point = points_matrix(:,i);
        
        points_matrix(1,i) = sum((weights .* points_matrix(1,:)),2)/sum_of_weights;
        points_matrix(2,i) = sum((weights .* points_matrix(2,:)),2)/sum_of_weights;
        error = norm(old_point - points_matrix(:,i));
    end
    clustered_points_matrix(:,i)=points_matrix(:,i);
    %---------- Shuld we update together or do it with every new calculated
    %vector. This isnt exactly gradient descent--------------
    points_matrix = original_points_matrix;
    waitbar(i/N);
end
close(h);
iterations = iterations/N;

%%
% In the below figure, the clustered points are in red(they look just like
% one point but they actually are multiple points clustered too close) and the
% original points are in blue.
figure;
% scatter(points_matrix(1,:),points_matrix(2,:),'b');
scatter(original_points_matrix(1,:),original_points_matrix(2,:),'b');
hold on
scatter(clustered_points_matrix(1,:),clustered_points_matrix(2,:),'r');
title('Original points: Blue, Clustered points : Red');
%%
disp(['Average number of iterations for convergence of each point = ' num2str(iterations)]);

toc