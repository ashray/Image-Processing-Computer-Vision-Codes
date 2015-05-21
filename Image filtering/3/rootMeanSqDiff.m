%% Root mean Square difference

%%
function [rmsd]=rootMeanSqDiff(mat1,mat2)
    rmsd=sqrt(sum(sum((mat1-mat2).*(mat1-mat2)))/numel(mat1));
end