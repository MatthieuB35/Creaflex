function TempOutput=TAC_Trials(ListElements,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition)

TACpar.Parameters;

TempOutput=cell(HowMuchItem,1);

TACfct.DisplayTAC(ListElements,0,BackgroundBlack,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition)

%Wait for 1 second
WaitSecs(1);


TACfct.DisplayTAC(ListElements,1,BackgroundBlack,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition)

% get the time stamp at the start of waiting for key input
% so we can evaluate timeout
TimeStart = GetSecs;

% repeat until a valid key is pressed or we time out
TimeOut = false;

while ~TimeOut
    % check if a key is pressed
    % only keys specified in activeKeys are considered valid
    [ keyIsDown, keyTime, ~ ] = KbCheck;
    if(keyIsDown) 
        break
    end
    %Two seconds before the end, fill the screen in grey
    if( (keyTime - TimeStart) > Time2Wait-2)
        TACfct.DisplayTAC(ListElements,1,BackgroundGrey,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition);
    end
    if( (keyTime - TimeStart) > Time2Wait)
        TimeOut = true; 
    end
end


%Put the time of answer in the variable
TempOutput{1}=keyTime - TimeStart;
if TimeOut
    GaveAnswer=0;
else
    GaveAnswer=1;
end
TempOutput{2}=GaveAnswer;

StartWritting=GetSecs;
%ask the participant to enter their reply.
reply=Ask(window,'Reponse?',NormalColor,BackgroundBlack,'GetChar','center','center');
EndWritting=GetSecs;

TempOutput{3}=reply;
TempOutput{4}=EndWritting-StartWritting;

if TempOutput{4}+TempOutput{1}>Time2Wait
    TakeAnswer=0;
else
    TakeAnswer=1;
end

TempOutput{5}=TakeAnswer;

OutputEuraka=TACfct.Eureka(window);

%Put the answer and their reaction time into the main variable.
TempOutput(6:8)=OutputEuraka;


end