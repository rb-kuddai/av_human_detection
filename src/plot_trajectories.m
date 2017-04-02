function [] = plot_trajectories( bg_img, people_trajectories_x, people_trajectories_y, truth_trajectories_x, truth_trajectories_y, people_markers )
%PLOT_TRAJECTORIES Plots the trajectories for each person
    global plot_trajectories_fig evaluation_file_name plot_trajectories2_fig

    % plot trajectories
    % draw people trajectories on one image
    disp(['Plotting all peoples trajectories on one image.']);
    figure(plot_trajectories_fig);
    clf;
    imshow(bg_img);
    hold on;
    for person_id=1:size(people_trajectories_x, 2)
        % plot trajectories
        % returns [cc,cr]
        X = people_trajectories_x{person_id};
        Y = people_trajectories_y{person_id};
        colour = strtok(people_markers{person_id},'.');
        plot(X, Y, colour);
    end
    hold off;
    drawnow;
    
    input('Please press enter');
    % get the X and Y of the ground truth
    load(evaluation_file_name); % load the matrix
    for person_id=1:size(people_trajectories_x, 2)
        
        disp(['Plotting Person ', num2str(person_id) ,' trajectories on one image.']);
        figure(plot_trajectories2_fig(person_id));
        imshow(bg_img);
        hold on;
        X = people_trajectories_x{person_id};
        Y = people_trajectories_y{person_id};
        colour = strtok(people_markers{person_id},'.');
        plot(X, Y, colour);

        x_truth = truth_trajectories_x{person_id};
        y_truth = truth_trajectories_y{person_id};
        colour = 'w';
        plot(x_truth, y_truth, colour);
        hold off;
        drawnow;
    end
    


end

