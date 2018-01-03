clear all;
close all;
clc;
load('hw1data');
k_start = 1;                        % k start value
k_end = 10;                         % k end value
train_size_end = 9000;
train_size_end = train_size_end / 1000;
train_size_start = 1000;
train_size_start = train_size_start / 1000;
err_test = zeros(k_end - k_start + 1, train_size_end - train_size_start + 1);
X = preProcess(X, 16);

%% k-NN with different k value
% definition of all the parameters are the same as hw1_5_2. 
for t = train_size_start:train_size_end
    %% test
    tic;
    train_size = t*1000;
    test_size = size(X, 1) - train_size;
    rand('seed',sum(100*clock));
    index = 1:size(X, 1);
    train_index = randsample(size(X, 1), train_size);
    test_index = index(find(~ismember(index, train_index)));
    train_data = X(train_index, :);
    train_label = Y(train_index);
    test_data = X(test_index, :);
    test_label = Y(test_index);  
    cnt = zeros(k_end-k_start+1, 1);
    for i=1:test_size
        dis = zeros(1, train_size);
        for j=1:train_size
            dis(j) = (test_data(i, :)-train_data(j, :))*(test_data(i, :)-train_data(j, :)).';
        end
        sorted_dis = sort(dis);
        for j=1:k_end-k_start+1
            k = j+k_start-1;
            value = sorted_dis(k_start+j-1);
            index = find(dis<=value);
            pro = zeros(1, 10);
            for jj=1:k
                pro(train_label(index(jj))+1) = pro(train_label(index(jj))+1) + 1;
            end
            pre = find(pro==max(pro))-1;
            if pre==test_label(i)
                cnt(j) = cnt(j) + 1;
            end
        end
    end
    err_test(:, t) = (1 - cnt/test_size) * 100;
    toc;
end

%% result process
figure,
for i=2:2:10
    hold on;
    plot((train_size_start*1000:1000:train_size_end*1000), err_test(i, :));
end
title('error rate of test data');
xlabel('train size');
ylabel('error rate');
% legend('test error', 'train error');
% saveas(gcf, 'error_rate_classifier_multiGaussian', 'jpg');