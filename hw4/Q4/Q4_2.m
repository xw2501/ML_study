dis = [0, 206, 429, 1504, 963, 2976, 3095, 2979, 1949;
    206, 0, 233, 1308, 802, 2815, 2934, 2786, 1771;
    429, 233, 0, 1075, 671, 2684, 2799, 2631, 1616;
    1504, 1308, 1075, 0, 1329, 3273, 3053, 2687, 2037;
    963, 802, 671, 1329, 0, 2013, 2142, 2054, 996;
    2976, 2815, 2684, 3273, 2013, 0, 808, 1131, 1307;
    3095, 2934, 2799, 3053, 2142, 808, 0, 379, 1235;
    2979, 2786, 2631, 2687, 2054, 1131, 379, 0, 1059;
    1949, 1771, 1616, 2037, 996, 1307, 1235, 1059, 0];  % distsnce data
seed = 120;
rng(seed);
pos = random('norm', 500, 100, [9, 2]); % generate initial position randomly
pos_ = random('norm', 0, 100, [9, 2]);  % generate initail updating position randomly
threshold = 1e-5;   % stop threshold
step = 1e-2;    % updating threshold

while sum(sum(abs(pos_)))>threshold
    for i = 1:9
        pos_(i, 1) = 0;
        pos_(i, 2) = 0;
        for j = 1:9
            if j==i
                continue;
            end
            pos_(i, :) = pos_(i, :) + 2*(norm(pos(i, :)-pos(j, :))-dis(i, j))*(pos(i, :)-pos(j, :))/norm(pos(i, :)-pos(j, :));    % compute the updating value
        end
    end
    for i = 1:9
        pos(i, :) = pos(i, :) - pos_(i, :)*step;    % update the position
    end
end

save('locs.mat', 'pos');    % save the final result