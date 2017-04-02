function [blob2person_finl_estim, new_observs] = tracker(blob2person_hist_estim,...
                                                         person2blob_pos_estim,...
                                                         last_observs,...
                                                         is_jump,...
                                                         NUM_TRACK_FRAMES)
                                                       
  %The idea is that if for NUM_TRACK_FRAMES frames our position estimation
  %is in the good match with our observations via color histograms stored in
  %the last_observs matrix then we can folow our position estimation 
  %relying on the fact that the movements are continious. However, if the 
  %jump in framerate has occured then we can't rely on position estimation
  %and we use only color hystograms.
  
  %final maping between blobs and people; 
  blob2person_finl_estim = zeros(4, 1);  
  %whether we can rely on positional estimations or not
  reset_observ_flag = is_jump;
  if ~reset_observ_flag
    %no jump so person2blob_pos_estim is reliable sourse of data
    %update our observations and ensure that positions are in good
    %match with observations
    for person_id = 1:4
      blob_id = person2blob_pos_estim(person_id);
      %observer person id via color histograms
      person_id_from_observ = blob2person_hist_estim(blob_id);
      %shifting old observations to the past
      last_observs(person_id, 1:end-1) = last_observs(person_id, 2:end);
      last_observs(person_id, end) = person_id_from_observ;
      %determing the most frequent observation (color histograms)
      %in order to determine how confident we are in our current position
      observs = last_observs(person_id, :);
      observs_without_zeros = observs(observs > 0);
      most_freq_person = mode(observs_without_zeros);
      if most_freq_person ~= person_id && ~isnan(most_freq_person)
        reset_observ_flag = 1;
        fprintf('observations for person %s diverged\n', num2str(person_id));
        break;
      end
    end
    %in good match with observations so creating blob2person_finl_estim
    %based on positions estimation
    for person_id = 1:4
      blob_id = person2blob_pos_estim(person_id);
      blob2person_finl_estim(blob_id) = person_id;
    end
  end

  if reset_observ_flag
    %the big jump in positions between this and previous frames
    %have occured. Or some persons started swapping their positions. 
    %Can't trust position estimation anymore - 
    %relying on color histograms observations only
    fprintf('relying only on observatons\n');
    last_observs = zeros(4, NUM_TRACK_FRAMES); 
    blob2person_finl_estim = blob2person_hist_estim;
    for blob_id = 1:4
      person_id = blob2person_finl_estim(blob_id);
      %starting estimation from scratch we belive that this is we are.
      last_observs(person_id, end) = person_id;
    end
  end
  %updating observations
  new_observs = last_observs;
end

