function treshold = getTreshold (cam, videoPlayer)    

    % get the threshold through eye detection in the first frame
    % loop while threshold is set
    
    i = 1;
    
    while true

        disp(['Attempt number ', num2str(i)]);
        disp('Open your eyes. Picture will be taken in 3 seconds.');
        pause(3);
               
        try
            frame = snapshot(cam);
            initialRatio = eyesDetection(frame, videoPlayer);
            treshold = initialRatio*1.05;
            return;
        catch exception
            disp (exception)
            disp('Person not detected.')
            disp('New attempt.');
            treshold = Constants.defaultTresholdRatio;
        end

        i = i+1;

    end

end