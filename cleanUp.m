function cleanUp (videoPlayer)

    disp ('cleaning up some stuff...')
    pause (1)

    %release(faceDetector)
    %release(eyesDetector)
    
    release(videoPlayer)
    evalin('base', 'clear cam');
    evalin('base', 'close all');
    evalin('base', 'clear');
    evalin('base', 'clc');

end