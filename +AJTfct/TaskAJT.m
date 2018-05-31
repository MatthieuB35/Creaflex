function Output=TaskAJT(NumberItems,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,ITI,Break)


if nargin ==14
    DoBreak=0;
elseif nargin ==15
    DoBreak=1;
    WhenPause=zeros(1,(100/Break));
    TempCounter=0;
    for CounterBreak = 1:(100/Break)
        TempCounter=TempCounter+NumberItems*(Break/100);
        WhenPause(CounterBreak)=TempCounter;
    end
else
    error('Problem in the arguments of the function')
end

AJTpar.Parameters;

x=xCenter;

SetMouse(round(x), round(rect(4)*scalaPosition));

Answer_given_WordPair=cell(NumberItems,10);

StartTrial=GetSecs;

for WhichIteration = 1:NumberItems
    
    %Select a random number between 1 and 2.
    %LeftOrRight_rnd=unidrnd(2,1);
    
    %If the number is one, the first item will be on the left and the
    %second on the right.
    %If the number is two, it will be the opposite.
    %if LeftOrRight_rnd==1
        textString_Left_CurrIt = char(WordList_AllTrial{WhichIteration,1});
        textString_Right_CurrIt = char(WordList_AllTrial{WhichIteration,2});
        WhichItem={textString_Left_CurrIt; textString_Right_CurrIt};
%     else
%         textString_Left_CurrIt = char(WordList_AllTrial{WhichIteration,2});
%         textString_Right_CurrIt = char(WordList_AllTrial{WhichIteration,1});
%         WhichItem={textString_Left_CurrIt; textString_Right_CurrIt};
%     end
    
    %Display on screen the scale + the cues
    OnsetThink=AJTfct.Display_AJT(2,WhichItem,NormalColor,0,xCenter,sliderColorThink,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect);
    
    %Wait for X seconds, depending of the time need to think
    WaitSecs(TimeToThink);
    
    
    
    %Set up the timer
    t0= GetSecs;
    secs = GetSecs;
    
    TimeStampThink=t0-OnsetThink;
    
    %Set up the answer given at 0.
    answer= 0;
    %Set up the cheking of the movement of the cursor at 0
    Moved=0;
    %Set up the position of the mouse in the middle
    SetMouse(xCenter,yCenter,window);
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
        
        %Display on screen the scale + the cues + the slider
        AJTfct.Display_AJT(2,WhichItem,NormalColor,1,x,sliderColorThink,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect);
        
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
    
    OnsetResponse=AJTfct.Display_AJT(2,WhichItem,NormalColor,1,x,sliderColorSelection,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect);
    
    %Slider etc stay in screen for X time
    RT= secs - t0;
    
    SelectionLeft=aborttime-RT;
    WaitSecs(SelectionLeft);
    
    %If press Escape delete
    [KeyIsDown,~, keyCode] = KbCheck;
    if KeyIsDown && keyCode(EscKey)
        AJTfct.PauseButton(PauseScreen);
        %disp('User required break during block');
        %break
    end
    
    %Fill up screen in black while ITI
    Screen('FillRect', window, [0 0 0]);
    OnsetITI=Screen('Flip', window);
    
    %Wait for 1 seconds before the next trial
    JitteredITI=ITI(WhichIteration)*0.001;
    WaitSecs(JitteredITI);
    
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
    
    EndTrial=GetSecs;
    
    %Enter the answer in the scale, the reaction time and if the
    %participant answered into the variable
    Answer_given_WordPair{WhichIteration,1}=textString_Left_CurrIt;
    Answer_given_WordPair{WhichIteration,2}=textString_Right_CurrIt;
    Answer_given_WordPair{WhichIteration,3}=WordList_AllTrial{WhichIteration,3};
    Answer_given_WordPair{WhichIteration,4}=position;
    Answer_given_WordPair{WhichIteration,5}=OnsetThink-StartTrial;
    Answer_given_WordPair{WhichIteration,6}=TimeStampThink;
    Answer_given_WordPair{WhichIteration,7}=RT;
    Answer_given_WordPair{WhichIteration,8}=OnsetITI-OnsetResponse;
    Answer_given_WordPair{WhichIteration,9}=JitteredITI;
    Answer_given_WordPair{WhichIteration,10}=EndTrial-OnsetITI;
    Answer_given_WordPair{WhichIteration,11}=answer;
    
%     if DoBreak==1 && ismember(WhichIteration,WhenPause)
%         AJTfct.Break(window,NormalColor);
%     end
    
    StartTrial=GetSecs;
end


Output=Answer_given_WordPair;


end