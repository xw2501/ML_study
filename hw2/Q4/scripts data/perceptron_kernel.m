%% perceptron kernel
% kernel function, k(x, x') = (<x, x'> + 1)^6
% input training data size and iteration times
%   data will be loaded in this function
% output accuracy of testing data and accuracy of training data
function [test_accuracy, train_accuracy] = perceptron_kernel(train_size, iter_num) 

load('hw1data');

test_size = size(X, 1) - train_size;
classes_num = 10;

Y = preProcess(Y);                                                      % transform label Y

rand('seed',sum(100*clock));                                            % generalize train data and test data
index = 1:size(X, 1);
train_index = randsample(size(X, 1), train_size);
test_index = index(find(~ismember(index, train_index)));
train_data = X(train_index, :);
train_label = Y(train_index, :);
test_data = X(test_index, :);
test_label = Y(test_index, :);

W = zeros(train_size, classes_num);                                     % initialize W

%% training
for i = 1:iter_num
    index = mod(i, train_size) + 1;
    temp = ((train_data*train_data(index, :).'+1).^6).'*(W.*train_label);
    for j = 1:classes_num
        if temp(j)*train_label(index, j)<=0
            W(index, j) = W(index, j) + 1;
        end
    end
end

%% testing. 
cnt = 0;
for i = 1:test_size    %test accuracy
    prediction = ((train_data*test_data(i, :).'+1).^6).'*(W.*train_label);
    prediction = find(prediction==max(prediction));
    if test_label(i, prediction)==1 && prediction>0
        cnt = cnt + 1;
    end
end
test_accuracy = cnt / test_size;

cnt = 0;
for i = 1:train_size    %train accuracy
    prediction = ((train_data*train_data(i, :).'+1).^6).'*(W.*train_label);
    prediction = find(prediction==max(prediction));
    if train_label(i, prediction)==1 && prediction>0
        cnt = cnt + 1;
    end
end
train_accuracy = cnt / train_size;