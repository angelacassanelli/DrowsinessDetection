% function for eyes detection and processing

function ratio = eyesDetection(frame)

    imshow(frame);
    subplot(3,3,9), imshow(frame);

    % 1. eyes detection

    disp ('starting eyes detection');

    % create eyes detector object and a box for it on the frame
    eyeDetector =  vision.CascadeObjectDetector('EyePairBig');
    eyesBox = step(eyeDetector, frame);
        
    % 2. checks for a correct detection

    disp ('starting checks for correct detection');

    % eyesBox should contain something
    if (isempty(eyesBox))
        return;
    end

    % eyesBox are matrixes Mx4
    % where M is the number of boxes for the M objects detected    
    eyesBox_dim = size(eyesBox);
    
    % if M > 1, the detector has detected more than one object: this is wrong
    % in this case we skip the current iteration    
    if (eyesBox_dim(1) > 1)
        return;
    end
    
    % draw eyes box on the frame    
    rectangle('Position', eyesBox, 'LineWidth', 3, 'LineStyle', '-', 'EdgeColor', 'g'); 

    % 3. preprocessing 
    
    % getting the last box and crop
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

    % 4. eyes processing 

    disp('starting processing');
   
    % complement the image
    im_eyes_complement = imcomplement(im_eyes_bw);
    subplot(3,3,5), imshow(im_eyes_complement);

    % morphologically close image
    im_eyes_close = imclose(im_eyes_complement, strel('disk', 2));
    subplot(3,3,6), imshow(im_eyes_close);

    % morphologically open image
    im_eyes_open = imopen(im_eyes_close, strel('disk', 7));
    subplot(3,3,7), imshow(im_eyes_open);
    
    % each white pixel has value 1
    whitePixels = sum(im_eyes_open == 1);
    % count all white pixels
    numberOfWhitePixels = sum(whitePixels);
    
    % count all black pixels as (sum of all pixel - sum of white pixel)
    blackPixels = numel(im_eyes_open) - numberOfWhitePixels;
    numberOfBlackPixels = sum(blackPixels);
    
    % calculate the ratio
    ratio = numberOfWhitePixels/numberOfBlackPixels;

end