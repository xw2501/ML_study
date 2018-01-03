img = imread('usa-major-cities-map.jpg');
load('locs.mat');
load('locs_des.mat')
homography = computeHomography(pos, pos_des);
pos_t = applyHomography(homography, pos);
figure, imshow(rgb2gray(img));
hold on;
scatter(pos_t(:, 1), pos_t(:, 2), 'r', 'd','filled');
