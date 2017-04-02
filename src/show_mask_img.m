function [] = show_mask_img(flag, real_img, mask)
    %shows the image offseted by mask
    offset_img = real_img;
    binary_mask_img = uint8(mask);
    offset_img(:,:,1) = offset_img(:,:,1) .* binary_mask_img;
    offset_img(:,:,2) = offset_img(:,:,2) .* binary_mask_img;
    offset_img(:,:,3) = offset_img(:,:,3) .* binary_mask_img;
    plot_img(flag, offset_img);
end