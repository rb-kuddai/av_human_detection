function [ cropped_images ] = crop_blobs( real_image, binary_blobs )
%CROP_BLOBS Iterates through the blobs, finds the most left, right, top and
%bottom of each blob and crops the original image.

  cropped_images = cell(size(binary_blobs, 1), 1);
  for i = 1:size(binary_blobs,1)
    blob = binary_blobs(i,:,:);
    [rows, cols] = find(reshape(blob, size(binary_blobs, 2), size(binary_blobs, 3)));
    topRow = min(rows);
    bottomRow = max(rows);
    leftCol = min(cols);
    rightCol = max(cols);
    cropped_images{i} = real_image(topRow:bottomRow, leftCol:rightCol, :);
  end


end

