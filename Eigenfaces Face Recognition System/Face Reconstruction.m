%%Reconstruction of the first face s1/1.pgm the ORL face database
% We perform the reconstruction of the 1st face in the ORL database using
% different number of eigenfaces. We observe that as we increase k, we get
% finer/high frequency details in our faces to be visible. Also the images
% for k=150 & 175 are virtually indistinguishable
% Regarding the eigenfaces and their fourier magnitude plots, we observe
% that the larger eigenvalue eigenfaces have low frequencies as their
% dominant frequencies(we see the bold vertical and horizontal lines in the 
% centre), and as we go to lower eigenvalues (from LEFT to RIGHT, TOP to 
% BOTTOM), higher frequency components become more prominent.

clear all
close all
X_original=zeros(10304,175);
Xmean=zeros(10304,1);

for i=1:35
    a=strcat('s',num2str(i));
    a=strcat(a,'/');
    for j=1:5
        b=strcat(a,num2str(j));
        b=strcat(b,'.pgm');
        y=imread(b);
        y=double(y);
        X_original(:,(5*(i-1)+j))=y(:); %Read the image vectors into the columns of this matrix
        c=y(:);
        Xmean=Xmean+c;
    end
end

Xmean = Xmean/175;
Xmeanmatrix = repmat(Xmean,1,175);

X_meansubtracted = X_original - Xmeanmatrix; %Subtract mean from each of the image vectors

L = X_meansubtracted.' * X_meansubtracted;
k_values = [2; 10; 20; 50; 75; 100; 125; 150; 175];
figure;
for index=1:9
    k=k_values(index);
    [V_intermediate,D]=eigs(L,k);
    V = X_meansubtracted * V_intermediate;
    V = normc(V);         %We now have the normalised eigenspace of the covariance matrix.
    alpha = V.' * X_meansubtracted(:,1); %alpha matrix stores the components for the 1st face
    out = V*alpha;
    out = reshape(out,112,92);
    out=uint8(out);
    subplot(3,3,index);
    imshow(out);
end

%We now plot the eigenfaces for k=25
[V_intermediate,D]=eigs(L,25);
V = X_meansubtracted * V_intermediate;
figure;

for i=1:25
    subplot(5,5,i);
    imshow(reshape(uint8(V(:,i)+Xmean),112,92));
end


figure;
for i=1:25
    subplot(5,5,i);
    U=fft2(reshape(uint8(V(:,i)+Xmean),112,92));
    U=fftshift(U);
    U=abs(U);
    U=log(1+U);
    U=mat2gray(U);
    imshow(U);
end