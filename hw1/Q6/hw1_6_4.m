clear all;
close all;
clc;
load('hw1data');
rand('seed',sum(100*clock));
theta = randn(1, 10)*1000;           % initialize theta
theta
threshold = 1e-5;
dim = size(X, 2);
len = size(X, 1);

time = [];
func_value = [];
diff = 100;
% start computation
der_2 = 1 / 784;                                                        % transformed 2nd derivative, to compute step size        
while abs(diff)>threshold
    tic;
    index = round(rand*(len-1) + 1);                                        % random sample
    der_1 = -sum(X(index, :) - theta(Y(index)+1));                          % 1st derivative
    diff = der_2.*der_1;                                                    % step size      
    theta(Y(index)+1) = theta(Y(index)+1) - diff;                           % update theta
    time(size(time, 2)+1) = toc;
    func_value(size(func_value, 2) + 1) = 0;
    for i = 1:10
        func_value(size(func_value, 2)) = func_value(size(func_value, 2)) + 0.5 * sum(sum((X(find(Y==(i-1)), :) - theta(i)).^2));
    end
end
end_point = theta;                                                      % end point, optimal theta
func_value = log(func_value);
for i = 2:size(time, 2)
    time(i) = time(i) + time(i-1);
end
figure,
plot(time, func_value);
title('time-function value graph estimate');
xlabel('time');
ylabel('function value in log');
saveas(gcf, 'time-function value graph estimate', 'jpg');
