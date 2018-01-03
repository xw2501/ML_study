clear all;
close all;
clc;
load('hw1data');
k = 1;                                                                  % k value
train_size_end = 9000;                                                  % train size end point
train_size_end = train_size_end / 1000;
train_size_start = 1000;                                                % train size start point
train_size_start = train_size_start / 1000;
err_test = zeros(3, train_size_end - train_size_start + 1);
err_train = err_test;
X = preProcess(X, 16);

%% k-NN of different kinds of distances
% defination of all parameters are the same as hw1_5_2.m
for t = train_size_start:train_size_end
    %% test
    tic;
    train_size = t*1000;
    test_size = size(X, 1) - train_size;
    rand('seed',sum(100*clock));
    t_index = 1:size(X, 1);
    train_index = randsample(size(X, 1), train_size);
    test_index = t_index(find(~ismember(t_index, train_index)));
    train_data = X(train_index, :);
    train_label = Y(train_index);
    test_data = X(test_index, :);
    test_label = Y(test_index);  
    cnt = zeros(1, 3);
    index = zeros(3, k);
    for i=1:test_size
        dis = zeros(3, train_size);
        sorted_dis = zeros(3, train_size);
        for j=1:train_size
            dis(1, j) = sum(abs(test_data(i, :)-train_data(j, :)));                                     % manhattan distance
            dis(2, j) = (test_data(i, :)-train_data(j, :))*(test_data(i, :)-train_data(j, :)).';        % euclidean distance
            dis(3, j) = max(abs(test_data(i, :)-train_data(j, :)));                                     % maximum distance
        end
        sorted_dis(1, :) = sort(dis(1, :));         sorted_dis(2, :) = sort(dis(2, :));         sorted_dis(3, :) = sort(dis(3, :));
        value(1) = sorted_dis(1, k);                value(2) = sorted_dis(2, k);                value(3) = sorted_dis(3, k);
        index1 = find(dis(1, :)<=value(1));         index2 = find(dis(2, :)<=value(2));         index3 = find(dis(3, :)<=value(3));  
        index(1,:) = index1(1:k);
        index(2,:) = index2(1:k);
        index(3,:) = index3(1:k);
        pro1 = zeros(1, 10);
        pro2 = zeros(1, 10);
        pro3 = zeros(1, 10);
        for j=1:k
            pro1(train_label(index(1, j))+1) = pro1(train_label(index(1, j))+1) + 1;
            pro2(train_label(index(2, j))+1) = pro2(train_label(index(2, j))+1) + 1;
            pro3(train_label(index(3, j))+1) = pro3(train_label(index(3, j))+1) + 1;
        end
        pre1 = find(pro1==max(pro1));
        pre1 = pre1(1) - 1;
        pre2 = find(pro1==max(pro1));
        pre2 = pre2(1) - 1;
        pre3 = find(pro1==max(pro1));
        pre3 = pre3(1) - 1;
        if pre1==test_label(i)
            cnt(1) = cnt(1) + 1;
        end
        if pre2==test_label(i)
            cnt(2) = cnt(2) + 1;
        end
        if pre3==test_label(i)
            cnt(3) = cnt(3) + 1;
        end
    end
    err_test(1, t) = (1 - cnt(1)/test_size) * 100;
    err_test(2, t) = (1 - cnt(2)/test_size) * 100;
    err_test(3, t) = (1 - cnt(3)/test_size) * 100;
    toc;
end

%% this part is not the result process for this script.
% figure, plot((train_size_start*1000:1000:train_size_end*1000), err_test, '-bs', (train_size_start*1000:1000:train_size_end*1000), err_train, '-rx');
% title('error rate of train data and test data');
% xlabel('train size');
% ylabel('error rate');
% legend('test error', 'train error');
% saveas(gcf, 'error_rate_classifier_k-NN', 'jpg');', 'jpg');