load('test_155.mat');
[f_stats, cropped_imgs] = separate_people(binary_mask_img, Im);
for i = 1:size(cropped_imgs, 1)
  s = f_stats(i);%one stat
  %focus local coordinates
  fl = s.Centroid - s.BoundingBox(1:2);
  img = cropped_imgs{i};
  mask = s.Mask;
  show_mask_img(i, img, mask);
  hold on;
  plot(fl(1), fl(2), 'r*');
  hold off;
end