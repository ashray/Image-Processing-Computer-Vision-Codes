function out = compute_Kmeans(centroid,XiMat,K)
% centroid is 5-d
[nrows,ncols] = size(XiMat);
labelMat = zeros(nrows,ncols);
new_centroid = centroid;
old_centroid = inf;

h = waitbar(0,'K-means');
set(h,'Name','K-means progress');

% while sum(old_centroid-new_centroid)>0.1
while norm(old_centroid - new_centroid)>0.01
    for i=1:nrows
        for j=1:ncols
            cell = XiMat{i,j};
            repeat = repmat(cell,1,K);
            error = sum((centroid-repeat).*(centroid-repeat));
            [~,ind] = min(error);
            labelMat(i,j) = ind;
        end
        waitbar(i/nrows);
    end
    old_centroid = new_centroid;
    % compute new centroid
    for label=1:K
        bool = (labelMat==label);
        if sum(sum(bool))==0
            continue;
        else
            qicells = XiMat(bool);
            qiMat = zeros(5,length(qicells));
            for i=1:length(qicells)
                qiMat(:,i) = qicells{i,1};
            end
            new_centroid(:,label) = sum(qiMat,2)/sum(sum(bool));
        end
    end
end
close(h);

% Reconstruction of image
out = ones(nrows,ncols,3);
%rgb = zeros(1,K);

for label=1:K
    bool = (labelMat==label);
%     same_cells = XiMat(bool);
%     
%     sameTuple = zeros(5,length(same_cells));
%     for i=1:length(same_cells)
%         sameTuple(:,i) = same_cells{i,1};
%     end
%     
%     if sum(sum(bool))==0
%         continue;
%     else 
%         avg_tuple = sum(sameTuple,2)/length(same_cells);
%         r = floor(avg_tuple(3));
%         g = floor(avg_tuple(4));
%         b = floor(avg_tuple(5));
    r = new_centroid(3,label);
    g = new_centroid(4,label);
    b = new_centroid(5,label);
        for i=1:nrows
            for j=1:ncols
                if bool(i,j) == 1
                    out(i,j,1) = r;
                    out(i,j,2) = g;
                    out(i,j,3) = b;
                end
            end
        end
%     end
    
end

end