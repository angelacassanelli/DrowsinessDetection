function treshold = getTreshold (firstFrame, videoPlayer)    

    for i= 1:3

        % perform 3 attempts to set the treshold, else stop exection
        % try to get the treshold through eye detection in the first frame
        
        disp(['Attempt number ', num2str(i)]);
        disp('Open your eyes. Picture will be taken in 3 seconds.');
        pause(3);
               
        try
            initialRatio = eyesDetection(firstFrame, videoPlayer);
            treshold = initialRatio*0.95;
            break
        catch 
            disp('Person not detected.')
            if (i < 3)
                disp('Try again.');
            else 
                disp('Starting program. Default treshold will be used.');
            end
            treshold = Constants.defaultTresholdRatio;
        end

    end

end