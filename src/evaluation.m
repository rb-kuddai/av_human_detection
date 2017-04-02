function [person_distances, person_trajectories_x, person_trajectories_y, truth_trajectories_x, truth_trajectories_y] = evaluation( first_frame, frame, stats, blob2person, people_markers, person_distances, person_trajectories_x, person_trajectories_y, truth_trajectories_x, truth_trajectories_y)
%EVALUATION Based on a given frame and an (x, y) it returns the distance
%between 
%   Detailed explanation goes here
    global evaluation_file_name

    load(evaluation_file_name); % load the matrix
    
    retrieved_frame = frame-first_frame+1; % retrieve the correct index of person
    
    % top right person is red and is labelled as person 1
    % bottom right is yellow and is labelled as person 2
    % top left is green and is labelled as person 3
    % bottom left is blue and is labelled as person 4
    
    % our label - their label
    convert_person = [1, 3, 4, 2];
    
    for blob_id = 1:size(stats, 1)
        person_id = blob2person(blob_id);

        person = convert_person(person_id); % provides the id in the look-up table
        
        % centroid of the person
        centroid = stats(blob_id).Centroid;
        cc = centroid(1);
        cr = centroid(2);
    
        % retrieve the true X and Y
        x_truth = positions(person,retrieved_frame,1);
        y_truth = positions(person,retrieved_frame,2);
        
        truth_trajectories_x{person_id} = [truth_trajectories_x{person_id} x_truth];
        truth_trajectories_y{person_id} = [truth_trajectories_y{person_id} y_truth];

        P = [x_truth,y_truth;cc,cr]; % holds the original points (x, y) and (x_truth, y_truth)

        d = pdist(P,'euclidean');

%        disp(['difference in ', people_markers{person_id}, ' person is ', num2str(d)]);
        if d > 10
            disp(['difference in frame ', num2str(frame), ' in ', people_markers{person_id}, ' person is ', num2str(d)]);
            
            person_trajectories_x{person_id} = [person_trajectories_x{person_id} cc];
            person_trajectories_y{person_id} = [person_trajectories_y{person_id} cr];
        else
            person_distances{person_id} = [person_distances{person_id} d];
        end
    end

    
    
    

end

