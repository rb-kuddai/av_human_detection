%D(i, j) - distance between person i previous position 
%and blob j current position
D =  zeros(4, 4);
blobs = [[0, 0]; [0, 3]; [3, 0]; [3, 3]];
people = blobs + 1;
 for i = 1:4
   for j = 1:4
     D(i, j) = sqrt(sum((people(i, :) - blobs(j)) .^ 2));
   end
 end
D
variants = perms([1 2 3 4])
total_dists = zeros(size(variants, 1), 1);
for k = 1:size(variants, 1)
  for i = 1:4
    j = variants(k, i);
    total_dists(k) = total_dists(k) + D(i, j);
  end
end
[cumulative_dist, variant_id] = min(total_dists)
variants(variant_id, :)