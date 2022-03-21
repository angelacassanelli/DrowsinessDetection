%% test script for eyes detection
 
clc;    
close all;  
workspace; 
commandwindow; 

% Read in demo image.
cam = webcam();
frame = snapshot(cam);

imshow(frame)

%% eyes detection

disp ('starting face and eyes detection');

% create eyes detector Object and a box for it on the frame
eyeDetector =  vision.CascadeObjectDetector('EyePairBig');
eyesBox =step(eyeDetector, frame);    

%% checks for a correct detection

disp ('starting checks for correct detection');

if (isempty(eyesBox))
    return
end

% eyesBox are matrixes Mx4
% where M is the number of boxes for the M objects detected    
eyesBox_dim = size(eyesBox);

% if M > 1, the detector has detected more than one object: this is wrong
% in this case we skip the current iteration    
if (eyesBox_dim(1) > 1)
    eyesBox = eyesBox(2,:);
    %return
end

% draw eyes box on the frame    
rectangle('Position', eyesBox, 'LineWidth', 3, 'LineStyle', '-', 'EdgeColor', 'g');   

%% preprocessing 

% Getting the last box and crop
im_eyes = imcrop(frame, eyesBox);
subplot(3,3,1), imshow(im_eyes);

% transform to gray scale
im_eyes_gray=rgb2gray(im_eyes);
subplot(3,3,2), imshow(im_eyes_gray);

% adjust image intensity values
im_eyes_adjusted = imadjust(im_eyes_gray);
subplot(3,3,3), imshow(im_eyes_adjusted);    

% process the image to bw
im_eyes_bw = imbinarize(im_eyes_adjusted, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.5);
subplot(3,3,4), imshow(im_eyes_bw);

%% eyes processing 

disp('starting processing');

% complement the image
im_eyes_complement = imcomplement(im_eyes_bw);
subplot(3,3,5), imshow(im_eyes_complement);

% close image
im_eyes_close = imclose(im_eyes_complement, strel('disk', 2));
subplot(3,3,6), imshow(im_eyes_close);

% open image
im_eyes_open = imopen(im_eyes_close, strel('disk', 8));
subplot(3,3,7), imshow(im_eyes_open);

% the number of white pixels is simply the sum of all the image pixel values since each white pixel has value 1.
% if the white pixels have value 255 then divide the sum by 255.
whitePixels = sum(im_eyes_open==1);
numberOfWhitePixels = sum(whitePixels)
% The number of black pixels is simply the total number of pixels in the image minus the number of white pixels.
blackPixels = numel(im_eyes_open) - numberOfWhitePixels ;
numberOfBlackPixels = sum(blackPixels)

% calculate the ratio
ratio = numberOfWhitePixels/numberOfBlackPixels;

% normalize values
ratio = ratio;
