%% decision tree depth test case
% definition of all parameters are the same as train_size_test.m
% Do not recommand to run this script due to long running time.
%   reducing 'tree_depth_end' could save running time but may not be able to
%   observe overfitting phenonmena.

clear all;
close all;
clc;
load('hw1data');
train_size = 9000;
tree_depth_start = 1;
tree_depth_end = 28;

rand('seed',sum(100*clock));
index = 1:size(X, 1);
train_index = randsample(size(X, 1), train_size);
test_index = index(find(~ismember(index, train_index)));
train_data = X(train_index, :);
train_label = Y(train_index);
test_data = X(test_index, :);
test_label = Y(test_index);

err_train = zeros(1, tree_depth_end - tree_depth_start + 1);
err_test = zeros(1, tree_depth_end - tree_depth_start + 1);
for i = 1:tree_depth_end - tree_depth_start + 1
    [err_train(i), err_test(i)] = decisionTree(train_data, train_label, test_data, test_label, i+tree_depth_start-1);
end
figure, plot((tree_depth_start:tree_depth_end), err_test, '-bs', (tree_depth_start:tree_depth_end), err_train, '-rx');
title('error rate of train data and test data');
xlabel('tree depth');
ylabel('error rate');
legend('test error', 'train error');
hold on;
overfitting_index = find(err_test==min(err_test));
stem(overfitting_index(1), 90);
hold off;
saveas(gcf, 'error_rate_overfitting', 'jpg');
