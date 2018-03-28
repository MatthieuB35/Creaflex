function Output=NormalTrainingAJT(NumberItems,WordList_Training,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime)

Parameters


x=xCenter;

SetMouse(round(x), round(rect(4)*scalaPosition));

Answer_given_training=NaN(NumberItems,3);

for WhichIterationTraining = 1:NumberItems
    
    %Select a random number between 1 and 2.
    LeftOrRight_rnd=unidrnd(2,1);
    
    %If the number is one, the first item will be on the left and the
    %second on the right.
    %If the number is two, it will be the opposite.
    if LeftOrRight_rnd==1
        textString_Left_CurrIt = char(WordList_Training{WhichIterationTraining,1});
        textString_Right_CurrIt = char(WordList_Training{WhichIterationTraining,2});
        WhichItem={textString_Left_CurrIt; textString_Right_CurrIt};
    else
        textString_Left_CurrIt = char(WordList_Training{WhichIterationTraining,2});
        textString_Right_CurrIt = char(WordList_Training{WhichIterationTraining,1});
        WhichItem={textString_Left_CurrIt; textString_Right_CurrIt};
    end
    
    
    %Display on screen the scale + the cues
    Display_AJT(2,WhichItem,NormalColor,0,xCenter,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect)
    
    %Wait for X seconds, depending of the time need to think
    WaitSecs(TimeToThink)
    
    %Set up the timer
    t0= GetSecs;
    secs = GetSecs;
    
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
            %Check the keyboard
            [keyIsDown,~, keyCode] = KbCheck;
            %Change the position of the cursor using left and right arrows
            if keyCode(leftKey)
                x = x - pixelsPerPress;
            elseif keyCode(rightKey)
                x = x + pixelsPerPress;
            end
        end
        
        %Change speed for cursor
        dx = x - x_prev;
        x = x_prev + dx*MouseSpeedFactor;
        
        %Verifiy the position of the cursos stay in the maximum bounds.
        if x > rect(3)*scalaLength
            x = rect(3)*scalaLength;
        elseif x < rect(3)*(1-scalaLength)
            x = rect(3)*(1-scalaLength);
        end
        
        %Display on screen the scale + the cues + the slider
        Display_AJT(2,WhichItem,wordColor,1,x,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect)
        
        % Check if answer has been given and if the cursos has moved a
        % little
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
    
    %Display in the command windows the
    disp(['For iteration' num2str(WhichIterationTraining) 'answer=' num2str(answer)]);
    
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
    Answer_given_training(WhichIterationTraining,:)=[position, RT, answer];
end

Output=Answer_given_training;


end