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
num = zeros(1, 10);
for i = 1:10
    num(i) = length(find(Y==(i-1)));
end

% start computation
der_2 = 1 / 784;
index = round(rand*(len-1) + 1);
der_1 = -sum(X(index, :) - theta(Y(index)+1));
diff = der_2.*der_1;                                                        % step size, computed according to random sample
index_est = ones(1, 10);
index_act = ones(1, 10);
deri_est(Y(index)+1, index_est(Y(index)+1)) = der_1*num(Y(index)+1);        % estimated 1st derivative
index_est(Y(index)+1) = index_est(Y(index)+1) + 1;
deri_act(Y(index)+1, index_act(Y(index)+1)) = -sum(sum(X(find(Y==Y(index)), :) - theta(Y(index)+1)));       % actual 1st derivative
index_act(Y(index)+1) = index_act(Y(index)+1) + 1;
while abs(diff)>threshold
    theta(Y(index)+1) = theta(Y(index)+1) - diff;
    index = round(rand*(len-1) + 1);
    der_1 = -sum(X(index, :) - theta(Y(index)+1));
    diff = der_2.*der_1;
    deri_est(Y(index)+1, index_est(Y(index)+1)) = der_1*num(Y(index)+1);
    index_est(Y(index)+1) = index_est(Y(index)+1) + 1;
    deri_act(Y(index)+1, index_act(Y(index)+1)) = -sum(sum(X(find(Y==Y(index)), :) - theta(Y(index)+1)));
    index_act(Y(index)+1) = index_act(Y(index)+1) + 1;
end

%% result process
for i = 1: 10
figure,
histogram(deri_est(find(deri_est(i, :)~=0)), 'BinWidth', 1e8, 'EdgeColor', 'b');
hold on;
histogram(deri_act(find(deri_act(i, :)~=0)), 'BinWidth', 1e8, 'EdgeColor', 'y');
xlabel('1st derivative');
ylabel('number');
legend('estimated value', 'actual value');
title(['histogram of theta', num2str(i)]);
% saveas(gcf, ['histogram_theta_', num2str(i)], 'jpg');
end

