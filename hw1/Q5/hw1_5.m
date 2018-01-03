clear all;
close all;
clc;
load('hw1data');
train_size_end = 9000;                                                  % train size end point 
train_size_end = train_size_end / 1000;
train_size_start = 1000;                                                % train size start point
train_size_start = train_size_start / 1000;
err_train = zeros(1, train_size_end - train_size_start + 1);
err_test = err_train;
running_time = zeros(1, train_size_end - train_size_start + 1);

X = preProcess(X, 16);          % preprocessing dataset. see details in preProcess.m 

%% this noted part is not used
% %% naive bayes
% %% training
% mu = zeros(10, 784);
% theta = zeros(10, 784);
% num = zeros(1, 10);
% for i=1:train_size
%     num(Y(i)+1) = num(Y(i)+1) + 1;
%     mu(Y(i)+1, :) = X(i, :) + mu(Y(i)+1, :);
% end
% for i=1:10
%     mu(i, :) = mu(i, :)/num(i);
% end
% for i=1:train_size
%     theta(Y(i)+1, :) = (X(i, :)-mu(Y(i)+1, :)).^2 + theta(Y(i)+1, :);
% end
% for i=1:10
%     theta(i, :) = theta(i, :)/num(i);
% end
% sum_num = sum(num);
% for i=1:10
%     num(i) = num(i)/sum_num;
% end
% 
% 
% %% testing
% pre = zeros(1, 10000-train_size);
% cnt = 0;
% for i=train_size+1:10000
%     pro = zeros(1, 10);
%     for j=1:10
%         pro(j) = log(num(j));
%     end
%     for j=1:784
%         for k=1:10
%             if mu(k, j)<5
%                 continue;
%             end
%             pro(k) = pro(k) + log(1/sqrt(2*pi*theta(k, j))*exp(-1*(X(i, j)-mu(k, j))^2/2/theta(k, j))*200);
%         end
%     end
%     index = find(pro==max(pro))-1;
%     if index==Y(i)
%         cnt = cnt+1;
%     end
% end
% cnt/(10000-train_size)

%% training and testing
for t = train_size_start:train_size_end
    %% preprocessing and computation
    tic;
    train_size = t*1000;                                                % actual train size of this loop 
    test_size = size(X, 1) - train_size;                                % actual test size of this loop
    rand('seed',sum(100*clock));
    index = 1:size(X, 1);                                               
    train_index = randsample(size(X, 1), train_size);                   % generalize arbitrary train data index
    test_index = index(find(~ismember(index, train_index)));            % generalize corresponding test data index
    train_data = X(train_index, :);
    train_label = Y(train_index);
    test_data = X(test_index, :);
    test_label = Y(test_index);  
    mu = zeros(10, 16);
    num = zeros(1, 10);
    index = zeros(10, 16);
    theta = zeros(16, 16, 10);
    for i=1:train_size                                                  % count number of each label
        num(train_label(i)+1) = num(train_label(i)+1) + 1;
        mu(train_label(i)+1, :) = train_data(i, :) + mu(train_label(i)+1, :);
    end                                                
    for i=1:10                                                          % compute mean value of data of each label
        mu(i, :) = mu(i, :) / num(i);
    end                                                               
    point = ones(1, 10);        % this part was initially used to filter all blamk pixels, 
                                % as preprocessing is applied, it is no longer useful.
                                % however, to remove it will change the
                                % structure of following codes, thus this
                                % part is not deleted.
    for i=1:16
        for j=1:10
            if mu(j, i)>5
                index(j, point(j)) = i;
                point(j) = point(j) + 1;
            end
        end
    end
    for i=1:10
        point(i) = point(i) - 1;
    end
    
    %% training computation of mean-mu and variance-theta
    for i=1:train_size
        mu_array = zeros(1, point(train_label(i)+1));
        x_array = zeros(1, point(train_label(i)+1));
        for j=1:point(train_label(i)+1)
            mu_array(j) = mu(train_label(i)+1, index(train_label(i)+1, j));     % computing mu
            x_array(j) = train_data(i, index(train_label(i)+1, j));
        end
        temp = x_array-mu_array;
        theta(1:point(train_label(i)+1), 1:point(train_label(i)+1), train_label(i)+1) = ...
            theta(1:point(train_label(i)+1), 1:point(train_label(i)+1), train_label(i)+1) + (x_array-mu_array).'*(x_array-mu_array);        % computing theta
    end
    for i=1:10
        theta(:, :, i) = theta(:, :, i) / num(i);
    end
    
    %% testing computation of accuracy of training data and test data
    cnt = 0;
    for i = 1:test_size                                                 % compute accuracy of test data
        pro = zeros(1, 10);
        for j = 1:10
            if det(theta(:,:,j))==0
                theta(:,:,j) = theta(:,:,j) + ones(16,16);
            end
            pro(j) = 1/sqrt((2*pi)^9*det(theta(:,:,j)))*exp(-1/2*(test_data(i,:)-mu(j,:))*inv(theta(:,:,j))*(test_data(i,:)-mu(j,:)).');
        end
        pre = find(pro==max(pro));
        if (pre-1)==test_label(i)
            cnt = cnt+1;
        end
    end
    err_test(t) = (1 - cnt / test_size) * 100;
    
    cnt = 0;
    for i = 1:train_size                                                % compute accuracy of training data
        pro = zeros(1, 10);
        for j = 1:10
            if det(theta(:,:,j))==0
                theta(:,:,j) = theta(:,:,j) + ones(16,16);
            end
            pro(j) = 1/sqrt((2*pi)^9*det(theta(:,:,j)))*exp(-1/2*(train_data(i,:)-mu(j,:))*inv(theta(:,:,j))*(train_data(i,:)-mu(j,:)).');
        end
        pre = find(pro==max(pro));
        if (pre-1)==train_label(i)
            cnt = cnt+1;
        end
    end
    err_train(t) = (1 - cnt / train_size) * 100;
    toc;
end

%% result process
figure, plot((train_size_start*1000:1000:train_size_end*1000), err_test, '-bs', (train_size_start*1000:1000:train_size_end*1000), err_train, '-rx');
title('error rate of train data and test data');
xlabel('train size');
ylabel('error rate');
legend('test error', 'train error');
% saveas(gcf, 'error_rate_classifier_multiGaussian', 'jpg');