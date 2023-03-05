
# Drowsiness Detection

MATLAB implementation of a Drowsiness Detection system


## About the project

The main objective of this project is the development of an Image Processing system able to automatically detect people drowsiness in a video, without the need of complex sensors or wearable devices, but only thanks to the setup of a video camera capturing and processing the user's video in real time and with a very high precision. 

This kind of detector should work recognizing the user's face and, in particular, the user's eyes and processing the video frame by frame. Our interest is to detect if the eyes are open or not and, in case not, how much time they are closed for: longer time means higher drowsiness. For the system to be actually useful, it emits an acoustic signal in order to call back the user's attention. 

## Run locally

Run my project locally following these simple steps:
  
*  Clone the repo:

```sh
git clone https://github.com/angelacassanelli/DrowsinessDetection.git
```

* Open `MainApp.m` in MATLAB and run it.

    
## Prerequisites

* Good lightning condition: in bad lightning condition the detection and the processing could not be performed.
* Distance between the camera and the user within a range of 50 - 70 cm: as we move away from the extreme values, the accuracy of the system decreases until it is unable to do its work: this happens because of some parameters used in frame processing functions, that depend on spatial distance. 

## Usage

Keeping your face facing the webcam, open and close your eyes and the system will detect it.
## Workflow

- `Constants.m` that contains some constant variables;
- `MainApp.m` that is the main script for the app execution;
- `getThreshold.m` that contains a function to calculate a threshold used to determine the eye status;
- `eyesDetection.m` that contains a function to detect and process eyes;
- `drowsinessDetection.m` that contains a function to detect the drowsiness;
- `cleanUp.m` that contains a function to clean some stuff at the end of the execution of the program.



## Documentation

### Constants.m
It contains some useful constant variables that are used in the other files of the system: 
- _defaultTresholdRatio_: default value for eyes status threshold;
- _eyesStatusOpen_: string indicating open eyes status;
- _eyesStatusClosed_: string indicating closed eyes status;
- _folderPath_: path to a folder with some images;
- _extension_: extension for the images in the folder.

### MainApp.m
It is the main script that manages the execution of the whole program:

```
webcamList = webcamlist;
 
if (isempty(webcamList))
    disp('No webcam available. Stop program.');
    return;
 
else 
    currentWebcam = webcamList{1};
    disp(['Webcam available:', currentWebcam]);
    disp('Starting program.');
    cam = webcam(currentWebcam);

    firstFrame = snapshot(cam);
    frameSize = size(firstFrame);

```

- Checks if any camera is available;
- The cam object pointing to the first available camera is created, if any camera is available;
- The first frame is captured by cam with a snapshot.

```
     videoPlayer = vision.VideoPlayer('Name', 'DROWSINESS DETECTION APP ‘, 'Position', [0, 500, frameSize(2)/1.5, frameSize(1)/1.5]);

    tresholdRatio = getTreshold(cam);
    drowsinessDetection(tresholdRatio, cam, videoPlayer);  
end

cleanUp(videoPlayer);
```

- The _videoplayer_ object is created and the realtime video is displayed;
- The _threshold_ value is computed by `getThreshold` function;
- The `drowsinessDetection` function is called;
- The `cleanUp` function is called at the end of the execution.


### getThreshold.m
It computes the threshold value that is used to determine the status of the eyes in each frame (applying matching method):

```
try
    frame = snapshot(cam);
    initialRatio = eyesDetection(frame);
    treshold = initialRatio*0.8;
    if (treshold > 0)
        return;
    end
catch 
    disp('Person not detected.');
    disp('New attempt.');
end
```

- Returns the 80% of the ratio returned by eyeDetection on the first frame;
- A wrong value for this threshold would cause a failure in the drowsiness detection;
- It is inserted in a try-catch block, so that any possible exception is captured without any interruption of the program;
- The try-catch block is executed into a while loop, so that the threshold value is returned only when a valid and strictly greater than zero number has been found. 

### eyesDetection.m

```
eyeDetector =  vision.CascadeObjectDetector(‘EyePairBig');
eyesBox = step(eyeDetector, frame);
```

- The _eyeDetector_ is instantiated as _vision.CascadeObjectDetector_, a detector using the Viola-Jones algorithm; 
- The type of object detected is controlled by the ClassificationModel property _EyePairBig_, a classification model that detects a pair of eyes;
- _eyesBox_ is an M-by-4 matrix defining M bounding boxes containing the  the ROI detected by eyeDetector inside the current frame.

```
if (isempty(eyesBox))
    return;
end
 
eyesBox_dim = size(eyesBox);

if (eyesBox_dim(1) > 1)
    return;
end

rectangle('Position', eyesBox, 'LineWidth', 3, 'LineStyle', '-', 'EdgeColor', 'g'); 
```

The _eyesBox_ is expected to have a dimension of 1-by-4, but sometimes this may not happen, for example in the case in which nothing is detected and eyesBox is empty, or also in the case in which more objects are wrongly identified as eyes and eyesBox has a dimension n-by-4 with n greater than 1;
-	If the dimension of _eyesBox_ is wrong, the processing for current frame is stopped and skipped;
-	If the dimension of _eyesBox_ is correct, a green rectangle is designed around the ROI.

```
im_eyes = imcrop(frame, eyesBox);
subplot(3,3,1), imshow(im_eyes);
```

-	Extraction of the region of interest;

```
im_eyes_gray=rgb2gray(im_eyes);
subplot(3,3,2), imshow(im_eyes_gray);
```

-	Conversion from truecolor to grayscale, by eliminating hue and saturation and retaining luminance;

```
im_eyes_adjusted = imadjust(im_eyes_gray);
subplot(3,3,3), imshow(im_eyes_adjusted);
```

-	Enhancement by saturating the bottom 1% and top 1% of all pixel values;

```
im_eyes_bw = imbinarize(im_eyes_adjusted, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.5);
subplot(3,3,4), imshow(im_eyes_bw);
```

-	Conversion from grayscale to a binary image by replacing all values above a globally determined threshold with 1s and setting all other values to 0s;

```
im_eyes_complement = imcomplement(im_eyes_bw);
subplot(3,3,5), imshow(im_eyes_complement);
```

-	Complement of the image, by inverting white and black pixels;

```
im_eyes_close = imclose(im_eyes_complement, strel('disk', 2));
subplot(3,3,6), imshow(im_eyes_close);
```

-	Morphological closing using a disk with a radius of 2 pixels: dilation followed by an erosion, using the same structuring element for both operations;

```
im_eyes_open = 
imopen(im_eyes_close, strel('disk', 7));
subplot(3,3,7), imshow(im_eyes_open);
```

-	Morphological opening using a disk with a radius of 7 pixels: erosion followed by a dilation, using the same structuring element for both operations;

```
whitePixels = sum(im_eyes_open == 1);
numberOfWhitePixels = sum(whitePixels);
 
blackPixels = numel(im_eyes_open) - numberOfWhitePixels;
numberOfBlackPixels = sum(blackPixels);
    
ratio = numberOfWhitePixels/numberOfBlackPixels;
```

-	The _numberOfWhitePixels_ is the sum of all the pixels having value equal to 1;
-	The _numberOfBalckPixels_ is the total number of pixel of the image minus the number of white pixels;
-	We compute the ratio between _numberOfWhitePixels_ and _numberOfBalckPixels_. 

### drowsinessDetection.m
It determines eyes status in each frame and detects drowsiness if eyes are closed for multiple consecutive frames

```
pause (0.30)

frame = snapshot(cam);    
step(videoPlayer, frame);

ratio = eyesDetection(frame);
disp(['ratio is ', num2str(ratio, 3)]);
disp(['threshold ratio is ', num2str(tresholdRatio,3)]);

if ratio >= tresholdRatio  
    eyeStatus = Constants.eyesStatusOpen;
else
    eyeStatus= Constants.eyesStatusClosed;
end
```

- The frame rate is reduced with pause to 2 fps;
- A frame is captured by snapshot and visualized in the _videoPlayer_;
- The ratio between white and black pixels is returned by the _eyesDetection_ called over the current frame;
- The previous _eyeStatus_ is saved, then it is overwritten with the eyeStatus in the current frame;
- If current _ratio_ is greather than or equal to the _thresholdRatio_ eye status is open, else closed.

```
if strcmp(eyeStatus, Constants.eyesStatusClosed) && strcmp(eyeStatus, previousEyeStatus)
    closedFrameCount = closedFrameCount + 1;
else
    closedFrameCount = 0;
end
 
subplot(3,3,8); imshow([Constants.folderPath, eyeStatus, Constants.extension]);
disp(['EYES ARE ', eyeStatus]); 
            
if (closedFrameCount > 2)
    disp ('!!! DROWSINESS DETECTED !!!');
    beep;
end  
```

- The current _eyeStatus_ is compared to the previous one;
- If they are equal and their value is _eyeStatusClosed_ a counter for the number of consecutive frames with closed eyes is incremented, else it is resetted to 0;
- If the counter overcomes 2, drowsiness is reported.

### cleanUp.m
Called in the MainApp only at the end of the execution, which is determined by the user closing the videoPlayer:
- The _videoPlayer_ object is released;
- The _cam_ object is removed;
- All open figures are closed;
- The Workspace is cleared;
- The Command Window is cleared. 

## 🚀 About Me
I'm a MSc Computer Science Engineering Student at Polytechnic Univeristy of Bari and this is my project work for Image Processing exam.
