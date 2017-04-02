load('test_155.mat');

blobs_areas = ones(size(stats,1), 2);
%concatinate to vector
blobs_areas(:,1) = cat(1,stats.Area);
%original indeces
blobs_areas(:,2) = 1:size(stats,1);
%ascending sorting
blobs_areas = sortrows(blobs_areas, -1);
blobs_areas
blobs_areas(:, 2)
