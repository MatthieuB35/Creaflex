function Output=TaskAJT(NumberItems,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime)


Parameters


x=xCenter;

%Modification of the fontsize of the instruction,cues and endpoints
SizeFontModifyCues=round((screenXpixels-screenYpixels)*CuesFontChg);
SizeFontModifyEndPoints=round((screenXpixels-screenYpixels)*EndPointsFontChg);

%Define the left and right position of the cues
LeftScreenPosition=rect(3)*0.4;
RightScreenPosition=rect(3)*0.6;


SetMouse(round(x), round(rect(4)*scalaPosition));

Answer_given_WordPair=NaN(NumberItems,3);

for WhichIteration = 1:NumberItems
    
    %Select a random number between 1 and 2.
    LeftOrRight_rnd=unidrnd(2,1);
    
    %If the number is one, the first item will be on the left and the
    %second on the right.
    %If the number is two, it will be the opposite.
    if LeftOrRight_rnd==1
        textString_Left_CurrIt = char(WordList_AllTrial{WhichIteration,1});
        textString_Right_CurrIt = char(WordList_AllTrial{WhichIteration,2});
    else
        textString_Left_CurrIt = char(WordList_AllTrial{WhichIteration,2});
        textString_Right_CurrIt = char(WordList_AllTrial{WhichIteration,1});
    end
    
    %Wait for the participant to replay
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyCues);
    
    %Draw the left item to get the size of the string so it can moved and
    %leave the same space between the two cues for each trial
    [~, ~, textBounds]=DrawFormattedText(window,textString_Left_CurrIt,LeftScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),white); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, [0 0 0])
    
    % Drawing the two cues as text
    DrawFormattedText(window, textString_Left_CurrIt,LeftScreenPosition-DisplaceText, rect(4)*(scalaPosition*CuesPositionYChg),white);%/4-100
    DrawFormattedText(window, textString_Right_CurrIt,RightScreenPosition,rect(4)*(scalaPosition*CuesPositionYChg),white);
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyEndPoints);
    
    % Drawing the end points of the scala as text %textBounds(1, 3) -
    %   - rightTick(1, 1)/2
    DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
    DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
    
    % Drawing the scala
    Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
    Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
    Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
    Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
    
    Screen('Flip', window);
    
    %Wait for X seconds, depending of the time need to think
    WaitSecs(TimeToThink)
    
    %Set up the timer
    t0= GetSecs;
    
    %Set up the answer given at 0.
    answer= 0;
    %Set up the cheking of the movement of the cursor at 0
    Moved=0;
    %Set up the position of the mouse in the middle
    SetMouse(xCenter,yCenter,window)
    %Initialize the position of the cursor at 0.
    x=xCenter;
    %Initialize the speed of the mouse
    x_prev = xCenter;
    
    %While the response has not been given, continue the current trial
    %until it reachs the maximum time. Also, check if the cursos has moved
    %a bit from the center
    while ((Moved==0) || (answer == 0))
        %Check if the cursos has moved from the center, if yes, can answer
        %and go to the next trial
        if (x>xCenter+PercentToMove*(horzLine(1)-horzLine(3)) || x<=xCenter-PercentToMove*(horzLine(1)-horzLine(3)))
            Moved=1;
        end
        
        %Check if task uses a mouse or keyboard
        if strcmp(device, 'mouse')
            %Get the position of the mouse
            [x,~,buttons,~,~,~] = GetMouse(window, MouseDeviceIndex);
        elseif strcmp(device, 'keyboard')
            [keyIsDown,~, keyCode] = KbCheck;
            if keyCode(leftKey)
                x = x - pixelsPerPress;
            elseif keyCode(rightKey)
                x = x + pixelsPerPress;
            end
        end
        
        % change speed for cursor
        dx = x - x_prev;
        x = x_prev + dx*MouseSpeedFactor;
        
        %Verifiy the position of the cursos stay in the maximum bounds.
        if x > rect(3)*scalaLength
            x = rect(3)*scalaLength;
        elseif x < rect(3)*(1-scalaLength)
            x = rect(3)*(1-scalaLength);
        end
        
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyCues);
        
        %Draw the left item to get the size of the string so it can moved and
        %leave the same space between the two cues for each trial
        [~, ~, textBounds]=DrawFormattedText(window,textString_Left_CurrIt,LeftScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),white); %Left item
        DisplaceText=textBounds(3)-textBounds(1);
        
        %Fill the screen in black
        Screen('FillRect', window, [0 0 0])
        
        % Drawing the two cues as text
        DrawFormattedText(window, textString_Left_CurrIt,LeftScreenPosition-DisplaceText,rect(4)*(scalaPosition*CuesPositionYChg),wordColor);
        DrawFormattedText(window, textString_Right_CurrIt,RightScreenPosition,rect(4)*(scalaPosition*CuesPositionYChg),wordColor);
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyEndPoints);
        
        % Drawing the end points of the scala as text
        DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
        DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
        
        % Drawing the scala
        Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
        Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
        Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
        Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
        
        % The slider
        Screen('DrawLine', window, sliderColor, x, rect(4)*scalaPosition - lineLengthSlider, x, rect(4)*scalaPosition  + lineLengthSlider, width);
        
        % Flip screen
        Screen('Flip', window);
        
        % Check if answer has been given
        if strcmp(device, 'mouse') && Moved==1
            secs = GetSecs;
            if buttons(responseKey) == 1
                answer = 1;
            end
        elseif strcmp(device, 'keyboard') && Moved==1
            secs = GetSecs; %[keyIsDown, secs, keyCode] = KbCheck;
            if keyCode(responseKey) == 1
                answer = 1;
            end
        end
        
        %Abort if answer takes too long
        if secs - t0 > aborttime
            break
        end
    end
    
    %Display in the command windows the different trials
    disp(['For iteration' num2str(WhichIteration) 'answer=' num2str(answer)]);
    
    %Wait for 1 seconds before the next trial
    WaitSecs(0.5)
    
    % converting RT to seconds
    RT= secs - t0;
    
    % Calculates the range of the scale
    scaleRange= round(rect(3)*(1-scalaLength)):round(rect(3)*scalaLength);
    
    % Shift the range of scale so it is symmetrical around zero
    scaleRangeShifted = round((scaleRange)-mean(scaleRange));
    
    % Shift the x value according to the new scale
    position= round((x)-mean(scaleRange));
    
    % Converts the value to percentage (scale from -100 to 100)
    position= (position/max(scaleRangeShifted))*100;
    
    %Converts to a scale from 0 to 100
    position= round(position/2)+50;
    
    %Enter the answer in the scale, the reaction time and if the
    %participant answered into the variable
    Answer_given_WordPair(WhichIteration,:)=[position, RT, answer];

end


Output=Answer_given_WordPair;


sca

end