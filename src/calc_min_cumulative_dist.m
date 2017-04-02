function [cumulative_dist, person2blob_pos_estim] = calc_min_cumulative_dist(people_pos, blobs_pos)
  %best_variant is 4 vector mapping person id to best blob id 
  %(from distance point of view)

  %D(person_id, blob_id) - distance between person i previous position 
  %and blob j current position
  D =  zeros(4, 4);
  for person_id = 1:4
   for blob_id = 1:4
     D(person_id, blob_id) = sqrt(sum((people_pos(person_id, :) - blobs_pos(blob_id, :)) .^ 2));
   end
  end
  
  %all possible variants - permutations between blobs and people
  variants = perms([1 2 3 4]);
  total_dists = zeros(size(variants, 1), 1);
  for variant_id = 1:size(variants, 1)
    for person_id = 1:4
      blob_id = variants(variant_id, person_id);
      total_dists(variant_id) = total_dists(variant_id) + D(person_id, blob_id);
    end
  end
  
  [cumulative_dist, min_variant_id] = min(total_dists);
  person2blob_pos_estim = variants(min_variant_id, :);
end

