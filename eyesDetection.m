function ratio = eyesDetection(frame, videoPlayer)
    
    % create face detector object
    faceDetector = vision.CascadeObjectDetector();

    % read the image
    im1=frame;
    imshow(im1);
    
    % create eyes detector Object
    EyeDetector =  vision.CascadeObjectDetector('EyePairBig');
    
    % Use EyeDetector on A and get the faces
    EyeBBOX =step(EyeDetector,im1);     
    
    if (isempty(EyeBBOX))
        return
    end
    dim = size(EyeBBOX);
    if (dim(1) > 1)
        EyeBBOX = EyeBBOX(2,:); %to exclude nose from detection
    end
    
    % Annotate these eyes on the top of the image
    rectangle('Position',EyeBBOX,'LineWidth',3,'LineStyle','-','EdgeColor','g');
    %imannotateeye = insertObjectAnnotation(im1,'rectangle',EyeBBOX,'Eye');
    
    % Getting the last box and crop
    imeye3 = imcrop(im1,EyeBBOX);
    
    % Process the image to bw, complement and strel
    imeye4=im2bw(imeye3);
    imeye5=imclose(imeye4, strel('sphere',4));
    
    
    % The number of white pixels is simply the sum of all the image pixel values since each white pixel has value 1.
    % If the white pixels have value 255 then divide the sum by 255.
    numberOfWhitePixels = sum(imeye5);
    % The number of black pixels is simply the total number of pixels in the image minus the number of white pixels.
    numberOfBlackPixels = numel(imeye5) - numberOfWhitePixels ;
    % Now calculate the ratio.
    ratio = numberOfBlackPixels  / numberOfWhitePixels;

end