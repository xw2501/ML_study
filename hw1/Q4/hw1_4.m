% as function f(x) = (x-3)^2 + exp(x)
% the corresponding devrivation is 2(x-3) + exp(x)
% the second devrivation is 2 + exp(x)
clear all;
close all;
clc;
rand('seed',sum(100*clock));
start = randn(1, 1)*1000;                                               % start point
start
threshold = 1e-5;                                                       % threshold for halt decision
% diff = (1/(exp(start) + 2))*(2*(start - 3) + exp(start));             % step size
diff = 1 + 2*(start - 4)/(exp(start) + 2); 
cnt = 0;                                                                % loop count
while abs(diff)>threshold
    start = start - diff;
    % diff = (1/(exp(start) + 2))*(2*(start - 3) + exp(start));
    diff = 1 + 2*(start - 4)/(exp(start) + 2); 
    cnt = cnt + 1;
end
end_point = start                                                       % end point
cnt                                                                     % loop times
minimum = (end_point-3)^2 + exp(end_point)                              % minimum value