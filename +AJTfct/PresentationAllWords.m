function PresentationAllWords(ListAllwords,HowManySecsPresent,HowManySecsITI,window,screenXpixels,screenYpixels)

AJTpar.Parameters

ModifyResolution=(screenYpixels/screenXpixels)+1;

%SizeFontModifyInstruct=round((screenXpixels-screenYpixels)*InstructFontChg*ModifyResolution);
SizeFontModifyInstruct=round(ModifyResolution*InstructFontChg);

for WhichWord = 1:length(ListAllwords)
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyInstruct);
    
    Screen('FillRect', window, [0 0 0]);
    WaitSecs(HowManySecsITI);
    
    CurrenWord=ListAllwords{WhichWord};
    
    %Draw the instructions on the screen
    DrawFormattedText(window,CurrenWord, 'center', 'center',NormalColor);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(HowManySecsPresent);
    
end

end