function [fa, mask_a, fb, mask_b] = separate_two(img_size, s)
%img - cropped image containing two people,
%s - stat struct containing 'Area', 'Centroid', 'BoundingBox', 'MajorAxisLength', 'Orientation'
%return fa - global position of fist person, fb - global position of second
%person. mask_a, mask_b - image offsets of size I. 

%small space between separated people
SPACE = 2;

%y an x vice versa because image first dimension is height
%http://stackoverflow.com/questions/19992097/how-to-do-circular-crop-using-matlab
[yy, xx] = ndgrid((1:img_size(1)), (1:img_size(2)));
%flip orientation due to the same reason
teta = 180 - s.Orientation;
box_pos = s.BoundingBox(1:2);
a = cosd(teta);
b = sind(teta);
%centroid local
cl = s.Centroid - box_pos;

d = a * cl(1) + b * cl(2);
mjLen = s.MajorAxisLength;
%major axis vector
%0.5 * 0.5 because axis by half and then middle of that
mjAxis = [a * mjLen, b * mjLen] * 0.5 * 0.5;

%b - below, a - above
%mask size of I, using normalized equation of the line
mask_a = uint8(((xx.*a + yy.*b) - d) >  SPACE);
mask_b = uint8(((xx.*a + yy.*b) - d) < -SPACE);
%focus local
fla = cl + mjAxis;
flb = cl - mjAxis;
%focus global
fa = fla + box_pos;
fb = flb + box_pos;
end

