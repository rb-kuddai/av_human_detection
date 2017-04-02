function [hist] = calc_hist(binary_mask,  img, edges)
  %computing color histograms
  mask_vect = reshape(binary_mask, [], 1);
  non_bg_zero_ids = find(mask_vect);

  red_chnl_raw   = reshape(img(:, :, 1), [], 1);
  green_chnl_raw = reshape(img(:, :, 2), [], 1);
  blue_chnl_raw  = reshape(img(:, :, 3), [], 1);

  %roughly pixel are of the person
  num_person_pixels = numel(non_bg_zero_ids);

  red_chnl   = red_chnl_raw(non_bg_zero_ids);
  green_chnl = green_chnl_raw(non_bg_zero_ids);
  blue_chnl  = blue_chnl_raw(non_bg_zero_ids);    

  histR = histc(red_chnl,edges);   
  histG = histc(green_chnl,edges);   
  histB = histc(blue_chnl,edges);
  
  %normalize each channel to 1
  histR = histR / num_person_pixels;
  histG = histG / num_person_pixels;
  histB = histB / num_person_pixels;
  hist = [histR, histG, histB];%[histR, histG, histB];
  %normalize it as whole to 1
  hist = hist ./ size(hist,2);
end

