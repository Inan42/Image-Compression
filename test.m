%I = imread('cameraman.tiff');
I = imread('boat.tiff');
%disp(I);
I = im2double(I);
%disp(I);

% decomposing the image using singular value decomposition
[U,S,V]=svd(I);

% Using different number of singular values (diagonal of S) to compress and
% reconstruct the image
err = [];
numSVals = [];
m = 256;
n = 256;
for n=5:5:300
    % store the singular values in a temporary var
    C = S;

    % discard the diagonal values not required for compression
    C(n+1:end,:)=0;
    C(:,n+1:end)=0;

    % Construct an Image using the selected singular values
    D=U*C*V';


    % display and compute error
    if n == 5 || n == 10 || n == 20 || n == 50 || n == 100 || n == 150 || n == 200 || n == 250 
    figure;
    buffer = sprintf('Image output using %d singular values', n);
    imshow(D);
    title(buffer);
    out_filename = strcat(strcat('svd', num2str(n)), '.jpg');
    imwrite(D, out_filename);
    end
    error=(norm(I-D,'fro'));


    % store vals for display
    err = [err; error];
    numSVals = [numSVals; n];
end
%disp(numSVals);
%disp(error);

% dislay the error graph
figure; 
title('Error in compression');
plot(numSVals, err);
grid on
xlabel('Number of Singular Values retained');
ylabel('Error between compress and original image');