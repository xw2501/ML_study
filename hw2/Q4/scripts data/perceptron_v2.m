%% perceptron V2
% input training data size and iteration times
%   data will be loaded in this function
% output accuracy of testing data and accuracy of training data
function [test_accuracy, train_accuracy] = perceptron_v2(train_size, iter_num) 

load('hw1data');

test_size = size(X, 1) - train_size;                                    % calculate test data size
features_num = size(X, 2);                                              % feature number
classes_num = 10;                                                       % classes number

Y = preProcess(Y);                                                      % transform label Y

rand('seed',sum(100*clock));                                            % generalize train data and test data
index = 1:size(X, 1);                                                   % arbitrary devide data into train data and test data
train_index = randsample(size(X, 1), train_size);
test_index = index(find(~ismember(index, train_index)));
train_data = X(train_index, :);
train_label = Y(train_index, :);
test_data = X(test_index, :);
test_label = Y(test_index, :);

W = zeros(features_num, classes_num, iter_num);                                   % initialize W
W(:, :, 1) = rand(features_num, classes_num)*1e-3;
c = zeros(iter_num, classes_num);                                                 % initialize c
k = 1;

%% training
for j = 1:classes_num
    k = 1;
    for i = 1:iter_num
        index = mod(i, train_size) + 1;
        if train_label(index, j)*(train_data(index, :)*W(:, j, k))<=0
            W(:, j, k+1) = W(:, j, k) + (train_label(index, j)*train_data(index, :)).';
            c(k+1, j) = 1;
            k = k + 1;
        else
            c(k, j) = c(k, j) + 1;
        end
    end
end

%% testing
cnt = 0;
for i = 1:test_size    % test accuracy
    prediction = zeros(classes_num, 1);
    for j = 1:classes_num
        index = 2;
        while c(index, j)~=0
            prediction(j) = prediction(j) + c(index, j) * test_data(i, :) * W(:, j, index);
            index = index + 1;
        end
    end
    prediction = find(prediction==max(prediction));
    if test_label(i, prediction)==1 && prediction>0
        cnt = cnt + 1;
    end
end
test_accuracy = cnt / test_size;

cnt = 0;
for i = 1:train_size    % train accuracy
    prediction = zeros(classes_num, 1);
    for j = 1:classes_num
        index = 2;
        while c(index, j)~=0
            prediction(j) = prediction(j) + c(index, j) * train_data(i, :) * W(:, j, index);
            index = index + 1;
        end
    end
    prediction = find(prediction==max(prediction));
    if train_label(i, prediction)==1 && prediction>0
        cnt = cnt + 1;
    end
end
train_accuracy = cnt / train_size;