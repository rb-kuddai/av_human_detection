function [stats, hists, people_binary_img] = extract_people(cleaned_binary_img, raw_stats, cropped_images, bg_img, edges)
  %color histograms
  hists = cell(size(raw_stats,1), 1);
  BG_INTENSITY_THRESHOLD = 20; % used for bg removal
  MIN_PERSON_AREA = 150;
  % used for debugging and evaluation of the area which people take
  people_binary_img = zeros(size(cleaned_binary_img)); 
   
  for person_id = 1:size(raw_stats,1)
    bbox = raw_stats(person_id).BoundingBox;
    [start_x, start_y, end_x, end_y] = bbox2imgsize(bbox);
    %applying binary mask which will separate people in one blob
    person_mask = cleaned_binary_img(start_y:end_y, start_x:end_x) & raw_stats(person_id).Mask;
    %save mask value in order to preserve area if it shrinks too much
    tmp = person_mask;
    
    %substracting background once more in order to obtain
    %better contour of the person and more precise color distribution
    croped_img = double(cropped_images{person_id});
    croped_bkg = bg_img(start_y:end_y, start_x:end_x, :);
    croped_bkg = (abs(croped_img(:,:,1) - croped_bkg(:,:,1)) > BG_INTENSITY_THRESHOLD) ...
                |(abs(croped_img(:,:,2) - croped_bkg(:,:,2)) > BG_INTENSITY_THRESHOLD) ...
                |(abs(croped_img(:,:,3) - croped_bkg(:,:,3)) > BG_INTENSITY_THRESHOLD);
    
    person_mask = person_mask & croped_bkg;
    %here we don't allow person to shrink too much
    %nnz give numbe of white pixels -> basically area
    if nnz(person_mask) < MIN_PERSON_AREA
        person_mask = tmp;
    end
    
    %erode and dilate with different brushes to obtain
    %better contours
    tmp = person_mask;
    person_mask = imerode(person_mask, strel('disk', 3));
    person_mask = imdilate(person_mask, strel('disk', 1));
    
    if nnz(person_mask) < MIN_PERSON_AREA
        person_mask = tmp;
    end
    
    %filling possible holes in the person
    person_mask = bwconvhull(person_mask);
    
    %update person parameters after filtering
    % get local center of mass
    [xcentre_local, ycentre_local] = calc_center_binary_img(person_mask);
    %switch to global coordinates using bounding box position as
    %it determines local coordinate system position
    raw_stats(person_id).Centroid = [xcentre_local, ycentre_local] + bbox(1:2);
    raw_stats(person_id).Area = nnz(person_mask);
    
    %save the resulting binary mask via logical addition
    %allows to see resulting people contours
    people_binary_img(start_y:end_y, start_x:end_x) = people_binary_img(start_y:end_y, start_x:end_x) | person_mask;
    
    %computing color histograms
    hists{person_id} =  calc_hist(person_mask, croped_img, edges);
  end
  %update people stats with new more precise area and positions
  stats = raw_stats;
end

