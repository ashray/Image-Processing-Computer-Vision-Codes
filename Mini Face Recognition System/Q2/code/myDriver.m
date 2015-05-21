%% Q2 : For the ORL face database

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
k_values=[1; 2; 3; 5; 10; 20; 30; 50; 75; 100; 125; 150; 170];
Ncorrect=zeros(13,1);
Nfalse=zeros(13,1);
for index=1:13
    k=k_values(index);
    [V_intermediate,D]=eigs(L,k);
    V = X_meansubtracted * V_intermediate;
    V = normc(V);         %We now have the normalised eigenspace of the covariance matrix.
    alpha = V.' * X_meansubtracted; %alpha matrix stores the components for each of the gallery images
    for i=1:35
        a=strcat('s',num2str(i));
        a=strcat(a,'/');
        for j=6:10
            b=strcat(a,num2str(j));
            b=strcat(b,'.pgm');
            y=imread(b);
            y=double(y);
            y=y(:);
            y=y-Xmean;
            alpha_test = V.' * y; %Components of the test image
            %Now we find the gallery image with minimum norm difference in 
            %the principal components (alpha variables)
            match = 1;
            match = uint8(match);
            diff_vector = alpha_test - alpha(:,1);
            diff = norm(diff_vector);
            min = diff;
            for l=2:175
                diff_vector = alpha_test - alpha(:,l);
                diff = norm(diff_vector);
                if diff<min
                    match=l;
                    min=diff;
                end
            end
            if match>5*(i-1) && match<=5*i
                Ncorrect(index)=Ncorrect(index)+1;
            else
                Nfalse(index)=Nfalse(index)+1;
            end
        end
    end
end
%The vectors Ncorrect and Nfalse store the number of correct and false
%identifications for each of the 13 values of k.
RecognitionRate=zeros(13,1);
RecognitionRate=Ncorrect./175.*100;
RecognitionRate


%% Q2 : For the yale face database

clear all
close all
X_original=zeros(32256,76);
Xmean=zeros(32256,1);

for i=1:9
    a=strcat('0',num2str(i));
    a=strcat(a,'/');
    for j=1:2
        b=strcat(a,num2str(j));
        b=strcat(b,'.pgm');
        y=imread(b);
        y=double(y);
        X_original(:,(2*(i-1)+j))=y(:); %Read the image vectors into the columns of this matrix
        c=y(:);
        Xmean=Xmean+c;
    end
end

for i=10:13
    a=num2str(i);
    a=strcat(a,'/');
    for j=1:2
        b=strcat(a,num2str(j));
        b=strcat(b,'.pgm');
        y=imread(b);
        y=double(y);
        X_original(:,(2*(i-1)+j))=y(:); %Read the image vectors into the columns of this matrix
        c=y(:);
        Xmean=Xmean+c;
    end
end

for i=15:39
    a=num2str(i);
    a=strcat(a,'/');
    for j=1:2
        b=strcat(a,num2str(j));
        b=strcat(b,'.pgm');
        y=imread(b);
        y=double(y);
        X_original(:,(2*(i-2)+j))=y(:); %Read the image vectors into the columns of this matrix
        c=y(:);
        Xmean=Xmean+c;
    end
end


Xmean = Xmean/76;
Xmeanmatrix = repmat(Xmean,1,76);

X_meansubtracted = X_original - Xmeanmatrix; %Subtract mean from each of the image vectors

L = X_meansubtracted.' * X_meansubtracted;

k_values=[1; 2; 3; 5; 10; 20; 30; 50; 60; 65; 75];
Ncorrect=zeros(11,1);
Nfalse=zeros(11,1);
for index=1:11
    k=k_values(index);
    [V_intermediate,D]=eigs(L,k);
    V = X_meansubtracted * V_intermediate;
    V = normc(V);         %We now have the normalised eigenspace of the covariance matrix.
    alpha = V.' * X_meansubtracted; %alpha matrix stores the components for each of the gallery images
    for i=1:39
        if i==14 
            continue;
        end
        if i<=9
            a=strcat('0',num2str(i));
            a=strcat(a,'/');
        else
            a=num2str(i);
            a=strcat(a,'/');
        end
        for j=3:5
            b=strcat(a,num2str(j));
            b=strcat(b,'.pgm');
            y=imread(b);
            y=double(y);
            y=y(:);
            y=y-Xmean;
            alpha_test = V.' * y; %Components of the test image
            %Now we find the gallery image with minimum norm difference in 
            %the principal components (alpha variables)
            match = 1;
            match = uint8(match);
            diff_vector = alpha_test - alpha(:,1);
            diff = norm(diff_vector);
            min = diff;
            for l=2:76
                diff_vector = alpha_test - alpha(:,l);
                diff = norm(diff_vector);
                if diff<min
                    match=l;
                    min=diff;
                end
            end
            if i<=13
                if match>2*(i-1) && match<=5*i
                    Ncorrect(index)=Ncorrect(index)+1;
                else
                    Nfalse(index)=Nfalse(index)+1;
                end
            else
                if match>2*(i-2) && match<=5*(i-1)
                    Ncorrect(index)=Ncorrect(index)+1;
                else
                    Nfalse(index)=Nfalse(index)+1;
                end
            end
        end
    end
end
%The vectors Ncorrect and Nfalse store the number of correct and false
%identifications for each of the 13 values of k.
RecognitionRate=zeros(11,1);
RecognitionRate=Ncorrect./114.*100;
RecognitionRate

