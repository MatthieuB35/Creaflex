function Output=MotorTrainingAJT(NumberItems,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttimeNumber)

AJTpar.Parameters

x=xCenter;

%Modify screen size
ModifyResolution=(screenYpixels/screenXpixels)+1;
SizeFontModifyCues=round(CuesFontChg*ModifyResolution);%round((screenXpixels-screenYpixels)*CuesFontChg);

SetMouse(round(x), round(rect(4)*scalaPosition));

Answer_given_motor=NaN(NumberItems,4);

for WhichIterationNumber = 1:NumberItems
    
    %Select a random number between 1 and 100.
    NumberTemp=unidrnd(100,1);
    
    %Display on screen the scale + the cue
    AJTfct.Display_AJT(1,NumberTemp,NormalColor,0,xCenter,sliderColorThink,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect);
    
    %Wait for X seconds, depending of the time need to think
    WaitSecs(TimeToThink)
    
    %Set up the timer
    t0= GetSecs;
    secs = GetSecs;
    
    %Set up the answer given at 0.
    answer= 0;
    
    %Set up the position of the mouse in the middle
    SetMouse(xCenter,yCenter,window);
    
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
        
        %Display on screen the scale + the cue + the slider
        AJTfct.Display_AJT(1,NumberTemp,NormalColor,1,x,sliderColorThink,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect);
        
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
    %Display in the command windows the different trials
    disp(['For iteration' num2str(WhichIterationNumber) 'answer=' num2str(answer)]);
    
    AJTfct.Display_AJT(1,NumberTemp,NormalColor,1,x,sliderColorSelection,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect);
    
    %Slider etc stay in screen for X time
    RT= secs - t0;
    SelectionLeft=aborttimeNumber-RT;
    WaitSecs(SelectionLeft);
    
    %If press Escape delete
    [KeyIsDown,~, keyCode] = KbCheck;
    if KeyIsDown && keyCode(EscKey)
        disp('User breaks loop');
        break
    end
    
    
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
    
    if answer==1
        %Give an output of the position of the cursor
        Screen('FillRect', window, [0 0 0]);
        DrawFormattedText(window,['Position du curseur: ' num2str(position)],'center', 'center',NormalColor);
        Screen('Flip', window);
        %Wait
        WaitSecs(1);
    else
        Screen('FillRect', window, [0 0 0]);
        DrawFormattedText(window,'Trop tard!','center', 'center',NormalColor);
        Screen('Flip', window);
        %Wait
        WaitSecs(1);
    end
    
    %Enter the answer in the scale, the reaction time and if the
    %participant answered into the variable
    Answer_given_motor(WhichIterationNumber,1)=NumberTemp;
    Answer_given_motor(WhichIterationNumber,2:4)=[position, RT, answer];
    
    %Fill up screen in black while ITI
    Screen('FillRect', window, [0 0 0]);
    Screen('Flip', window);
    
    %Wait for ITI
    WaitSecs(0.5);
    
end
Output=Answer_given_motor;

end