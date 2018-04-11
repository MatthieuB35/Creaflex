function DisplayTAC(ListElements,Question,Background,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition)

TACpar.Parameters

% Setup the text type for the training
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeTrial);

textString_Top = char(ListElements{1});
textString_Left = char(ListElements{2});
textString_Right = char(ListElements{3});

%Define the textBounds for the left item in order to change its
%position accordingly.
[~, ~, textBounds]=DrawFormattedText(window, textString_Left, LeftScreenPosition, BottomScreenPosition,NormalColor); %Left item
DisplaceText=textBounds(3)-textBounds(1);

%Fill the screen in black
Screen('FillRect', window, Background);

%Draw the three words. The test item, in the top center. The two choice
%items will be on the left and right bottom.
DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,NormalColor); %Center item
DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,NormalColor); %Left item
DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,NormalColor); %Right item
if Question==1
    DrawFormattedText(window, '?', 'center','center',NormalColor); %Question mark
end

%Flip to the screen
Screen('Flip', window);

end