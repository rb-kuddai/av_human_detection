function [] = plot_img(yes_id, img)
  if yes_id > 0
    figure(yes_id)
    clf
    imshow(img)
    %eval(['imwrite(uint8(fore),''BGONE/nobg',int2str(index),'.jpg'',''jpg'')']);  
  end 
end

