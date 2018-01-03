%% function of preProcess
% Used to compress the dimension of image from 784 to 16.
% By extracting the part with digit and rescale the extracted part to 4x4.
% The reason for preprocess is to remove all blank pixels and and to reduce
% program running time.
% Input:
%       X: the image data to be processed
%       scale: the target scale to be compressed to, note that in this
%       function it has to be a square of an integer
% Output:
%       pic: the compressed image data
function pic = preProcess(X, scale)
train_size = size(X, 1);                                                    % number of images
pic_size = size(X, 2);                                                      % size of image
pic = zeros(train_size, scale);
% pic1 = zeros(train_size, scale);
length = sqrt(scale);                                                       % target size (length by length)

% X = im2bw(X, 0.5);
for i = 1:train_size
    temp = reshape(X(i, :), sqrt(pic_size), sqrt(pic_size));                % reshape image to 28x28
    row = sum(temp);
    left = min(find(row~=0));                                               % compute boundary of the digit 
    right = max(max(find(row~=0)), left+length);                            % compute boundary of the digit 
    col = sum(temp, 2);
    top = min(find(col~=0));                                                % compute boundary of the digit 
    down = max(max(find(col~=0)), top+length);                              % compute boundary of the digit 
    temp = temp(top:down, left:right);
    os_r = floor(size(temp, 1)/length);                                     % compute the compress size, a block of this size in origin image will be a pixel in compressed image
    os_c = floor(size(temp, 2)/length);                                     % compute the compress size, a block of this size in origin image will be a pixel in compressed image
    r_size = zeros(1, length+1);
    c_size = zeros(1, length+1);
    r_size(1) = 0;
    c_size(1) = 0;
    for j = 2:length
        r_size(j) = r_size(j-1) + os_r;
        c_size(j) = c_size(j-1) + os_c;
    end
    r_size(length+1) = r_size(length) + size(temp, 1) - (length-1)*os_r;
    c_size(length+1) = c_size(length) + size(temp, 2) - (length-1)*os_c;

    for j = 1:length
        for k = 1:length
            pic(i, (j-1)*length+k) = mean(mean(temp(r_size(k)+1:r_size(k+1), c_size(j)+1:c_size(j+1))));    % compute the mean value of the unit as the value of one pixel in the compressed image
        end
    end
%     pic1(i, :) = [sum(sum(temp(1:os_r, 1:os_c))), sum(sum(temp(os_r+1:2*os_r, 1:os_c))), sum(sum(temp(2*os_r+1:3*os_r, 1:os_c))), sum(sum(temp(3*os_r+1:size(temp, 1), 1:os_c))),... 
%         sum(sum(temp(1:os_r, os_c+1:2*os_c))), sum(sum(temp(os_r+1:2*os_r, os_c+1:2*os_c))), sum(sum(temp(2*os_r+1:3*os_r, os_c+1:2*os_c))), sum(sum(temp(3*os_r+1:size(temp, 1), os_c+1:2*os_c))),...
%         sum(sum(temp(1:os_r, 2*os_c+1:3*os_c))), sum(sum(temp(os_r+1:2*os_r, 2*os_c+1:3*os_c))), sum(sum(temp(2*os_r+1:3*os_r, 2*os_c+1:3*os_c))), sum(sum(temp(3*os_r+1:size(temp, 1), 2*os_c+1:3*os_c))),...
%         sum(sum(temp(1:os_r, 3*os_c+1:size(temp, 2)))), sum(sum(temp(os_r+1:2*os_r, 3*os_c+1:size(temp, 2)))), sum(sum(temp(2*os_r+1:3*os_r, 3*os_c+1:size(temp, 2)))), sum(sum(temp(3*os_r+1:size(temp, 1), 3*os_c+1:size(temp, 2))))];
end