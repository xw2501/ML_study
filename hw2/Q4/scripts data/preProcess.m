%% preprocess function
% transform the label form (n, 1) matrix to (n, 10) matrix
%   columns corresponding to the label have value +1, others have value -1 
function out = preProcess(Y)
classes_num = 10;
data_size = size(Y, 1);
out = ones(data_size, classes_num) * -1;
for i = 1:data_size
    out(i, Y(i)+1) = 1;
end
