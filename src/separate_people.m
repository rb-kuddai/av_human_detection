function [f_stats, cropped_imgs, success] = separate_people(cleaned_binary_img, real_img)
  %f_stats - final statistic.
  labeled = bwlabel(cleaned_binary_img, 8); % 8 - vertical, horizontal clustering
  stats = regionprops(labeled, 'Area', 'Centroid', 'BoundingBox', 'MajorAxisLength', 'Orientation');
  
  f_stats = [struct(); struct(); struct(); struct()];
  cropped_imgs = cell(4, 1);
  num_blobs = size(stats, 1);
  
  blobs_areas = ones(num_blobs, 2); 
  %concatinate to vector
  blobs_areas(:,1) = cat(1,stats.Area);
  %original indeces
  blobs_areas(:,2) = 1:size(stats,1);
  %ascending sorting
  blobs_areas = sortrows(blobs_areas, -1);
  blobs_indices = blobs_areas(:, 2);
  
  man_id = 1;
  %relying on the description that there are 4 persons
  blobs_to_split = 4 - num_blobs;
  if blobs_to_split > 2 || num_blobs > 4 
    success = 0;
    return
  end
  
  for i = 1:num_blobs
    stat_id = blobs_indices(i);
    s = stats(stat_id);
    [start_x, start_y, end_x, end_y] = bbox2imgsize(s.BoundingBox);
    cropped_img = real_img(start_y:end_y, start_x:end_x, :);
    if blobs_to_split == 0
      %just copying existing values
      f_stats(man_id).Area = s.Area;
      f_stats(man_id).Centroid = s.Centroid;
      %mask is one, everything remains
      f_stats(man_id).Mask = 1;
      f_stats(man_id).BoundingBox = s.BoundingBox;
      
      cropped_imgs{man_id} = cropped_img;
    else
      %splitting ellipsoid which bounds two people
      %a - above, b - below
      %f means fokal points of the ellipsis
      [fa, mask_a, fb, mask_b] = separate_two(size(cropped_img), s);
      halfArea = s.Area * 0.5;
      %saving informaton about parts
      f_stats(man_id).Area = halfArea;
      f_stats(man_id).Centroid = fa;
      f_stats(man_id).Mask = mask_a;
      f_stats(man_id).BoundingBox = s.BoundingBox;
      cropped_imgs{man_id} = cropped_img;
      
      man_id = man_id + 1;
      
      f_stats(man_id).Area = halfArea;
      f_stats(man_id).Centroid = fb;
      f_stats(man_id).Mask = mask_b;
      f_stats(man_id).BoundingBox = s.BoundingBox;
      cropped_imgs{man_id} = cropped_img;
      
      blobs_to_split = blobs_to_split - 1;
    end
    man_id = man_id + 1;
  end
  success = 1;
end

