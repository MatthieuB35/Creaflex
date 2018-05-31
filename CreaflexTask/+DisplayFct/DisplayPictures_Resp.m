function TempOutput=DisplayPictures_Resp(theImageLocation,window,FontSizeTrial,ColorWord,BackgroundWT,TimeThink,HowManyTimeAsk,Str2Ask,Time2Answer)


% Setup the text type for the window
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeTrial);

%Load the current picture
theImage = imread(theImageLocation);

%Create the texture for the display on the screen and draw it
imageTexture = Screen('MakeTexture', window, theImage);
Screen('DrawTexture', window, imageTexture, [], [], 0);

% Flip to the screen
Screen('Flip', window);

%Wait for 1 second
WaitSecs(TimeThink);

% get the time stamp at the start of waiting for key input
% so we can evaluate timeout
TimeStart = GetSecs;

% repeat until a valid key is pressed or we time out
TimeOut = false;

%Wait for the keypress or pass to the next part.
while ~TimeOut
    % check if a key is pressed
    % only keys specified in activeKeys are considered valid
    [ keyIsDown, keyTime, keyCode ] = KbCheck;
    if(keyIsDown), break; end
end

if HowManyTimeAsk==0
    TempOutput=(keyTime - TimeStart);
else
    TempOutput=cell(1,1+2*HowManyTimeAsk);
    TempOutput{1}=(keyTime - TimeStart);
    
    if TimeOut
        GaveAnswer=0;
    else
        GaveAnswer=1;
    end
    TempOutput{2}=GaveAnswer;
    
    TempCount=2;
    for WhichStr2Ask = 1:HowManyTimeAsk
        StartWritting=GetSecs;
        %ask the participant to enter their reply.
        %TimeLeft=Time2Wait-(StartWritting- TimeStart);
        %TimeLeft=Time2Answer; %5 seconds to answer the questions
        %reply=Ask(window,'Reponse?',NormalColor,BackgroundBlack,'GetChar','center','center');
        reply=DisplayFct.AskLimitTime(window,char(Str2Ask{WhichStr2Ask}),ColorWord,BackgroundWT,'GetChar','center','center',40,Time2Answer);
        EndWritting=GetSecs;
        
        TempOutput{TempCount+WhichStr2Ask}=reply;
        TempOutput{TempCount+1+WhichStr2Ask}=EndWritting-StartWritting;
        
        TempCount=TempCount+1;
    end

    
end


%ask the participant the number of uncorrect answer corrected auto
%reply_Part1=Ask(window,'EC?',ColorWord,BackgroundWT,'GetChar','center','center');

%ask the participant the number of uncorrect answer didn't corrected
%reply_Part2=Ask(window,'ENC?',ColorWord,BackgroundWT,'GetChar','center','center');


%ResponseTime{1,1}=(keyTime - TimeStart);
%ResponseTime{1,2}=str2double(reply_Part1);
%ResponseTime{1,3}=str2double(reply_Part2);