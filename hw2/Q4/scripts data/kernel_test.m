%% iter num test case
% set training data size to a constant number, change the iteration times
% to compare three perceptrons performance
iter_num = [1000; 2000; 3000; 4000; 5000; 6000; 7000; 8000; 9000];
train_size = 2000;

test_num = size(iter_num, 1);
test_accuracy = zeros(test_num, 1);
train_accuracy = zeros(test_num, 1);

for i = 1:test_num
    [test_accuracy(i), train_accuracy(i)] = perceptron_kernel(train_size, iter_num(i));
end
err_iter_test = 1 - test_accuracy;
err_iter_train = 1 - train_accuracy;

figure,
plot(iter_num, err_iter_test);
hold on;
plot(iter_num, err_iter_train);
axis([1000, 9000, 0, 1]);
xlabel('iter num');
ylabel('error rate');
legend('test error', 'train error');
title('error rate of kernel perceptron');
saveas(gcf, '10way_error_rate_of_kernel_perceptron', 'png');
save('10way_err_iter_test.mat', 'err_iter_test');
save('10way_err_iter_train.mat', 'err_iter_train');

%% train size test case
% set iteration times to a constant number, change the training data size
% to compare three perceptrons performance

iter_num = 2000;
train_size = [1000; 2000; 3000; 4000; 5000; 6000; 7000; 8000; 9000];

test_num = size(train_size, 1);
test_accuracy = zeros(test_num, 1);
train_accuracy = zeros(test_num, 1);

for i = 1:test_num
    [test_accuracy(i), train_accuracy(i)] = perceptron_kernel(train_size(i), iter_num);
end
err_train_test = 1 - test_accuracy;
err_train_train = 1 - train_accuracy;

figure,
plot(train_size, err_train_test);
hold on;
plot(train_size, err_train_train);
axis([1000, 9000, 0, 1]);
xlabel('train size');
ylabel('error rate');
legend('test error', 'train error');
title('error rate of kernel perceptron');
saveas(gcf, '10way_train_error_rate_of_kernel_perceptron', 'png');
save('10way_err_train_test.mat', 'err_train_test');
save('10way_err_train_train.mat', 'err_train_train');

%%
% This commented part is the error rate of binary classification of each
%   digit of three perceptrons
% To see the error rate, uncomment the following part and comment the rest
%   of the code
% Note, the graph is based on previous test result and only test error rate
%   is saved, thus the graph is the error rate of test error

% load('err_train_test.mat');
% train_size = [1000; 2000; 3000; 4000; 5000; 6000; 7000; 8000; 9000];
% figure,
% for i = 1:10
%     hold on;
%     plot(train_size, err_train_test(:, i));
% end
% axis([1000, 9000, 0, 1]);
% xlabel('train size');
% ylabel('error rate');
% legend('0','1','2','3','4','5','6','7','8','9');
% title('error rate of kernel perceptron');
% 
% load('err_iter_test.mat');
% iter_num = [1000; 2000; 3000; 4000; 5000; 6000; 7000; 8000; 9000];
% figure,
% for i = 1:10
%     hold on;
%     plot(iter_num, err_iter_test(:, i));
% end
% axis([1000, 9000, 0, 1]);
% xlabel('iter num');
% ylabel('error rate');
% legend('0','1','2','3','4','5','6','7','8','9');
% title('error rate of kernel perceptron');