%% training data size test case

clear all;
close all;
clc;
load('hw1data');
train_size_start = 1000;                            % train size start point
train_size_start = train_size_start / 1000;
train_size_end = 9000;                              % train size end point
train_size_end = train_size_end / 1000;
tree_depth = 15;                                    % depth of decision tree

err_train = zeros(1, train_size_end - train_size_start + 1);
err_test = zeros(1, train_size_end - train_size_start + 1);

for i = 1:train_size_end - train_size_start + 1
    train_size = (i+train_size_start-1)*1000;
    rand('seed',sum(100*clock));
    index = 1:size(X, 1);
    train_index = randsample(size(X, 1), train_size);                   % generalize arbitrary train data index
    test_index = index(find(~ismember(index, train_index)));            % genrealize corresponding test data index
    train_data = X(train_index, :);
    train_label = Y(train_index);
    test_data = X(test_index, :);
    test_label = Y(test_index);
    [err_train(i), err_test(i)] = decisionTree(train_data, train_label, test_data, test_label, tree_depth);         % build and test decision tree
end

%% result process
figure, plot((train_size_start*1000:1000:train_size_end*1000), err_test, '-bs', (train_size_start:train_size_end), err_train, '-rx');
title('error rate of train data and test data');
xlabel('train data size');
ylabel('error rate');
legend('test error', 'train error');
saveas(gcf, 'error_rate_trainsize', 'jpg');
