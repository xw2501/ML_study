clear all;
close all;
clc;
load('hw1data');
k = 5;                                                                  % set k=5
train_size_end = 9000;                                                  % train size end point
train_size_end = train_size_end / 1000;
train_size_start = 1000;                                                % train size start point
train_size_start = train_size_start / 1000;
err_test = zeros(1, train_size_end - train_size_start + 1);
err_train = err_test;
X = preProcess(X, 16);

for t = train_size_start:train_size_end
    %% test
    tic;
    train_size = t*1000;
    test_size = size(X, 1) - train_size;
    rand('seed',sum(100*clock));
    index = 1:size(X, 1);
    train_index = randsample(size(X, 1), train_size);                   % generalize arbitrary train data index
    test_index = index(find(~ismember(index, train_index)));            % generalize corresponding test data index
    train_data = X(train_index, :);
    train_label = Y(train_index);
    test_data = X(test_index, :);
    test_label = Y(test_index);  
    cnt = 0;
    for i=1:test_size                                                   % compute accuracy of test data
        dis = zeros(1, train_size);
        for j=1:train_size
            dis(j) = (test_data(i, :)-train_data(j, :))*(test_data(i, :)-train_data(j, :)).';   % use Euclidean distance 
        end
        sorted_dis = sort(dis);
        value = sorted_dis(k);                                          % sort distance
        index = find(dis<=value);                                       % get the index of kth nearest point
        pro = zeros(1, 10);
        for j=1:k
            pro(train_label(index(j))+1) = pro(train_label(index(j))+1) + 1;    % count the appearance times of each label
        end
        pre = find(pro==max(pro))-1;                                            % prediction value = label appeared most times
        if pre==test_label(i)
            cnt = cnt + 1;
        end
    end
    err_test(t) = (1 - cnt/test_size) * 100;
    
    cnt = 0;
    for i=1:train_size                                                  % compute accuracy of training data
        dis = zeros(1, train_size);
        for j=1:train_size
            dis(j) = (train_data(i, :)-train_data(j, :))*(train_data(i, :)-train_data(j, :)).';
        end
        sorted_dis = sort(dis);
        value = sorted_dis(k+1);
        index = find(dis<=value);
        index = index(find(index~=0));
        pro = zeros(1, 10);
        for j=1:k
            pro(train_label(index(j))+1) = pro(train_label(index(j))+1) + 1;
        end
        pre = find(pro==max(pro))-1;
        if pre==train_label(i)
            cnt = cnt + 1;
        end
    end
    err_train(t) = (1 - cnt/train_size) * 100;
    toc;
end

%% result process
figure, plot((train_size_start*1000:1000:train_size_end*1000), err_test, '-bs', (train_size_start*1000:1000:train_size_end*1000), err_train, '-rx');
title('error rate of train data and test data');
xlabel('train size');
ylabel('error rate');
legend('test error', 'train error');
saveas(gcf, 'error_rate_classifier_k-NN', 'jpg');