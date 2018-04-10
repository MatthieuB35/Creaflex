%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              TAC TASK
% Version: 2
% Last Edited: 28/02/2018
% Author: Matthieu Bernard
% Language of the task: French
% Description; Present three word to a participant and him to find the word
% that link all of them. After, ask if he get a sudden reponse (eureka).
% The participant has 30 sec to answer maximum
% There is 10 trials at the beggining for training purpose.
%
% Requires: - Psychtoolbox-3
%           - Two Word lists in csv: TAC_list & TAC_training
%           - The instruction(s) in txt file(s).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Start the function called TAC_Task
function [output] = TAC_Task(NumberItems)

%Change the seed for the random generator every time the function start
Seed_is = rng('shuffle');

%Set up the path where the list of the words are stored.
path='/Users/clarisseaichelburg/Documents/Master2-MatthieuB/Taches CreaFlex/TAC';

%Define the parameters used in the task
EncodingCSV='UTF-8'; %Specify the encoding of the csv file
EncodingTxT='Macintosh';%Specify the encoding of the txt file
InstructionScreensPart1=6; %How many instruction display before training
InstructionScreensPart2=1; %How many instruction display after training
Time2Wait=29; %How many seconds to wait for trial (always +1)
Time2Wait_Q=4; %How many seconds to wait for "eureka" (always +1)
WhenPause=round(NumberItems/4);%Decide the number of trial before to pause, if not integer, round the number to superior
CountPauseSet=0; %Set up Pause counter
NumberTraining=10; %Define the number of training items (max10)
StartAnswer=5; %Define the columns where the first "answer" is store
EndAnswer=28; %Define the columns where the last "answer" is store
FontSizeInstruct=30; %Define the size of the font for the instructions
FontSizeTrial=40; %Define the size of the font for the cues words in the trials

%Import the list of the words and create a variable to contain it.
%C1; Trial number |C2; Word cue 1 |C3; Word cue 2 |C4; Word cue 3
%C5:28; """Correct Response""" |C29; Semantic distance btw words, D=distal
%P=proximal
TAC_list=table2array(readtable([path '/TAC_list.csv'],'ReadVariableNames',true,'FileEncoding',EncodingCSV));

%Import the training list of the words and create a variable to contain it.
TAC_training=table2array(readtable([path '/TAC_training.csv'],'ReadVariableNames',true,'FileEncoding',EncodingTxT));

%Shuffle the trials (rows)
%The answers will be stock there;
%C30; temps de réflexion (prend pas en compte de taper la réponse)
%C31; Trop de temps =1 | C32; Réponse écrite par le participant
%C33; If the Answer is correct | C34; Which substet
%C35; Oui (V) ou Non (N) pour Eureka | C36 ; Temps de réflexion
%C37 ; trop de temps = 1
TACshuffled=TAC_list(randperm(size(TAC_list,1)),:);

%Silent the input from keyboard
ListenChar(2)

%Specify the only key enable for the task (space bar, y , n)
%RestrictKeysForKbCheck([44, 25, 17]);

%Question if get a "eureka"
QuestionInstruction='Est ce que votre réponse est apparue d''un coup, sans effort (Eureka)? \n \n Répondez avec les touches V (oui) ou N (non) du clavier.';

%%
%Call some default settings for setting up Psychtoolbox or Debug mode
%PsychDefaultSetup(2);
PsychDebugWindowConfiguration

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% Select the screen where the task will be display. If two screen, it will
% be on external.
screenNumber = 0;%max(screens);

% Define black and white.
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Setup the text type for the instructions
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeInstruct);

% Get the center coordinate of the window
rect= [ 0 0 screenXpixels screenYpixels]; %Dimension of the screen
center = round([rect(3) rect(4)]/2); %Center of the screen

%Define the position where the words will be presented.
LeftScreenPosition=rect(3)*0.4;
RightScreenPosition=rect(3)*0.6;
TopScreenPosition=rect(4)*0.35;
BottomScreenPosition=rect(4)*0.6;

%%
%Instruction
for InstructionNumberPart1= 1:InstructionScreensPart1
    
    %Import the data for the instruction
    TempInstructionFilePart1 = fopen([path '/Instruction_' num2str(InstructionNumberPart1) '.txt'],'r+','n',EncodingTxT);
    
    %Scan all the lines of the instructions and put it in a variable
    TempInstructionPart1 = textscan(TempInstructionFilePart1,'%s','delimiter','\n');
    
    %Close the file
    fclose(TempInstructionFilePart1);
    
    %Draw the instructions on the screen
    DrawFormattedText(window,strrep(strjoin(TempInstructionPart1{1}),'`',''''), 'center', 'center',white);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(0.5)
    
    %Wait for the participant to press a button to continue
    KbWait;
    
end

% Setup the text type for the training
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeTrial);

%Start the loop for the test that will go for the number of items desired
for WhichIteration_training = 1:NumberTraining
    
    %Clear line command
    clc
    
    textString_Top = char(TAC_training{WhichIteration_training,2});
    textString_Left = char(TAC_training{WhichIteration_training,3});
    textString_Right = char(TAC_training{WhichIteration_training,4});
    
    %Define the textBounds for the left item in order to change its
    %position accordingly.
    [~, ~, textBounds]=DrawFormattedText(window, textString_Left, LeftScreenPosition, BottomScreenPosition,white); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, [0 0 0])
    
    %Draw the three words. The test item, in the top center. The two choice
    %items will be on the left and right bottom.
    DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,white); %Center item
    DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,white); %Left item
    DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,white); %Right item
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait for 1 second
    WaitSecs(1)
    
    %Draw the three words. The test item, in the top center. The two choice
    %items will be on the left and right bottom.
    DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,white); %Center item
    DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,white); %Left item
    DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,white); %Right item
    DrawFormattedText(window, '?', 'center','center',white); %Question mark
    
    %Flip to the screen
    Screen('Flip', window);
    
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
        if( (keyTime - TimeStart) > Time2Wait-2)
            
            %Fill the screen in grey
            Screen('FillRect', window, [127 127 127]);
            
            %Draw the three words. The test item, in the top center. The two choice
            %items will be on the left and right bottom.
            DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,white); %Center item
            DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,white); %Left item
            DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,white); %Right item
            Screen('Flip', window);
        end
        if( (keyTime - TimeStart) > Time2Wait), TimeOut = true; end
    end
    
    %Put the time of answer in the variable
    TAC_training{WhichIteration_training,7}=keyTime - TimeStart;
    TAC_training{WhichIteration_training,8}=TimeOut;
    
    %ask the participant to enter their reply.
    reply=Ask(window,'Réponse?',white,black,'GetChar','center','center');
    
    TAC_training{WhichIteration_training,9}=reply;
    
    %Fill the screen in black
    Screen('FillRect', window, black);
    
    %Ask the question to the participant if he gets a sudden response
    DrawFormattedText(window, QuestionInstruction, 'center', 'center',white);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait for 1 seconds
    WaitSecs(1)
    
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
            Screen('FillRect', window, [127 127 127]);
            
            %Display again the question
            DrawFormattedText(window, QuestionInstruction, 'center', 'center',white);
            Screen('Flip', window);
        end
        if( (keyTime - TimeStart) > Time2Wait_Q), TimeOut = true; end
    end
    
    %Transform the keycode pressed by the answer (V or N)
    kbNameResult = KbName(keyCode);
    
    %Put the answer and their reaction time into the main variable.
    TAC_training{WhichIteration_training,10}=kbNameResult;
    TAC_training{WhichIteration_training,11}=(keyTime - TimeStart);
    TAC_training{WhichIteration_training,12}=TimeOut;
end

% Setup the text type for the instructions
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeInstruct);

%Instruction
for InstructionNumberPart2= 1:InstructionScreensPart2
    
    %Import the data for the instruction
    TempInstructionFilePart1 = fopen([path '/Instruction_' num2str(InstructionNumberPart2+InstructionScreensPart1) '.txt'],'r+','n',EncodingTxT);
    
    %Scan all the lines of the instructions and put it in a variable
    TempInstructionPart1 = textscan(TempInstructionFilePart1,'%s','delimiter','\n');
    
    %Close the file
    fclose(TempInstructionFilePart1);
    
    %Draw the instructions on the screen
    DrawFormattedText(window,strrep(strjoin(TempInstructionPart1{1}),'`',''''), 'center', 'center',white);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(0.5)
    
    %Wait for the participant to press a button to continue
    KbWait;
    
end

% Setup the text type for the training
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeTrial);

%Start the loop for the test that will go for the number of items desired
for WhichIteration = 1:NumberItems
    
    %Clear line command
    clc
    
    %Place in temporary string, the name of the cues words.
    textString_Top = char(TACshuffled{WhichIteration,2});
    textString_Left = char(TACshuffled{WhichIteration,3});
    textString_Right = char(TACshuffled{WhichIteration,4});
    
    %Define the textBounds for the left item in order to change its
    %position accordingly.
    [~, ~, textBounds]=DrawFormattedText(window, textString_Left, LeftScreenPosition, BottomScreenPosition,white); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, [0 0 0])
    
    %Draw the three words on the screen.
    DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,white); %Center item
    DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,white); %Left item
    DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,white); %Right item
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait for 1 second
    WaitSecs(1)
    
    %Draw the three words. The test item, in the top center. The two choice
    %items will be on the left and right bottom.
    DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,white); %Center item
    DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,white); %Left item
    DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,white); %Right item
    DrawFormattedText(window, '?', 'center','center',white); %Question mark;TopScreenPosition + 100
    
    %Flip to the screen
    Screen('Flip', window);
    
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
        if( (keyTime - TimeStart) > Time2Wait-2)
            
            %Fill the screen in grey
            Screen('FillRect', window, [127 127 127]);
            
            %Draw the three words. The test item, in the top center. The two choice
            %items will be on the left and right bottom.
            DrawFormattedText(window, textString_Top, 'center', TopScreenPosition,white); %Center item
            DrawFormattedText(window, textString_Left, LeftScreenPosition-DisplaceText, BottomScreenPosition,white); %Left item
            DrawFormattedText(window, textString_Right, RightScreenPosition, BottomScreenPosition,white); %Right item
            Screen('Flip', window);
        end
        if( (keyTime - TimeStart) > Time2Wait), TimeOut = true; end
    end
    
    %Put the time of answer in the variable
    TACshuffled{WhichIteration,30}=keyTime - TimeStart;
    TACshuffled{WhichIteration,31}=TimeOut;
    
    %ask the participant to enter their reply.
    reply=Ask(window,'Réponse?',white,black,'GetChar','center','center');
    
    %Store the reply
    TACshuffled{WhichIteration,32}=reply;
    
    %Check if the answer is correct:
    for CorrectAnswer = StartAnswer:EndAnswer
        if CorrectAnswer ~= EndAnswer
            if strcmp(TACshuffled(WhichIteration,CorrectAnswer),reply)
                CorrectOrNot=1;
                WhichSet=CorrectAnswer;
                break
            end
        else
            if strcmp(TACshuffled(WhichIteration,CorrectAnswer),reply)
                CorrectOrNot=1;
                WhichSet=CorrectAnswer;
                break
            else
                CorrectOrNot=0;
                WhichSet='none';
            end
        end
    end
    %Store if the answer was correct and in which set the response was
    %taken
    TACshuffled{WhichIteration,33}=CorrectOrNot;
    TACshuffled{WhichIteration,34}=WhichSet;
    
    
    %Fill the screen in black
    Screen('FillRect', window, black);
    
    %Ask the question to the participant if he gets a sudden response
    DrawFormattedText(window, QuestionInstruction, 'center', 'center',white);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait for 1 seconds
    WaitSecs(1)
    
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
            Screen('FillRect', window, [127 127 127]);
            
            %Display again the question
            DrawFormattedText(window, QuestionInstruction, 'center', 'center',white);
            Screen('Flip', window);
        end
        if( (keyTime - TimeStart) > Time2Wait_Q), TimeOut = true; end
    end
    
    %Transform the keycode pressed by the answer (V or N)
    kbNameResult_temp = KbName(keyCode);
    
    if strcmp(kbNameResult_temp,'v')
        kbNameResult=1;
    else
        kbNameResult=0;
    end
    %Put the answer and their reaction time into the main variable.
    TACshuffled{WhichIteration,35}=kbNameResult;
    TACshuffled{WhichIteration,36}=(keyTime - TimeStart);
    TACshuffled{WhichIteration,37}=TimeOut;
    
    CountPauseSet=CountPauseSet+1;
    if WhenPause==CountPauseSet
        PauseText='Vous pouvez maintenant prendre une pause. \n Appuyez sur la barre "Espace" pour continuer le test.';
        CountPauseSet=0;
        
        %Ask the question to the participant if he gets a sudden response
        DrawFormattedText(window, PauseText, 'center', 'center',white);
        
        %Flip to the screen
        Screen('Flip', window);
        
        %Wait for 1 seconds
        WaitSecs(2)
        
        %Wait for input of the participant
        KbWait
    end
    
end

%%
% Setup the text type for the final message
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeInstruct);

%Flip to the screen

%Wait 1 seconds to ensure the slide don't skip.
WaitSecs(1)

%Calculated the score and create the sentence to be place on the screen
Calc_score=sum([TACshuffled{:,33}])/NumberItems*100;
Score_text=['Vous avez obtenu un score de ', num2str(Calc_score),'% !'];

%Draw the instructions on the screen
DrawFormattedText(window,Score_text, 'center', 'center',white);

%Flip to the screen
Screen('Flip', window);

%Wait 0.5 seconds to ensure the slide don't skip.
WaitSecs(0.5)

%Wait for the participant to press a button to continue
KbWait;

%Calculated the score of eureka and create the sentence to be place on the screen
Eureka_WhenCorrect=[TACshuffled{find([TACshuffled{:,33}]==1),35}];
Calc_EurekaCorrect_score=sum(Eureka_WhenCorrect)/size(Eureka_WhenCorrect,2)*100;
Score_EurekaCorrect_text=['Vous aviez ', num2str(Calc_EurekaCorrect_score),'% d''Eureka lorsque vous aviez \n eu la bonne réponse !'];

%Draw the instructions on the screen
DrawFormattedText(window,Score_EurekaCorrect_text, 'center', 'center',white);

%Flip to the screen
Screen('Flip', window);

%Wait 0.5 seconds to ensure the slide don't skip.
WaitSecs(0.5)

%Wait for the participant to press a button to continue
KbWait;

%%
%Create a last structure containing the seed of random number generator,
%the word list as well as the answers given.
output=struct('Seed',Seed_is,'TAC_Order', {TACshuffled},'TAC_training',{TAC_training});

%Clear line command
clc

%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
sca;

end

