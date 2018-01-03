%% function of filling the map array
% Used to fill prediction result under some situation
% Input: 
%   current_depth: used to decide which map indice to fill
%   position: used to decide which map indice to fill
%   result: the result that needs to fill
%   map: the map of prediction
% Output:
%   map: the filled map
function [map] = fillResult(current_depth, tree_depth, position, result, map)
if current_depth>tree_depth
    map(position) = result;
else
    [map] = fillResult(current_depth+1, tree_depth, position*2, result, map);
    [map] = fillResult(current_depth+1, tree_depth, position*2+1, result, map);
end
