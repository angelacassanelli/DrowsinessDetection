function drowsinessDetection(tresholdRatio, cam, videoPlayer)
    
    % initialize variables
    runLoop = true;
    eyeStatus = ' ';
    closedFrameCount = 0;

    while runLoop

        % use this if you want to visualize operations on frame 
        pause (0.5)
        
        % get the next frame
        frame = snapshot(cam);    
        step(videoPlayer, frame);

        % try to detect eyes state
        try
            % detect the eyes in the frame and keep comparing the ratio with the threshold
            ratio = eyesDetection(frame, videoPlayer);
            disp(['ratio is ',num2str(ratio, 3)]);
            disp(['threshold ratio is ',num2str(tresholdRatio,3)])
                
            previousEyeStatus = eyeStatus;
 
            if ratio > tresholdRatio  
                eyeStatus = Constants.eyesStatusOpen;
            else
                eyeStatus= Constants.eyesStatusClosed;
            end

            if strcmp(eyeStatus, Constants.eyesStatusClosed) && strcmp(eyeStatus, previousEyeStatus)
                closedFrameCount = closedFrameCount + 1;
            else
                    closedFrameCount = 0;
            end

            disp(['Eyes are ', eyeStatus]);                       
            
            % signal drowsiness if eyes are closed for more than 3 consecutive frames
            if (closedFrameCount > 5)
                disp ('!!! !!! !!! DROWSINESS DETECTED !!! !!! !!!');
                beep
            end        
    
        catch e
            disp(e)
            disp('You are not detected');
        end

        % check if the video player window has been closed
        % if yes, stop execution
        runLoop = isOpen(videoPlayer);         
    
    end    
        
 end

    