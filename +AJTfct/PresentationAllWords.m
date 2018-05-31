function Output=PresentationAllWords(ListAllwords,HowManySecsPresent,HowManySecsITI,window,screenXpixels,screenYpixels,WhichDevice,FirstSecond)

AJTpar.Parameters;

RestrictKeysForKbCheck([EscKey SpaceKey leftKey rightKey]);

ModifyResolution=(screenYpixels/screenXpixels)+1;

%SizeFontModifyInstruct=round((screenXpixels-screenYpixels)*InstructFontChg*ModifyResolution);
SizeFontModifyInstruct=round(ModifyResolution*InstructFontChg);

Output=cell(length(ListAllwords),3);

% Setup the text type for the window
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, SizeFontModifyInstruct);

if FirstSecond ==2
    Screen('FillRect', window, [0 0 0]);
    
    CurrenText='Vous n"avez pas compris certains mots. Veuillez \n appeller l"examinateur afin qu"il vous explique \n ceux que vous ne connaissez pas.';
    
    %Draw the instructions on the screen
    DrawFormattedText(window,CurrenText, 'center', 'center',NormalColor);
   
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(0.5);
    
    %Wait for the participant to press a button to continue
    KbWait;
    
    
end

for WhichWord = 1:length(ListAllwords)
    
    
    Screen('FillRect', window, [0 0 0]);
    WaitSecs(HowManySecsITI);
    
    CurrenWord=ListAllwords{WhichWord};
    Output{WhichWord,1}=CurrenWord;
    
    %Draw the instructions on the screen
    DrawFormattedText(window,CurrenWord, 'center', 'center',NormalColor);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(HowManySecsPresent);
    
    if strcmp(WhichDevice, 'mouse')
        %Set up the timer
        t0= GetSecs;
        %Set up the answer given at 0.
        answer= 0;
        while answer==0
            [~,~,buttons,~,~,~] = GetMouse(window, MouseDeviceIndex);
            secs = GetSecs;
            if buttons(responseKey) == 1
                answer = 1;
                TempResponse=1;
            elseif buttons(responseKeySecond) == 1
                answer = 1;
                TempResponse=0;
            end
        end
        Output{WhichWord,2}=TempResponse;
        Output{WhichWord,3}=secs-t0;
        
    elseif strcmp(WhichDevice, 'keyboard')
        [~, keyCode, deltaSecs]=KbWait;
        if strcmp(KbName(find(keyCode)),'LeftArrow')
            TempResponse=1;
        else
            TempResponse=0;
        end
        Output{WhichWord,2}=TempResponse;
        Output{WhichWord,3}=deltaSecs;
    end
    
    
    
end


RestrictKeysForKbCheck([]);

end