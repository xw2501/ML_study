%% function of building the decision tree
% Used to build a decision tree according to input data and return the tree
% structure.
% Input:
%       data_set: the training data as it is already reshaped by labels,
%                 labels of data set is not required in this function
%       tree_depth: target depth of decision tree
%       features: an empty array to save features data
%       threshold: an empty array to save threshold data
%       map: an empty array to save predictions 
%       current depth: the tree building process is done in a recursive
%                      way, thus current depth is the building progress of decision tree
%       position: position(index) of current node, used to access features,
%                 threshold array
% Output:
%       features: array of features
%       threshold: array of corresponding thresholds
%       map: array of prediction results
function [features, threshold, map] = build_tree(data_set, tree_depth, features, threshold, map, current_depth, position)

temp_ent = 100;
num_classes = 10;

% size(data_set)

mu = zeros(num_classes, 9);
num = zeros(1, num_classes);


for i = 1:num_classes    % calculate mean value of each label to decide start point end end point of threshold candidates
    num(i) = length(find(sum(data_set(:,:,i), 2)~=0));
    if num(i)==0
        mu(i, :) = 0;
    else
        mu(i, :) = sum(data_set(:, :, i)) / num(i);
    end
end

for j = 1:9     % find the feature and threshold that mostly reduces uncertainty
    for k = min(mu(:, j)):1:max(mu(:, j))
        P = zeros(1, num_classes);
        for kk = 1:num_classes
            P(kk) = length(find(data_set(:, j, kk)>=k));
        end
        P = P / sum(P);
        ent = 0;
        for kk = 1:num_classes
            if P(kk)==0
                continue;
            end
            ent = ent - P(kk) * log(P(kk));
        end
        if ent<temp_ent
            temp_ent = ent;
            features(position) = j;
            threshold(position) = k;
        end
    end
end

greater_num = zeros(1, num_classes);
for i = 1:num_classes    % find number of data points that has a value of feature greater than and smaller than threshold
    greater_num(i) = length(find(data_set(:, features(position), i)>=threshold(position)));
end
smaller_num = num - greater_num;

% According to current depth, greater_num and smaller_num to decide next step.
% If current depth == tree depth, fill the corresponding map indice with
%   prediction value. Prediction value are given by greater_num and
%   smaller_num
% Else, action of next step decides on greater_num and smaller_num.
%   If greater_num or smaller_num has only one label, fill that subtree
%   with zero features and threshold representing going any subsequential
%   subtree is ok. And fill the map indice with this label.
%   Else go to next depth and repeat this process.
if current_depth==tree_depth
    if(sum(greater_num)==0)
       temp = find(smaller_num==max(smaller_num));
       map(position*2) = temp(1);
       map(position*2+1) = map(position*2);
    else if(sum(smaller_num)==0)
            temp = find(greater_num==max(greater_num));
            map(position*2+1) = temp(1);
            map(position*2) = map(position*2+1);
        else
            temp = find(greater_num==max(greater_num));
            map(position*2+1) = temp(1);
            temp = find(smaller_num==max(smaller_num));
            map(position*2) = temp(1);
        end
    end
else
    data_set_greater = zeros(max(greater_num), 9, num_classes);
    data_set_smaller = zeros(max(smaller_num), 9, num_classes);
    for i = 1:num_classes
        for j = 1:num(i)
            if data_set(j, features(position), i)>=threshold(position)
                data_set_greater(min(find(sum(data_set_greater(:,:,i),2)==0)), :, i) = data_set(j, :, i);
            else
                data_set_smaller(min(find(sum(data_set_smaller(:,:,i),2)==0)), :, i) = data_set(j, :, i);
            end
        end
    end
    if size(data_set_smaller, 1)==0
        data_set_smaller = data_set_greater;
    end
    if size(data_set_greater, 1)==0
        data_set_greater = data_set_smaller;
    end
    if length(find(greater_num~=0))==1
        [map] = fillResult(current_depth+1, tree_depth, position*2+1, find(greater_num~=0), map);
    else
        [features, threshold, map] = build_tree(data_set_greater, tree_depth, features, threshold, map, current_depth+1, position*2+1);
    end
    if length(find(smaller_num~=0))==1
        [map] = fillResult(current_depth+1, tree_depth, position*2, find(smaller_num~=0), map);
    else
        [features, threshold, map] = build_tree(data_set_smaller, tree_depth, features, threshold, map, current_depth+1, position*2); 
    end
end
return;