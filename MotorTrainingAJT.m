function Output=MotorTrainingAJT(NumberItems,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttimeNumber)

Parameters


x=xCenter;

%Modification of the fontsize of the instruction,cues and endpoints
SizeFontModifyCues=round((screenXpixels-screenYpixels)*CuesFontChg);
SizeFontModifyEndPoints=round((screenXpixels-screenYpixels)*EndPointsFontChg);

SetMouse(round(x), round(rect(4)*scalaPosition));

Answer_given_motor=NaN(NumberItems,4);

for WhichIterationNumber = 1:NumberItems
    
    %Select a random number between 1 and 100.
    NumberTemp=unidrnd(100,1);
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyCues);
    
    % Drawing the number
    DrawFormattedText(window,num2str(NumberTemp),'center', rect(4)*(scalaPosition*CuesPositionYChg),NormalColor);
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyEndPoints);
    
    % Drawing the end points of the scala as text
    DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg,NormalColor); % Left point
    DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg,NormalColor); % Right point
    
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
    secs = GetSecs;
    
    %Set up the answer given at 0.
    answer= 0;
    
    %Set up the position of the mouse in the middle
    SetMouse(xCenter,yCenter,window)
    
    %Initialize the speed of the mouse
    x_prev = xCenter;
    
    %While the response has not been given, continue the current trial
    %until it reachs the maximum time.
    while answer == 0
        %Check if task uses a mouse or keyboard
        if strcmp(device, 'mouse')
            %Get the position of the mouse
            [x,~,buttons,~,~,~] = GetMouse(window, MouseDeviceIndex);
        elseif strcmp(device, 'keyboard')
            %Check the keyboard
            [keyIsDown,~, keyCode] = KbCheck;
            %Change the position of the cursor using left and right arrows
            if keyCode(leftKey)
                x = x - pixelsPerPress;
            elseif keyCode(rightKey)
                x = x + pixelsPerPress;
            end
        end
        
        %Change the speed of the cursor
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
        
        %Draw the number in the center of the screen above the scale
        DrawFormattedText(window,num2str(NumberTemp),'center', rect(4)*(scalaPosition*CuesPositionYChg),wordColor);
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyEndPoints);
        
        % Drawing the end points of the scala as text
        DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg,NormalColor); % Left point
        DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg,NormalColor); % Right point
        
        % Drawing the scala
        Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
        Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
        Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
        Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
        
        % The slider
        Screen('DrawLine', window, sliderColor, x, rect(4)*scalaPosition - lineLengthSlider, x, rect(4)*scalaPosition  + lineLengthSlider, width);
        
        % Flip screen
        onsetStimulus = Screen('Flip', window);
        
        % Check if answer has been given
        if strcmp(device, 'mouse')
            secs = GetSecs;
            if buttons(responseKey) == 1
                answer = 1;
            end
        elseif strcmp(device, 'keyboard')
            secs = GetSecs; %[keyIsDown, secs, keyCode] = KbCheck;
            if keyCode(responseKey) == 1
                answer = 1;
            end
        else
            error('Unknown device');
        end
        
        %Abort if answer takes too long
        if secs - t0 > aborttimeNumber
            break
        end
    end
    %Display in the command windows the
    disp(['For iteration' num2str(WhichIterationNumber) 'answer=' num2str(answer)]);
    
    % converting RT to seconds
    RT=  secs - t0;
    
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
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyCues);
    
    %Give an output of the position of the cursor
    Screen('FillRect', window, [0 0 0])
    DrawFormattedText(window,['Position du curseur: ' num2str(position)],'center', 'center',NormalColor);
    Screen('Flip', window);
    
    %Enter the answer in the scale, the reaction time and if the
    %participant answered into the variable
    Answer_given_motor(WhichIterationNumber,1)=NumberTemp;
    Answer_given_motor(WhichIterationNumber,2:4)=[position, RT, answer];
    
    %Wait for 1 seconds before the next trial
    WaitSecs(1)
    
end
    Output=Answer_given_motor;

    sca
end