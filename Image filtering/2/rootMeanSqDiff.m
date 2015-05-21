%% Root mean Square difference

%%
function [rmsd]=rootMeanSqDiff(mat1,mat2)
    rmsd=sqrt(sum(sum((mat1-mat2).^2))/numel(mat1));
end