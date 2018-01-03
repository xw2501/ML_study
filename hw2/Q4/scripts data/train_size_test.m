%% train size test case
% set iteration times to a constant number, change the training data size
% to compare three perceptrons performance
iter_num = 2000;
train_size = [1000; 2000; 3000; 4000; 5000; 6000; 7000; 8000; 9000];

test_num = size(train_size, 1);
test_accuracy = zeros(test_num, 3);
train_accuracy = zeros(test_num, 3);

for i = 1:test_num
    [test_accuracy(i, 1), train_accuracy(i, 1)] = perceptron_v0(train_size(i), iter_num);
    [test_accuracy(i, 2), train_accuracy(i, 2)] = perceptron_v1(train_size(i), iter_num);
    [test_accuracy(i, 3), train_accuracy(i, 3)] = perceptron_v2(train_size(i), iter_num);
end
test_err = 1 - test_accuracy;
train_err = 1 - train_accuracy;


%% result processing
% draw the training error and testing error over training data size, here
% the error rate is error rate of 10 way classification.
figure,
plot(train_size, test_err(:, 1));
hold on;
plot(train_size, test_err(:, 2));
hold on;
plot(train_size, test_err(:, 3));
axis([min(train_size), max(train_size), 0, 1]);
xlabel('train size');
ylabel('error rate');
title('test error of perceptrons');
legend('perceptron v0', 'perceptron v1', 'perceptron v2');

figure,
plot(train_size, train_err(:, 1));
hold on;
plot(train_size, train_err(:, 2));
hold on;
plot(train_size, train_err(:, 3));
axis([min(train_size), max(train_size), 0, 1]);
xlabel('train size');
ylabel('error rate');
title('train error of perceptrons');
legend('perceptron v0', 'perceptron v1', 'perceptron v2');

%% 
% This commented part is the error rate of binary classification of each
%   digit of three perceptrons
% To see the error rate, uncomment the following part and comment the rest
%   of the code
% Note, the graph is based on previous test result and only test error rate
%   is saved, thus the graph is the error rate of test error

% load('train_size_three_perceptrons');
% train_size = [1000; 2000; 3000; 4000; 5000; 6000; 7000; 8000; 9000];
% for k = 1:3
%     figure,
%     for i = 1:10
%         hold on;
%         plot(train_size, err(:, i, k));
%     end
%     axis([min(train_size), max(train_size), 0, 1]);
%     xlabel('train size');
%     ylabel('error rate');
%     title(['error rate of perceptron v', num2str(k-1)]);
%     legend('0','1','2','3','4','5','6','7','8','9');
% end
% 
% figure,
% for k = 1:3
%     hold on;
%     plot(train_size, err(:, 6, k));
% end
% xlabel('train size');
% ylabel('error rate');
% title('compare of three perceptrons of digit 5');
% legend('v0','v1','v2');