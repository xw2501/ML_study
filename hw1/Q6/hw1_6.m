clear all;
close all;
clc;
load('hw1data');
rand('seed',sum(100*clock));
theta = randn(1, 10)*1000;           % initialize theta
der_1 = zeros(1, 10);
der_2 = zeros(1, 10);
threshold = 1e-5;
dim = size(X, 2);
len = size(X, 1);

% start computation
for i = 1:len
    der_2(Y(i)+1) = der_2(Y(i)+1) + 1;
end
for i = 1:10
    der_2(i) = 1 / der_2(i) / 784;                                      % transformed 2nd derivative, to compute step size
end
diff = 100;
time = [];
func_value = [];
while abs(diff)>threshold
    diff = zeros(1, 10);
    for i = 1:10
        tic;
        der_1(i) = -sum(sum(X(find(Y==(i-1)), :) - theta(i)));              % 1st derivative
        diff(i) = der_2(i)*der_1(i);                                        % step size
        theta(i) = theta(i) - diff(i);                                      % update theta
        time(size(time, 2)+1) = toc;
        func_value(size(func_value, 2) + 1) = 0;
        for i = 1:10
            func_value(size(func_value, 2)) = func_value(size(func_value, 2)) + 0.5 * sum(sum((X(find(Y==(i-1)), :) - theta(i)).^2));
        end
    end                                                               
end
end_point = theta;                                                      % end point, optimal theta
func_value = log(func_value);
for i = 2:size(time, 2)
    time(i) = time(i) + time(i-1);
end
figure,
plot(time, func_value, '-bo');
title('time-function value graph');
xlabel('time');
ylabel('function value in log');
saveas(gcf, 'time-function value graph', 'jpg');