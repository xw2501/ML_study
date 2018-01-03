load('locs.mat');
cities = {'BOS', 'NYC', 'DC', 'MIA', 'CHI', 'SEA', 'SF', 'LA', 'DEN'};
figure,
text(pos(:, 1)+15, pos(:, 2), cities);
hold on;
c = linspace(1, 10, 9);
scatter(pos(:, 1), pos(:, 2), [], c, 'filled');
xlim([min(min(pos))-200 max(max(pos))+200]);
ylim([min(min(pos))-200 max(max(pos))+200]);