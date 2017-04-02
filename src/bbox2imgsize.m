function [start_x, start_y, end_x, end_y] = bbox2imgsize(bbox)
  %bbox - bounding box
  %so bounding box to image size (accounting all upper 
  %and lower bounds properly)
  start_x = floor(bbox(1));
  start_y = floor(bbox(2));
  end_x = start_x + ceil(bbox(3));
  end_y = start_y + ceil(bbox(4));
end

