% extracts people
function selected=clean_image(Imwork,Imback)
  global plot_cleaned_img plot_main_blobs plot_no_bg plot_no_guy
  
  % THRESHOLD - the value difference between the foreground and the
  % background
  bg_intensity_threshold = 15;

  % subtract background & select pixels with a big difference
  fore = (abs(Imwork(:,:,1)-Imback(:,:,1)) > bg_intensity_threshold) ...
     | (abs(Imwork(:,:,2) - Imback(:,:,2)) > bg_intensity_threshold) ...
     | (abs(Imwork(:,:,3) - Imback(:,:,3)) > bg_intensity_threshold);
  plot_img(plot_no_bg, fore);
  
  %removes the left wall completely and the shadow 
  %that might appear there
  %cutting_wall_threshold = 125;
  %fore(:,1:cutting_wall_threshold,:) = 0;     
  
  %cutting the 5th stationary person at 150, 223 
  %(he is moving that is why we are removing slightly bigger area)
  fore = remove_square(fore, 170, 170, 170);
  plot_img(plot_no_guy, fore);
  foremm = imerode(fore, strel('disk', 1));
  foremm = imdilate(foremm, strel('disk', 4));

  % show the cleaned images
  plot_img(plot_cleaned_img, foremm);
  
  % select largest object
  labeled = bwlabel(foremm,8); % 4 - vertical, horizontal clustering
  stats = regionprops(labeled,['basic']);
  N = size(stats, 1);
  if N < 1
    success = 0;
    return %no large objects - nothing to work with  
  end
  
  %sort by stats(i).Area
  [stats, ids] = bubble_sort(stats);
  %first one is the biggest one
  % make sure that there is at least 1 big region
  if stats(1).Area < 100 
    return
  end
  
  %take big regions above the area_threshold
  area_threshold = 150;
  selected = labeled==ids(1);
  
  for i = 2 : size(stats, 1)
      if stats(i).Area < area_threshold
          %can interrupt because stats was sorted by area
          break; 
      end
      selected = selected + (labeled==ids(i));
  end
  
  % after we combine the labels, expand them a wee bit to
  % to fill holes in people  
  selected = imdilate(selected, strel('disk', 4));
  selected = imerode(selected, strel('disk', 4));
  plot_img(plot_main_blobs, selected);
end
