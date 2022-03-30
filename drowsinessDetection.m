% function for drowsiness detection based on eyes detection

function drowsinessDetection(tresholdRatio, cam, videoPlayer)
    
    % initialize variables
    runLoop = true;
    eyeStatus = ' ';
    closedFrameCount = 0;

    while runLoop

        % force reduce the frame rate 
        pause (0.30);
        
        % get the next frame
        frame = snapshot(cam);    
        step(videoPlayer, frame);

        % try to detect eyes state
        try

            % detect the eyes in the frame and compare the current ratio with the threshold
            ratio = eyesDetection(frame);
            disp(['ratio is ', num2str(ratio, 3)]);
            disp(['threshold ratio is ', num2str(tresholdRatio,3)]);
                
            % save previous value for eye status
            previousEyeStatus = eyeStatus;
 
            % set current value for eye status
            if ratio >= tresholdRatio  
                eyeStatus = Constants.eyesStatusOpen;
            else
                eyeStatus= Constants.eyesStatusClosed;
            end

            % compare previous and current values for eye status
            if strcmp(eyeStatus, Constants.eyesStatusClosed) && strcmp(eyeStatus, previousEyeStatus)
                % count consecutive frames with closed eyes
                closedFrameCount = closedFrameCount + 1;
            else
                % reset count
                closedFrameCount = 0;
            end

            subplot(3,3,8); imshow([Constants.folderPath, eyeStatus, Constants.extension]);
            disp(['EYES ARE ', eyeStatus]); 
            
            % signal drowsiness if eyes are closed for more than 2 consecutive frames
            if (closedFrameCount > 2)
                disp ('!!! !!! !!! DROWSINESS DETECTED !!! !!! !!!');
                beep;
            end        
    
        catch 

            disp('Your eyes are not correctly detected');
            
        end

        % if the video player window has been closed exit loop
        runLoop = isOpen(videoPlayer);         
    
    end    
        
 end

 