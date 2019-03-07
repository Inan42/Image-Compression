function [I, DCT, rDCT, I2] = compressimageDCT( image_name, mask_id )
% Some code borrowed from http://www.mathworks.com/help/images/discrete-cosine-transform.html

% If mask_id is a mask, use it. Otherwise, call getmask
if length(mask_id) > 1
    mask = mask_id;
else
    mask = getmask(mask_id);
end

% Read image
I = imread(image_name);
I = im2double(I);

% Take bloc-wise DCT 
size = length(mask);
T = dctmtx(size);
dct_function = @(block) T * block.data * T';
DCT = blockproc(I,[size size],dct_function);

% Zero out values in the DCT matrix to make a reduced DCT
rDCT = blockproc(DCT,[size size],@(block) mask .* block.data);

% Compute the inverse DCT and return the compressed image data
idct_function = @(block) T' * block.data * T;
I2 = blockproc(rDCT,[size size],idct_function);

fprintf('The block size is %dx%d\n', size, size)
