function [] = main()
    
  global plot_original_img plot_cleaned_img plot_no_bg plot_no_guy plot_offset_img
  global plot_main_blobs plot_center_masses plot_only_blob_plots plot_person_histograms
  global plot_people_with_circles plot_masked_offset_img plot_people_binary_img
  global plot_people_img evaluation_file_name plot_trajectories_fig plot_trajectories2_fig
  plot_original_img=0; % open the original image
  plot_cleaned_img=0; % show the cleaned images
  plot_no_bg=0; % show images with background removed
  plot_no_guy=0; % cutting the stationary guy and small shadow on the left
  plot_main_blobs=0; % display 4 persons main blobs
  plot_center_masses=0; % display original images plus detection circles
  plot_only_blob_plots=0; % displays which Number of blobs after being cropped
  plot_person_histograms=0; % display the histogram of each person with the image itself
  plot_offset_img=0; % displays only the mask applied to the people
  plot_people_with_circles=1; % displays the people with circles
  plot_masked_offset_img=0; % display masked binary circles around each person
  plot_people_binary_img=0; % display background-removed blobs of people (binary)
  plot_people_img=0; % display background-removed blobs of people
  evaluation_file_name='positions1.mat'; % 4x201x2
  plot_trajectories_fig = 4; % where to plot all the trajectories
  plot_trajectories2_fig = [5,6,7,8]; % plot person1's trajectory
  
  %different images filters for easy detection using on color historgrams
  increase_contrast = @(I) ((I.^1.3)./(255^1.3)) .* 255;
  h = fspecial('gaussian', 5, 1);
  %h = fspecial('disk', 1.5);
  %gauss = @(I) imfilter(I, h,'replicate');
  apply_fltr = @(I) imfilter(increase_contrast(I), h,'replicate');
  
  % load the background image.
  background = imread('DATA1/bgframe.jpg', 'jpg');
  Imback = double(background);
  color_hist_edges = [0:255];
  first_img_id = 110;%145;%110;
  last_img_id = 319;%315;%319;
  people_color_hists = {};
  %first dimension person id, second x and y coordinates
  people_pos = zeros(4, 2); 
  %the colors assocciated with each person
  people_markers = {'r.', 'g.', 'b.', 'y.'};
  person_distances = {[],[],[],[]}; % keeps the mean distances between people
  person_trajectories_x = {[],[],[],[]}; % keeps the trajectories for people
  person_trajectories_y = {[],[],[],[]}; % keeps the trajectories for people
  truth_trajectories_x = {[], [], [], []}; % keeps the trajectories for the truth
  truth_trajectories_y = {[], [], [], []}; % keeps the trajectories for the truth
  min_cumulative_distances = [];
  frames = [first_img_id:last_img_id];
  %number of observations stored (color histograms) 
  NUM_TRACK_FRAMES = 10;
  %To determines when the frame rate does sudden jump
  JUMP_THRESHOLD = 63;
  %first axis is the person id, and the second stores the last NUM_TRACK_FRAMES
  %persons id estimated through color histograms (observations of our model)
  last_observs = zeros(4, NUM_TRACK_FRAMES); 
  
  for img_id = frames
    fprintf('image id: %1.0f\n', img_id);

    % load image
    Im = (imread(['DATA1/frame',int2str(img_id), '.jpg'],'jpg'));  
    % display image
    plot_img(plot_original_img, Im);
    Imwork = double(Im);

    cleaned_binary_img = clean_image(Imwork,Imback);
    if plot_offset_img > 0
        show_mask_img(plot_offset_img, Im, cleaned_binary_img);
    end
    
    %filtering background and working image for better color histograms
    filtered_bkg = apply_fltr(Imback);
    filtered_img = apply_fltr(Imwork);
    
    %separating blobs to unidentified people
    [raw_stats, cropped_images, success] = separate_people(cleaned_binary_img, uint8(filtered_img));
    %not success in the case when separation went wrong
    %for example, 5 blobs were detected
    if ~success
      continue;
    end
    %if success then we have 4 blobs and 4 persons
    num_people = 4;
    %caclulate color histograms of unidentified people
    %also getting more precise area and position
    [stats, blob_color_hists, people_binary_img] = extract_people(cleaned_binary_img,...
                                                                  raw_stats,...
                                                                  cropped_images,...
                                                                  filtered_bkg,...
                                                                  color_hist_edges);

    plot_img(plot_people_binary_img, people_binary_img); 
    if plot_people_img > 0
        show_mask_img(plot_people_img, Im, people_binary_img);  
    end

    if plot_center_masses > 0
      figure(plot_center_masses);
      plot_target_circles(stats, Im);
    end
    
    if plot_only_blob_plots > 0
      plot_img(plot_only_blob_plots, cropped_images{plot_only_blob_plots});
    end
    
    %creating a map from blobs to people using color histograms
    if img_id == first_img_id 
      %blob to person estimated through histograms distances
      blob2person_hist_estim = zeros(num_people, 1);
      %save initial people color hists
      people_color_hists = cell(4, 1);
      people_pos = cat(1, stats.Centroid);
      for person_id=1:4
          people_color_hists{person_id} = blob_color_hists{person_id};
          blob2person_hist_estim(person_id) = person_id;
      end
    else
      %assigns people to blobs greedily using BHATTACHARYYA color distance
      blob2person_hist_estim = calc_greedy_matches(people_color_hists, blob_color_hists);
    end
    
    %blobs positions as matrix
    blobs_pos = cat(1, stats.Centroid);
    %find such correspondence between previous people positions and current
    %blobs so the distance between such pairs is minizied. The good thing
    %that it doesn't not rely on observations (color histograms) so by that
    %value it is possible to judge about framerate jumps.
    [min_cumulative_dist, person2blob_pos_estim] = calc_min_cumulative_dist(people_pos, blobs_pos);
    %store them for plotting
    min_cumulative_distances = [min_cumulative_distances, min_cumulative_dist];
    
    is_jump = min_cumulative_dist > JUMP_THRESHOLD;
    %blob to person final estimation and updating observations
    [blob2person_finl_estim, last_observs] = tracker(blob2person_hist_estim,...
                                                         person2blob_pos_estim,...
                                                         last_observs,...
                                                         is_jump,...
                                                         NUM_TRACK_FRAMES);
                                                      
    if plot_people_with_circles > 0
        %img = uint8(apply_fltr(Imwork)); %filtered image
        plot_tracked_people(stats, Im, blob2person_finl_estim, people_markers);
    end
    
    %updating person positions
    for blob_id = 1:4
      person_id = blob2person_finl_estim(blob_id);
      people_pos(person_id, :) = blobs_pos(blob_id, :);
    end
    %pause(1);
    
    % compute the trajectories
    [person_distances, person_trajectories_x, person_trajectories_y, ...
        truth_trajectories_x, truth_trajectories_y] = evaluation(...
        first_img_id, img_id, stats, blob2person_finl_estim, ...
        people_markers, person_distances, person_trajectories_x, ...
        person_trajectories_y, truth_trajectories_x, ...
        truth_trajectories_y);
    
  end
  
  calculate_totals(person_distances, people_markers, frames);
  
  plot_trajectories(background, person_trajectories_x, person_trajectories_y,...
      truth_trajectories_x, truth_trajectories_y, people_markers);
  
  figure;
  stem(frames, min_cumulative_distances);
  xlabel('Frame');
  ylabel('Min. Cumulative Distance in pixels');
end
