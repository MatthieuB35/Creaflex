function TempOutput=DisplayTrial_Resp(ListElements,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,ColorWord,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait,TypeResp,WhichChoice)


if strcmp(TypeResp,'keyboard')
    TempOutput=cell(1,4);
    WhichChoice=[];
elseif strcmp(TypeResp,'Choice')
    TempOutput=cell(1,3);
    if isempty(WhichChoice)
        error("No Choice implement! Check the parameters of task!")
    end
else
    error("Wrong type of input responses! Check in parameters of task. Only Keyboard & Choice implemented.")
end



DisplayFct.DisplayWords(ListElements,0,BackgroundWT,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,ColorWord)

%Wait for 0.5 second
WaitSecs(TimeThink);

DisplayFct.DisplayWords(ListElements,0,BackgroundWT,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,ColorWord)

% get the time stamp at the start of waiting for key input
% so we can evaluate timeout
TimeStart = GetSecs;

% repeat until a valid key is pressed or we time out
TimeOut = false;

while ~TimeOut
    % check if a key is pressed
    % only keys specified in activeKeys are considered valid
    [ keyIsDown, keyTime, keyCode ] = KbCheck;
    if(keyIsDown)
        if strcmp(TypeResp,'keyboard')
            StartWritting=GetSecs;
            %ask the participant to enter their reply.
            %TimeLeft=Time2Wait-(StartWritting- TimeStart);
            TimeLeft=5; %5 seconds to answer the questions
            %reply=Ask(window,'Reponse?',NormalColor,BackgroundBlack,'GetChar','center','center');
            reply=DisplayFct.AskLimitTime(window,'Reponse?',ColorWord,BackgroundWT,'GetChar','center','center',40,TimeLeft);
            EndWritting=GetSecs;
            break
        elseif strcmp(TypeResp,'Choice')
            if strcmp(KbName(find(keyCode)),WhichChoice{1})
                KeyPressedTemp=WhichChoice{1};
            elseif strcmp(KbName(find(keyCode)),WhichChoice{2})
                KeyPressedTemp=WhichChoice{2};
            end
            break
        end
    end
    %Two seconds before the end, fill the screen in grey
    if( (keyTime - TimeStart) > Time2Wait-2)
        DisplayFct.DisplayWords(ListElements,0,BackgroundNT,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,ColorWord)
    end
    if( (keyTime - TimeStart) > Time2Wait)
        TimeOut = true;
        reply='NONE';
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

if strcmp(TypeResp,'keyboard')
    TempOutput{3}=upper(reply); %Put reply in upper case
    
    if TimeOut
        TempOutput{4}=0;
    else
        TempOutput{4}=EndWritting-StartWritting;
    end
    
elseif strcmp(TypeResp,'Choice')
    TempOutput{3}=KeyPressedTemp;
end


%ITI of 500ms
WaitSecs(TimeITI);


end