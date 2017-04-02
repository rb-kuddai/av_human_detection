
% load the background image.
Imback = double(imread('DATA1/bgframe.jpg', 'jpg'));
[MR,MC,Dim] = size(Imback);

% loop over all images
global plot_original_img plot_cleaned_img plot_no_bg plot_no_guy 
global plot_main_blobs plot_center_masses plot_only_blob_plots plot_person_histograms
plot_original_img=0; % open the original image
plot_cleaned_img=0; % show the cleaned images
plot_no_bg=0; % show images with background removed
plot_no_guy=0; % cutting the stationary guy and small shadow on the left
plot_main_blobs=0; % display 4 persons main blobs
plot_center_masses=0; % display original images plus detection circles
plot_only_blob_plots=0; % displays which Number of blobs after being cropped
plot_person_histograms=1; % display the histogram of each person with the image itself
% adjust the i based on the enumeration of the images
edges = [0, 20, 50, 90, 256];
for i = 110 : 319
    
  % load image
  Im = (imread(['DATA1/frame',int2str(i), '.jpg'],'jpg'));  
  % display image
  plot_img(plot_original_img, Im);
  Imwork = double(Im);

  % extract people
  binary_mask_img = clean_image(Imwork,Imback);
  [stats, blobs, num_blobs] = extract_people(binary_mask_img);
  if num_blobs==0
    continue
  end
  
  % crop the people from the pictures by masking the blobs on top
  % find the centre of mass and a radius (the further away point of the
  % blob)
  if plot_center_masses > 0
    figure(plot_center_masses);
    plot_target_circles(stats, Im);
  end
  
  % crop around the blob
  %size equals to the number of detected people in the current frame
  [cropped_images] = crop_blobs(Im, blobs);
  
  % display 
  if plot_only_blob_plots > 0
    plot_img(plot_only_blob_plots, cropped_images{plot_only_blob_plots});
  end
  
  % compute the color histogram for the initial frame
  % parameterize this
  if(i == 110)
    initial_histograms = {numel(cropped_images)};
    axises = {numel(cropped_images)};
    red = {numel(cropped_images)};
    green = {numel(cropped_images)};
    blue = {numel(cropped_images)};
    for person=1:numel(cropped_images)
      % compute normalised histograms for this image
      % r1, g1, b1 - Nx3
      [r1, g1, b1] = rgbhist(cropped_images{person},0,1, edges); 
      % concat 3 channels into single histograms
      hist1 = [r1' g1' b1']; % 3xN matrix
      % normalise as 3 histograms have now been combined
      hist1 = hist1 / 3;
      % assign the histogram to the person
      initial_histograms{person} = hist1;
      axisYmax = max(max(r1), max(max(g1), max(b1)));
      axises{person} = axisYmax;
      red{person} = r1;
      green{person} = g1;
      blue{person} = b1;
    end
    figure(110);
    imshow(cropped_images{3});
    %bhattacharyyaDistance = bhattacharyya(initial_histograms{4}, initial_histograms{4})
  
    if plot_person_histograms > 0
      %axisYmax = max(max(r1), max(max(g1), max(b1)));
      %axisYmax = max(axisYmax, max(max(r2), max(max(g2), max(b2))));

      figure(plot_person_histograms);
      set(1, 'Name', 'RGB Histogram');
      for image_id=1:numel(cropped_images)
        % show the image on the left
        subplot(numel(cropped_images), 2, 2*image_id-1);
        hold on
        imshow(cropped_images{image_id});
        xlabel(strcat('Image ',num2str(image_id)));
        
        % show the plot on the right
        subplot(numel(cropped_images), 2, 2*image_id);
        hold on
        plot(red{image_id}, 'red')
        plot(green{image_id}, 'green')
        plot(blue{image_id}, 'blue')
        %axis([0, 256, 0, axises{image_id}])
        xlabel(strcat('Red NHistogram -  Image ', num2str(image_id)));
        
%         subplot(numel(cropped_images), 4, 4*image_id-3);
%         imshow(cropped_images{image_id});
%         xlabel(strcat('Image ',num2str(image_id)));
%         
%         % show the histogram on the right
%         subplot(numel(cropped_images), 4, 4*image_id-2);
%         histogram(red{image_id}, 8, 'FaceColor', [1 0 0], 'EdgeColor', 'w');
%         xlabel(strcat('Red NHistogram -  Image ', num2str(image_id)));
%         
%         subplot(numel(cropped_images), 4, 4*image_id-1);
%         histogram(green{image_id}, 8, 'FaceColor', [0 1 0], 'EdgeColor', 'w');
%         xlabel(strcat('Red NHistogram -  Image ', num2str(image_id)));
%         
%         subplot(numel(cropped_images), 4, 4*image_id);
%         histogram(blue{image_id}, 8, 'FaceColor', [0 0 1], 'EdgeColor', 'w');
%         xlabel(strcat('Red NHistogram -  Image ', num2str(image_id)));
      end
    end
  end
  
  if(i == 126)
    initial_histograms1 = {numel(cropped_images)};
    for person=1:numel(cropped_images)
      % compute normalised histograms for this image
      [r1, g1, b1] = rgbhist(cropped_images{person},0,1, edges); % r1, g1, b1 - Nx3
      % concat 3 channels into single histograms
      rgbhist_output = size([r1, g1, b1])
      hist1 = [r1' g1' b1']; % 3xN matrix
      hist1_size = size(hist1)
      % normalise as 3 histograms have now been combined
      hist1 = hist1 / 3;
      % assign the histogram to the person
      initial_histograms1{person} = hist1;
    end
    
    figure(126);
    imshow(cropped_images{2});
    bhattacharyyaDistance = bhattacharyya(initial_histograms{3}, initial_histograms1{3})
  end
  
  
  % if we have the image, plot the radius of the ball on top of the image.
  %if fig1 > 0
  % figure(fig1)
  % hold on
  % for c = -0.97*radius: radius/20 : 0.97*radius
  %   r = sqrt(radius^2-c^2);
  %   plot(cc(i)+c,cr(i)+r,'g.')
  %   plot(cc(i)+c,cr(i)-r,'g.')
  % end
   %eval(['saveas(gcf,''TRACK/trk',int2str(i-1),'.jpg'',''jpg'')']);  
  %end

      %pause(0.3)
end

%show positions
%if fig4 > 0
%  figure(fig4)
%  hold on
%  clf
%  plot(cc,'r*')
%  plot(cr,'g*')
%end
