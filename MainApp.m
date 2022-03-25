% MAIN APP

% check if webcam is available
webcamList = webcamlist;

% if not notify user and stop execution 
if (isempty(webcamList))
    disp('No webcam available. Stop program.');
    return;

% if yes start execution
else 

    % select first webcam in available webcam list
    currentWebcam = webcamList{1};
    disp(['Webcam available:', currentWebcam]);
    disp('Starting program.');
    
    % create the webcam object
    cam = webcam(currentWebcam);

    % capture first frame and its size
    firstFrame = snapshot(cam);
    frameSize = size(firstFrame);
    
    % create the video player object with first fram size
    videoPlayer = vision.VideoPlayer('Name', 'DROWSINESS DETECTION APP - VIDEO PREVIEW', 'Position', [0, 500, frameSize(2)/1.5, frameSize(1)/1.5]);
    
    % get treshold for matching method
    tresholdRatio = getTreshold(cam);

    % start drowsiness detection algorithm
    drowsinessDetection(tresholdRatio, cam, videoPlayer);    

end

cleanUp(videoPlayer);