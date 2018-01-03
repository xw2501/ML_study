%% perceptron V0
% input training data size and iteration times
%   data will be loaded in this function
% output accuracy of testing data and accuracy of training data
function [test_accuracy, train_accuracy] = perceptron_v0(train_size, iter_num) 

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

W = zeros(features_num, classes_num);                                   % initialize W

%% training
for i = 1:iter_num
    index = mod(i, train_size) + 1;
    for j = 1:classes_num
        if train_label(index, j)*(train_data(index, :)*W(:, j))<=0
            W(:, j) = W(:, j) + (train_label(index, j)*train_data(index, :)).';
        end
    end
end

%% testing
cnt = 0;
for i = 1:test_size    % test accuracy
    prediction = test_data(i, :)*W;
    prediction = find(prediction==max(prediction));
    if test_label(i, prediction)==1 && prediction>0
        cnt = cnt + 1;
    end
end
test_accuracy = cnt / test_size;

cnt = 0;
for i = 1:train_size    % train accuracy
    prediction = train_data(i, :)*W;
    prediction = find(prediction==max(prediction));
    if train_label(i, prediction)==1 && prediction>0
        cnt = cnt + 1;
    end
end
train_accuracy = cnt / train_size;