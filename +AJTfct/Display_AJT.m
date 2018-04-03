function OnsetDisplay=Display_AJT(HowManyCues,WhichItem,WhichColorCues,IsSlider,PositionSlider,WhichColorSlider,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect)

AJTpar.Parameters

%Modification of the fontsize of the instruction,cues and endpoints
SizeFontModifyCues=round((screenXpixels-screenYpixels)*CuesFontChg);
SizeFontModifyEndPoints=round((screenXpixels-screenYpixels)*EndPointsFontChg);

%Define the left and right position of the cues
LeftScreenPosition=rect(3)*0.4;
RightScreenPosition=rect(3)*0.6;

% Setup the text type for the window
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, SizeFontModifyCues);

if HowManyCues == 1
    if ischar(WhichItem) ==1
        TempDisp=WhichItem;
    elseif isnumeric(WhichItem) ==1
        TempDisp=num2str(WhichItem);
    else
        error('The item to be display should be a numeric or a character value.')
    end
    DrawFormattedText(window,TempDisp,'center', rect(4)*(scalaPosition*CuesPositionYChg),WhichColorCues);
    
else
    if length(WhichItem)==2 && iscell(WhichItem) ==1
        textString_Left_CurrIt=WhichItem{1};
        textString_Right_CurrIt=WhichItem{2};
    else
        error('The number of items should be equal to two.')
    end
    
    %Draw the left item to get the size of the string so it can moved and
    %leave the same space between the two cues for each trial
    [~, ~, textBounds]=DrawFormattedText(window,textString_Left_CurrIt,LeftScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),WhichColorCues); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, [0 0 0]);
    
    % Drawing the two cues as text
    DrawFormattedText(window, textString_Left_CurrIt,LeftScreenPosition-DisplaceText, rect(4)*(scalaPosition*CuesPositionYChg),WhichColorCues);%/4-100
    DrawFormattedText(window, textString_Right_CurrIt,RightScreenPosition,rect(4)*(scalaPosition*CuesPositionYChg),WhichColorCues);
    
end


% Setup the text type for the window
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, SizeFontModifyEndPoints);

% Drawing the end points of the scala as text %textBounds(1, 3) -
%   - rightTick(1, 1)/2
DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg,NormalColor); % Left point
DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg,NormalColor); % Right point

% Drawing the scala
Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line


if IsSlider == 1 && exist('PositionSlider','var')
    Screen('DrawLine', window, WhichColorSlider, PositionSlider, rect(4)*scalaPosition - lineLengthSlider, PositionSlider, rect(4)*scalaPosition  + lineLengthSlider, width);
elseif ~exist('PositionSlider','var')
    error('Need to enter the position of the slider for its creation.')
end



OnsetDisplay=Screen('Flip', window);



end