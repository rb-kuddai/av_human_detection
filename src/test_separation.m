
load('test_155.mat');

%imshow();
s = stats(2);
I = cropped_imgs{2};
[yy, xx] = ndgrid((1:size(I,1)), (1:size(I,2)));
teta = 180 - s.Orientation;
a = cosd(teta);
b = sind(teta);
%centroid local
cl = s.Centroid - s.BoundingBox(1:2)
%I(round(cl(2)), round(cl(1)), :) = 255; 
size(I)
mjLen = s.MajorAxisLength
mjAxis = [a * mjLen, b * mjLen]
%center below
cb = cl - mjAxis * 0.5 * 0.5 * 0.8;
d = a * cl(1) + b * cl(2);
mask = uint8((xx.*a + yy.*b) - d < 0);
croppedImage = uint8(zeros(size(I)));
croppedImage(:,:,1) = I(:,:,1).*mask;
croppedImage(:,:,2) = I(:,:,2).*mask;
croppedImage(:,:,3) = I(:,:,3).*mask;
figure(1);
imshow(croppedImage);
hold on;
plot(cb(1), cb(2), 'b*');
hold off;

ca = cl + mjAxis * 0.5 * 0.5 * 0.8;
mask2 = uint8((xx.*a + yy.*b) - d > 0);
croppedImage2 = uint8(zeros(size(I)));
croppedImage2(:,:,1) = I(:,:,1).*mask2;
croppedImage2(:,:,2) = I(:,:,2).*mask2;
croppedImage2(:,:,3) = I(:,:,3).*mask2;

figure(2);
imshow(croppedImage2);
hold on;
plot(ca(1), ca(2), 'b*');
hold off;
figure(3);
imshow(I);



% [fa, mask_a, fb, mask_b] = separate_two(size(I), s);
% fla = fa - s.BoundingBox(1:2);
% flb = fb - s.BoundingBox(1:2);
% show_mask_img(1, I, mask_a & 1);
% hold on;
% plot(fla(1), fla(2), 'r*');
% hold off;
% show_mask_img(2, I, mask_b);
% hold on;
% plot(flb(1), flb(2), 'b*');
% hold off;
