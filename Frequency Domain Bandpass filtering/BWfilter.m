function H = BWfilter(n,D0,nrow,ncol)


u = -1:2/(ncol):1-2/(ncol);
v = -1:2/(nrow):1-2/(nrow);

D = zeros(nrow,ncol);

%%
% Below code is the algorithm, and below it is the vectorised
% implementation of it.
% 
% for i=1:ncol
%     for j=1:nrow
%         D(i,j) = u(i)^2 + v(j)^2;
%     end
% end
% 

vMatrix = repmat(v, [nrow, 1]);
uMatrix = repmat(u', [1, ncol]);
vMatrixSquare = vMatrix.*vMatrix;
uMatrixSquare = uMatrix.*uMatrix;
D = vMatrixSquare + uMatrixSquare;

H = 1./((1 + D./D0).^(2*n));

end