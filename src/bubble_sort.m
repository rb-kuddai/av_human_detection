function [ sorted_stats, ids] = bubble_sort(stats)
    % bubble sort (large to small) on regions in case there are more than 1
    N = size(stats, 1);
    ids = zeros(N);
    for i = 1 : N
        ids(i) = i;
    end
    for i = 1 : N-1
        for j = i+1 : N
          if stats(i).Area < stats(j).Area
            tmp = stats(i);
            stats(i) = stats(j);
            stats(j) = tmp;
            tmp = ids(i);
            ids(i) = ids(j);
            ids(j) = tmp;
          end
        end
    end
    sorted_stats = stats;
end

