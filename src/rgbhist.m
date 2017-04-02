% computes the histogram of a given colour image as histograms
% of each of the R, G and B channels.
%
% assumes pixel range 0->255 for each channel
%
% values less than 0 go into bin 1, values bigger than 255
% go into bin 255
%
% if show=0, then don't show. Otherwise show in figure(show)
% if normalize=1, normalize returned histogram ranges to 0->1. 
%
% usage : [histR, histG, histB] = rgbhist(RGBImage,show, normalize)
%
% T.Breckon 1/3/05 (based on code by Bob Fisher)

function [r, g, b] = rgbhist(RGBImage,show, normalize, edges)

  % set up bin edges for histogram
  
  %zeros(256,1);
  %for i = 1 : 256;
  %  edges(i) = i-1;
  %end

  % get image dimensions

  [R,C,colourDepth] = size(RGBImage);
  if (colourDepth ~= 3)
    display 'Error: image not an RGB image'
    return
  end
  imagepixels = R*C;
  
  % turn each image channel into long array and do histogram
  
  imagevec = reshape(RGBImage(:,:,1),1,imagepixels);      
  histR = histc(imagevec,edges)';                 
  imagevec = reshape(RGBImage(:,:,2),1,imagepixels);      
  histG = histc(imagevec,edges)';
  imagevec = reshape(RGBImage(:,:,3),1,imagepixels);      
  histB = histc(imagevec,edges)';
 
  % normalise histogram bins by image size - yes / no
  
  if normalize > 0
      histR = histR / imagepixels;
      histG = histG / imagepixels;
      histB = histB / imagepixels;
  end
  
  r = histR;
  g = histG;
  b = histB;
  
  % show returned result - yes / no
  
  if show > 0
      figure(show)
      clf
      hold on
      plot(histR, 'red')
      plot(histG, 'green')
      plot(histB, 'blue')
      
      axis([0, 256, 0, 1.1*max(max(histR), max(max(histG), max(histB)))]);
  end