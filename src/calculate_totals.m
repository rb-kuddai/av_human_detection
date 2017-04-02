function [] = calculate_totals( person_distances, people_markers, frames )
%Calculates statistics based on observations

    false_positives = {0, 0, 0, 0};    
    % convert the frames
    total_frames = size(frames,2);
    for person=1:size(person_distances,2)
        mean_distance = mean(person_distances{person});
        total_correct = size(person_distances{person},2);
        false_positives{person} = total_frames - total_correct;
        disp(['Person ', people_markers{person}, ' has ', num2str(false_positives{person}), ' wrong locations and a mean distance of ', num2str(mean_distance)]);
    end
    total_false_positives = [false_positives{:}];
    total_false_positives = sum(total_false_positives(:));
    disp(['Total false positives: ', num2str(total_false_positives)]);
    
    % frames times the number of people
    total_number_positions = (total_frames*size(person_distances,2));
    disp(['Total number of positions: ', num2str(total_number_positions)]);
    
    % how much we have classified wrong over the total number of positions
    false_neg_percent = total_false_positives / total_number_positions;
    accuracy = 1-false_neg_percent;
    disp(['False negative: ', num2str(false_neg_percent)]);
    disp(['Accuracy: ', num2str(accuracy)]);

end

