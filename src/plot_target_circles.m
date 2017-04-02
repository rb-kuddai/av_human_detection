function [] = plot_target_circles(stats, img)
    clf
    imshow(img);
    hold on;
    for j=1:size(stats, 1)
      centroid = stats(j).Centroid;
      radius = sqrt(stats(j).Area/pi);
      ang= 0:0.01:2*pi; 
      c = radius * cos(ang);%-0.97*radius: radius/3 : 0.97*radius;
      r = radius * sin(ang);
      cc = centroid(1);
      cr = centroid(2);
      plot(cc+c,cr+r,'g.');
      plot(cc+c,cr-r,'g.');
    end
    hold off;
    drawnow;
end

