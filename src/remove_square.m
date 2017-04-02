%cutting stationary person (5th one)
%removes square region from the image (img)
%x, y - the coordinates of square center
%length - the length of the square
function [result] = remove_square(img, x, y, length)
  half = length/2;
  h = size(img, 1);
  w = size(img, 2);
  x_start = max(x - half,1);
  x_end   = min(x + half,w);
  y_start = max(y - half,1);
  y_end   = min(y + half,h);
  img(y_start:y_end, x_start:x_end,:) = 0;
  result = img;
end

