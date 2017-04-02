function [blob2person] = calc_greedy_matches(people_color_hists, blob_color_hists)
  %calculates greedily the best mathc of blobs to 
  %people based on color histograms
  num_people = size(people_color_hists, 1);
  blob2person = zeros(num_people, 1);
  %table of matches
  %1st column - color distance (bhattacharyya)
  %2nd column - person id
  %3th column - blob id
  %4th column - presence flag 
  matches = zeros(num_people * num_people, 4);
  for person_id=1:num_people
      person_hist = people_color_hists{person_id};
      %flatten matrix to 1xN vector
      person_color_vect = reshape(person_hist, 1, []);
      for blob_id=1:num_people
          blob_hist = blob_color_hists{blob_id};
          blob_color_vect = reshape(blob_hist, 1, []);
          row = (person_id - 1) * num_people + blob_id;
          color_dist = bhattacharyya(person_color_vect, blob_color_vect);
          matches(row, 1) = color_dist;
          matches(row, 2) = person_id;
          matches(row, 3) = blob_id;
          matches(row, 4) = 1;
      end
  end
  %sort rows in ascending order by color distance
  matches = sortrows(matches, 1);
  %keep finding matches until all blobs and people are connected
  while any(matches(:, 4) > 0)
      %find row with smallest distance among remaing ones
      row_id = find(matches(:,4), 1);
      person_id = matches(row_id, 2);
      blob_id = matches(row_id, 3);
      blob2person(blob_id) = person_id;
      %mark the matched pairs, remove them 
      %from future matching
      same_person = matches(:,2)==person_id;
      same_blob = matches(:,3)==blob_id;
      matches(same_person, 4)=0;
      matches(same_blob, 4)=0;
  end
end

