%% function of building and testing decision tree
% Used to build a tree according to input data and return the test result
% Input:
%       X: train data set
%       Y: label of train data
%       X_test: test data set
%       Y_test: label of test data set
%       tree_depth: depth of decision tree
% Output:
%       train_err: error rate of train data
%       test_err: error rate of test data
function [train_err, test_err] = decisionTree(X, Y, X_test, Y_test, tree_depth)
train_size = size(X, 1);
test_size = size(X_test, 1);
num_classes = 10;
pic_compress_size = 9;                      % note that in this program the images are compressed to 9 dimensions
X = preProcess(X, pic_compress_size);
X_test = preProcess(X_test, pic_compress_size);
mu = zeros(num_classes, pic_compress_size);
num = zeros(1, num_classes);

%% preprocess
% reshape the training data according to labels into X_9
for i = 1:num_classes
    num(i) = length(find(Y(1:train_size)==(i-1)));
end

X_9 = zeros(max(num), pic_compress_size, num_classes);
for i = 1:num_classes
    X_9(1:num(i),:,i) = X(find(Y(1:train_size)==(i-1)), :);
end
for i = 1:num_classes
    mu(i, :) = sum(X_9(:, :, i)) / num(i);
end
% root = tree_node;
% root.node_build_tree(X_9, tree_depth, 0);

%% data structure if decision tree
% Features of each depth of tree and relative threshold are saved in two
% arrays with a size corresponding to the depth of decision tree.
% The prediction ares saved in map array.
% Array may not be the best structure for this program, it will take large space to save data.
% but it is fast in building decision tree and accessing data.
features = ones(1, 2^tree_depth-1);
threshold = zeros(1, 2^tree_depth-1);
map = zeros(1, 2^(tree_depth+1));

%% training, building tree
[features, threshold, map] = build_tree(X_9, tree_depth, features, threshold, map, 1, 1);

%% testing
% In testing part, what we need to do is to go along the decision tree
% until we go to the bottom of the tree, and then we will get a prediction
% value.
% In this script, we need to compare the value of feature of test data with 
% corresponding threshold. then according to the result, we choose a
% subtree to continue. In my structure, the three are organized by indice of
% arrays.
cnt = 0;
for i = 1:train_size                  % test of training data
    pos = 1;
    for j = 1:tree_depth
        if X(i, features(pos))>=threshold(pos)
            pos = pos*2+1;
        else
            pos = pos*2;
        end
    end
    if (map(pos)-1)==Y(i)
        cnt = cnt + 1;
    end
end
train_err = (1 - cnt / train_size) * 100;

cnt = 0;
for i = 1:test_size                   % test of testing data
    pos = 1;
    for j = 1:tree_depth
        if X_test(i, features(pos))>=threshold(pos)
            pos = pos*2+1;
        else
            pos = pos*2;
        end
    end
    if (map(pos)-1)==Y_test(i)
        cnt = cnt + 1;
    end
end
test_err = (1 - cnt / test_size) * 100;


