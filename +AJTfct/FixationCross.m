function FixationCross(HowLong,ColourCross,window,screenXpixels, screenYpixels,xCenter, yCenter)

AJTpar.Parameters;

Screen('FillRect', window, [0 0 0]);

% Here we set the size of the arms of our fixation cross
SizeCrossModif=round((screenXpixels-screenYpixels)*fixCrossDim);

% Set the line width for our fixation cross
WidthCrossModif=round((screenXpixels-screenYpixels)*lineWidthPix);


% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [xCenter+SizeCrossModif yCenter xCenter-SizeCrossModif  yCenter];
yCoords = [xCenter yCenter-SizeCrossModif xCenter yCenter+SizeCrossModif];
allCoords = [xCoords; yCoords];

%Draw the cross
Screen('DrawLine', window,ColourCross, allCoords(1,1), allCoords(1,2), allCoords(1,3), allCoords(1,4),WidthCrossModif);
Screen('DrawLine', window,ColourCross, allCoords(2,1), allCoords(2,2), allCoords(2,3), allCoords(2,4),WidthCrossModif);

%Flip Screen
Screen('Flip', window);

tStart = GetSecs;
timedout = false;
while ~timedout
    [ keyIsDown, keyTime, ~ ] = KbCheck;
    
    if (keyIsDown)
        %disp('User required break during fixation');
        %break;
       AJTfct.PauseButton
    end
    if ((keyTime - tStart) > HowLong)
        timedout = true;
    end
end


end