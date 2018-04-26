%Screen

%Call some default settings for setting up Psychtoolbox or Debug mode
%PsychDefaultSetup(2);
%Screen('Preference', 'SkipSyncTests', 0)

%Screen('Preference', 'SkipSyncTests', 2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = OutputScreen; % max(screens);

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1
%white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow',screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);


% Get the center coordinate of the window
% Get the center coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
rect= [ 0 0 screenXpixels screenYpixels]; %Dimension of the screen

%Define the position where the words will be presented.
LeftScreenPosition=rect(3)*0.4;
RightScreenPosition=rect(3)*0.6;
TopScreenPosition=rect(4)*0.35;
BottomScreenPosition=rect(4)*0.6;