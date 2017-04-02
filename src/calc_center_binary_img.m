function [ xcentre, ycentre ] = calc_center_binary_img(I)
%I - binary image
%remember that image first size is height and second is width
[xx, yy] = meshgrid(1:size(I, 2), 1:size(I, 1));
weightedx = xx .* I;
weightedy = yy .* I;
xcentre = sum(weightedx(:)) / sum(I(:));
ycentre = sum(weightedy(:)) / sum(I(:));
end

