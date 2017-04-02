function [] = plot_tracked_people(stats, img, blob2person, people_markers)
    clf
    imshow(img);
    hold on;
    for blob_id=1:size(stats, 1)
      centroid = stats(blob_id).Centroid;
      radius = sqrt(stats(blob_id).Area/pi);
      ang= 0:0.01:2*pi; 
      c = radius * cos(ang);%-0.97*radius: radius/3 : 0.97*radius;
      r = radius * sin(ang);
      cc = centroid(1);
      cr = centroid(2);
      person_id = blob2person(blob_id);
      
      if person_id > 4
        'Person ID is too big'
      end
      if person_id > 0
        marker = people_markers{person_id};
        
        %plot(cc+c,cr+r, marker);
        plot(cc+c,cr+r, marker);
      end
    end
    hold off;
    drawnow;
end