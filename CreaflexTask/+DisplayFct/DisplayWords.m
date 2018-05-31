function DisplayWords(ListElements,Question,Background,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,ColorWord)

HowManyElements=length(ListElements);

% Setup the text type for the training
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeTrial);

if ischar(ListElements)
  
    DrawFormattedText(window, ListElements, 'center', 'center',ColorWord);
    
elseif HowManyElements == 1
    
    textString = char(ListElements{1});
    
    %Draw the word on the middle of the screen.
    DrawFormattedText(window, textString, 'center', 'center',ColorWord);
    
elseif HowManyElements == 2
    
    textString_Left = char(ListElements{1});
    textString_Right = char(ListElements{2});
    
    %Define the textBounds for the left item in order to change its
    %position accordingly.
    [~, ~, textBounds]=DrawFormattedText(window, textString_Left, LeftScreenPosition, 'center',ColorWord); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, Background);
    
    %Draw the word on the middle of the screen.
    DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, 'center',ColorWord);
    DrawFormattedText(window, textString_Right, RightScreenPosition, 'center',ColorWord);
    
elseif HowManyElements == 3
    
    textString_Top = char(ListElements{1});
    textString_Left = char(ListElements{2});
    textString_Right = char(ListElements{3});
    
    %Define the textBounds for the left item in order to change its
    %position accordingly.
    [~, ~, textBounds]=DrawFormattedText(window, textString_Left, LeftScreenPosition, BottomScreenPosition,ColorWord); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, Background);
    
    %Draw the three words. The test item, in the top center. The two choice
    %items will be on the left and right bottom.
    DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,ColorWord); %Center item
    DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,ColorWord); %Left item
    DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,ColorWord); %Right item
    if Question==1
        DrawFormattedText(window, '?', 'center','center',ColorWord); %Question mark
    end
    
    
end

Screen('Flip', window);

end