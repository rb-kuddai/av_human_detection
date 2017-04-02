Imback = double(imread('DATA1/frame110.jpg', 'jpg'));
[MR,MC,Dim] = size(Imback);
increase_contrast = @(I) ((I.^1.3)./(255^1.3)) .* 255;
h = fspecial('gaussian', 5, 1);
%h = fspecial('disk', 1.5);
%gauss = @(I) imfilter(I, h,'replicate');
apply_fltr = @(I) imfilter(increase_contrast(I), h,'replicate');

Imback_contrast = apply_fltr(Imback);
figure;
imshow(uint8(Imback_contrast));
figure;
imshow(uint8(Imback));
%
%h = fspecial('disk', 2);
%h = fspecial('gaussian', 5, 1);
%figure;
%imshow(imfilter(uint8(Imback_contrast),h,'replicate'));