function Output=Eureka(window)

Output=cell(3,1);

TACpar.Parameters;

% Setup the text type for the training
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeEureka);

%Fill the screen in black
Screen('FillRect', window, BackgroundBlack);

%Ask the question to the participant if he gets a sudden response
DrawFormattedText(window, QuestionInstruction, 'center', 'center',NormalColor);

%Flip to the screen
Screen('Flip', window);

%Wait for 1 seconds
WaitSecs(0.5);

% get the time stamp at the start of waiting for key input
% so we can evaluate timeout
TimeStart = GetSecs;

% repeat until a valid key is pressed or we time out
TimeOut = false;

while ~TimeOut
    % check if a key is pressed
    % only keys specified in activeKeys are considered valid
    [ keyIsDown, keyTime, keyCode ] = KbCheck;
    if(keyIsDown), break; end
    
    %Two seconds before the end, fill the screen in grey
    if( (keyTime - TimeStart) > Time2Wait_Q-2)
        %Fill the screen in grey
        Screen('FillRect', window,BackgroundGrey);
        
        %Display again the question
        DrawFormattedText(window, QuestionInstruction, 'center', 'center',NormalColor);
        Screen('Flip', window);
    end
    if( (keyTime - TimeStart) > Time2Wait_Q), TimeOut = true; end
end

if TimeOut
    GaveAnswer=0;
else
    GaveAnswer=1;
end

%Transform the keycode pressed by the answer (V or N)
Output{1} = KbName(keyCode);
Output{2}=(keyTime - TimeStart);
Output{3}=GaveAnswer;

end