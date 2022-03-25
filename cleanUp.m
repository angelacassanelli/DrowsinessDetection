function cleanUp (videoPlayer)

    disp ('cleaning up some stuff...');
    pause (1);
    
    release(videoPlayer);
    evalin('base', 'clear cam');
    evalin('base', 'close all');
    evalin('base', 'clear');
    evalin('base', 'clc');

end