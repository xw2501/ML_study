close all;
clear all;
clc;

%% initailization
load('hw2data');
neurons_num = 8;                                                        % number of neurons in middle layer
threshold = 2e-5;                                                       % threshold for Error function
updating_rate = 0.1;                                                    % updating rate of parameters
data_size = size(X, 1);
W_1 = rand(neurons_num, 1);                                             % initialize parameters with random value
W_2 = rand(neurons_num, 1);
b_1 = rand(neurons_num, 1);
b_2 = rand(1, 1);

Err = 1;
%% training neurons until error function less than threshold 
while Err>threshold
    midNuerons = zeros(neurons_num, 1);                                 % initialize middle layer neurons
    dW_1 = zeros(size(W_1));                                            % initailize derivative of parameters
    dW_2 = zeros(size(W_2));
    db_1 = zeros(size(b_1));
    db_2 = zeros(size(b_2));
    Err = 0;
    for i = 1:data_size
        for j = 1:neurons_num
            midNuerons(j) = 1/(1+exp(-(W_1(j)*X(i)+b_1(j))));           % calculate value of middle layer
        end
        out = 1/(1+exp(-(W_2.'*midNuerons+b_2)));                       % calculate output
        dout = (out-Y(i))*out*(1-out);                                  % calculate derivative of output
        Err = Err + (out-Y(i))^2;                                       % calculate Error function value
        db_2 = dout;                                                    % derivative of b_2
        dW_2 = dout*midNuerons;                                         % derivative of W_2
        dmidNuerons = dout*W_2;
        dmid = zeros(neurons_num, 1);                                   % calculate derivative of middle layer
        for j = 1:neurons_num
            dmid(j) = midNuerons(j)*(1-midNuerons(j));                  % calculate derivative of middle layer
        end
        db_1 = dmidNuerons.*dmid;                                       % derivative of b_1
        dW_1 = dmidNuerons.*dmid*X(i);                                  % derivative of W_1
        dW_1 = dW_1 * updating_rate;                                    % regulation of derivative
        dW_2 = dW_2 * updating_rate;
        db_1 = db_1 * updating_rate;
        db_2 = db_2 * updating_rate;
        W_1 = W_1 - dW_1;                                               % updating parameters
        W_2 = W_2 - dW_2;
        b_1 = b_1 - db_1;
        b_2 = b_2 - db_2; 
    end
    Err = Err / data_size / 2;
end

%% result processing, two graphs are drawn and saved, one is a scatter graph the other is a plot graph
fitY = zeros(data_size, 1);

for i = 1:data_size
    mid = zeros(neurons_num, 1);
    for j = 1:neurons_num
        mid(j) = 1/(1+exp(-(W_1(j)*X(i)+b_1(j))));
    end
    fitY(i) = 1/(1+exp(-(W_2.'*mid+b_2)));
end
figure,
scatter(X, Y, 'b');
hold on;
scatter(X, fitY, 'r');
title('compare of origin data and fit data');
xlabel('X');
ylabel('Y');
legend('origin points', 'fitted points');
saveas(gcf, 'scatter_graph', 'jpg');

[X, index] = sort(X);
Y = Y(index);
for i = 1:data_size
    mid = zeros(neurons_num, 1);
    for j = 1:neurons_num
        mid(j) = 1/(1+exp(-(W_1(j)*X(i)+b_1(j))));
    end
    fitY(i) = 1/(1+exp(-(W_2.'*mid+b_2)));
end
figure,
plot(X, Y, 'b');
hold on;
plot(X, fitY, 'r');
title('compare of origin data and fit data');
xlabel('X');
ylabel('Y');
legend('origin function', 'fitted function');
saveas(gcf, 'plot_graph', 'jpg');