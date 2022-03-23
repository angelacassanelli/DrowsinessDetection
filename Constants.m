% constant variables of the system

classdef Constants
    properties( Constant = true )
        defaultTresholdRatio = 0.055; % default threshold based on developer ratio
        eyesStatusOpen = 'OPEN'; % string for open eyes
        eyesStatusClosed = 'CLOSED'; % string for closed eyes
        folderPath = 'imgs/'; % path to image folder
        extension = '.png'; % extension for images
    end
end