%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              AJT TASK B
% Version: 4.5
% Last Edited: 21/03/2018
% Author: Matthieu Bernard (modified by MO)
% Language of the task: French
% Description; Present on screen for X seconds a pair of words and ask the
% participant to rate in a scale to 0 to 100, how he think the
% words are related or not. Participants need to repond in 2s.
% Can also create files where the combination between the words are if
% necessary.
%
% Requires: - Psychtoolbox-3
%           - The 3 mat files (for training and the two pilot nodes sets)
%           - Instructions files
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear the workspace and the screen
sca;
close all;
clearvars;
KbName('UnifyKeyNames') % cross compatibility

%Create a input box where the experimenter can enter the different
%parameter
prompt = {'Numero du participant?','Only creation set?','Combien de training moteur?','Combien de training normal?','Combien de trials?','Screen Output? [Testing OR CENIR OR CENIRb]'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0','0','50','10','100','Testing'};
AnswerStart = inputdlg(prompt,dlg_title,num_lines,defaultans);

%Change the seed for the random generator every time the function start
Seed_is = rng('shuffle');

%%
%Set up the path where the list of the words are stored.
path=[pwd '/'];

%Define the parameters used in the task
CreationOnlySet=str2num(AnswerStart{2}); %Decide if should only create a set
NumberMotorvisuo=str2num(AnswerStart{3}); %Define the number of training of motor
NumberItemsTraining=str2num(AnswerStart{4}); %Define the number of normal training
NumberItems = str2num(AnswerStart{5}); %Define the number of item to test
WhichScreen= AnswerStart{6}; %Define the screen where the display should be on
lineLength    = 10; %Line length of the scale
width         = 5; %Width fo the scale
scalaLength   = 0.6; %Length of the marker in the scale
scalaPosition = 0.5; %Position of the marker in the scale
sliderColor    = [255 0 0]; % color of the slider; Red
lineLengthSlider= 20; %Length of the slider
scaleColor = [0 255 0]; %Color of the scale; grey
wordColor = [255 255 0]; %Color of the word when need to choose; Yellow
device = 'mouse'; %Which device to use the scale. 
if strcmp(WhichScreen,'Testing')
    OutputScreen= 0; %Testing
    aborttime     = 2; %Abort time for the training and task
    aborttimeNumber = 2; %Abort time for the motor training
elseif strcmp(WhichScreen,'CENIR')
    OutputScreen= 1; %CENIR scanner
    aborttime     = 2; %Abort time for the training and task
    aborttimeNumber = 2; %Abort time for the motor training
elseif strcmp(WhichScreen,'CENIRb')
    OutputScreen= 3;% CENIR Benoit Windows
    aborttime     = 2; %Abort time for the training and task
    aborttimeNumber = 2; %Abort time for the motor training
end
TimeToThink=2; %Decide the number of seconds where participants have the time to think
responseKey   = KbName('return'); %Return the keycode for the key 'return'
startPosition = 'center'; %Select the start position of the cursor
endPoints={'0 = Pas du tout Lié', '100= Complètement lié'}; %Which word there is at the end of the scale
InstructionScreensPart1=2; %Instruction at the beginning
InstructionScreensPart2=2; %Instruction after motor training and before normal training
InstructionScreensPart3=1; %Instruction after normal training and experiment
EncodingInstruction='UTF-8'; %Specify the encoding of the instruction file
EncodingFile='Macintosh'; %Specify the encoding of the txt file
WhenPause=NumberItems/4; %Decide when to pause
CountPauseSet=0; %Counter for the pause
leftKey = KbName('LeftArrow'); %GetName of left arrow in keyboard
rightKey = KbName('RightArrow'); %GetName of right arrow in keyboard
pixelsPerPress = 10; % Movement of pixel per change if keyboard
PercentToMove=0.05; %Percent to move the cursor before can do something
InstructFontChg=0.07; %Modify the font size of the instruction
CuesFontChg=0.09; %Modify the font size of the cues
EndPointsFontChg=0.03; %Modify the font size of the end points
EndPointsPositionYChg=0.05; %Modify the Y position of the end points
EndPointsPositionXChg=0.16; %Modify the X position of the end points
CuesPositionYChg=0.75; %Modify the Y position of the cues
MouseSpeedFactor = 1.5; %Define the parameter of the speed of the mouse 

%%
%%%Create all the possible pairs of words by using a number associated with
%%%each word (there index in the variable)
if CreationOnlySet==1
    %Import the list of the words and create a variable to contain it.
    %Import the data for the instruction
    WordBenedekFile = fopen([path 'AJT_listNounsOnly.txt'],'r+','n',EncodingFile);
    
    %Scan all the lines of the instructions and put it in a variable
    WordBenedek_list = textscan(WordBenedekFile,'%s','delimiter','\n');
    
    %Close the file
    fclose(WordBenedekFile);
    
    %The number associated with the word
    WordBenedek_list_number=1:length(WordBenedek_list{1});
    
    %/!!!!!!\ OFF FOR PILOT VERSION; take pre-established filed
    AllWordPairs = nchoosek(WordBenedek_list_number,2);
    
    %Shuffle the pairs randomly.
    AllWordPairs_suffled = AllWordPairs(randperm(size(AllWordPairs,1)),:);
    
    %Use a function that will checked if there is no consecutive number (i.e.
    %word)
    New_WordPair_shuffled=ConsecutivePaired(AllWordPairs_suffled,20);
    
    %Create a empty variable that will contained the pairs of the real word.
    WordList_shuffle_check=cell(size(New_WordPair_shuffled));
    
    %Start the loop that will go through all the pairs and replace the number
    %by the associated word.
    for ReplaceNbrWord = 1:length(New_WordPair_shuffled)
        WordList_shuffle_check{ReplaceNbrWord,1}=WordBenedek_list{1}(New_WordPair_shuffled(ReplaceNbrWord,1));
        WordList_shuffle_check{ReplaceNbrWord,2}=WordBenedek_list{1}(New_WordPair_shuffled(ReplaceNbrWord,2));
    end
    
    %save('AJTList_shuffle_DefaultNounsOnly1.mat','WordList_shuffle_check')
    ListenChar(0)
    
    return
end

%%
%Create a input box where the experimenter choose which subset to use (for
%the pilot version)
prompt = {'Which subset? [default OR nouns]'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'default'};
AnswerTask = inputdlg(prompt,dlg_title,num_lines,defaultans);

%/!!!!!!\ PILOT VERSION; 100 TRIALS
Type=AnswerTask{1}; %Define the type of experiment (either verbal or button)

if strcmp(Type,'default')
    WordList_AllTrial=importdata([path 'AJTList_shuffle_DefaultNounsOnly1.mat']);
elseif strcmp(Type,'nouns')
    WordList_AllTrial=importdata([path 'AJTList_shuffle_DefaultSelect1.mat']);
end

WordList_Training=importdata([path 'AJTList_shuffle_Pilot.mat']);

WordList_shuffle_check=[WordList_AllTrial{1:100,1};WordList_AllTrial{1:100,2}]';

%Create 3 variables where the answers will be store
Answer_given_motor=NaN(NumberMotorvisuo,4);
Answer_given_training=NaN(NumberItemsTraining,3);
Answer_given_WordPair=NaN(NumberItems,3);


%%
%Call some default settings for setting up Psychtoolbox or Debug mode
PsychDefaultSetup(2);

%Silent the input from keyboard
ListenChar(2)

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = OutputScreen; % max(screens);

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow',screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the center coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
rect= [ 0 0 screenXpixels screenYpixels]; %Dimension of the screen
center= round([rect(3) rect(4)]/2); %Center of the screen
squareX = xCenter;

%Modification of the fontsize of the instruction,cues and endpoints
SizeFontModifyInstruct=round((screenXpixels-screenYpixels)*InstructFontChg);
SizeFontModifyCues=round((screenXpixels-screenYpixels)*CuesFontChg);
SizeFontModifyEndPoints=round((screenXpixels-screenYpixels)*EndPointsFontChg);

%Define the left and right position of the cues
LeftScreenPosition=rect(3)*0.4;
RightScreenPosition=rect(3)*0.6;

%%
%Define the response key depending if use mouse or keyboard
if strcmp(device, 'mouse')
    responseKey   = 1; % X mouse button
elseif strcmp(device, 'keyboard')
    responseKey   = 88; % Enter on the keyboard
end

% Coordinates of scale lines and text bounds
if strcmp(startPosition, 'right')
    x = rect(3)*scalaLength;
elseif strcmp(startPosition, 'center')
    x = center(1);
elseif strcmp(startPosition, 'left')
    x = rect(3)*(1-scalaLength);
else
    error('Only right, center and left are possible start positions');
end

%Define different variable that will create the scale.
SetMouse(round(x), round(rect(4)*scalaPosition));
midTick    = [center(1) rect(4)*scalaPosition - lineLength - 5 center(1) rect(4)*scalaPosition  + lineLength + 5];
leftTick   = [rect(3)*(1-scalaLength) rect(4)*scalaPosition - lineLength rect(3)*(1-scalaLength) rect(4)*scalaPosition  + lineLength];
rightTick  = [rect(3)*scalaLength rect(4)*scalaPosition - lineLength rect(3)*scalaLength rect(4)*scalaPosition  + lineLength];
horzLine   = [rect(3)*scalaLength rect(4)*scalaPosition rect(3)*(1-scalaLength) rect(4)*scalaPosition];
textBounds = [Screen('TextBounds', window, endPoints{1}); Screen('TextBounds', window, endPoints{2})];

%Hide the cursor during the experiment
HideCursor;

%%First part of the instructions
for InstructionNumberPart1= 1:InstructionScreensPart1
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyInstruct);
    
    %Import the data for the instruction
    TempInstructionFile = fopen([path 'Instruction_' num2str(InstructionNumberPart1) '.txt'],'r+','n',EncodingInstruction);
    
    %Scan all the lines of the instructions and put it in a variable
    TempInstruction = textscan(TempInstructionFile,'%s','delimiter','\n');
    
    %Close the file
    fclose(TempInstructionFile);
    
    %Draw the instructions on the screen
    DrawFormattedText(window, strrep(strjoin(TempInstruction{1}),'`',''''), 'center', 'center',white);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(0.5)
    
    %Wait for the participant to press a button to continue
    KbWait;
    
end

%%Moto-visuo training
for WhichIterationNumber = 1:NumberMotorvisuo
    
    %Select a random number between 1 and 100.
    NumberTemp=unidrnd(100,1);
        
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyCues);
    
    % Drawing the number
    DrawFormattedText(window,num2str(NumberTemp),'center', rect(4)*(scalaPosition*CuesPositionYChg),white);%-midTick(1, 1)/4-100   - 0.15 )
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyEndPoints);
    
    % Drawing the end points of the scala as text
    DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
    DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
    
    % Drawing the scala
    Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
    Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
    Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
    Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
    
    Screen('Flip', window);
    
    %Wait for X seconds, depending of the time need to think
    WaitSecs(TimeToThink)
    
    %Set up the timer
    t0= GetSecs;
    
    %Set up the answer given at 0.
    answer= 0;
    
    %Set up the position of the mouse in the middle
    SetMouse(xCenter,yCenter,window)
    
    %Initialize the speed of the mouse 
    x_prev = xCenter;
    
    %While the response has not been given, continue the current trial
    %until it reachs the maximum time.
    while answer == 0
        %Check if task uses a mouse or keyboard
        if strcmp(device, 'mouse')
            %Get the position of the mouse
            [x,~,buttons,~,~,~] = GetMouse(window, 1);
        elseif strcmp(device, 'keyboard')
            %Check the keyboard
            [keyIsDown,~, keyCode] = KbCheck;
            %Change the position of the cursor using left and right arrows
            if keyCode(leftKey)
                x = x - pixelsPerPress;
            elseif keyCode(rightKey)
                x = x + pixelsPerPress;
            end
        end
        
        %Change the speed of the cursor
        dx = x - x_prev;
        x = x_prev + dx*MouseSpeedFactor;
        
        %Verifiy the position of the cursos stay in the maximum bounds.
        if x > rect(3)*scalaLength
            x = rect(3)*scalaLength;
        elseif x < rect(3)*(1-scalaLength)
            x = rect(3)*(1-scalaLength);
        end
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyCues);
        
        %Draw the number in the center of the screen above the scale
        DrawFormattedText(window,num2str(NumberTemp),'center', rect(4)*(scalaPosition*CuesPositionYChg),wordColor);%-midTick(1, 1)/4-100   - 0.15 )
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyEndPoints);
        
        % Drawing the end points of the scala as text
        DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
        DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
        
        % Drawing the scala
        Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
        Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
        Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
        Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
        
        % The slider
        Screen('DrawLine', window, sliderColor, x, rect(4)*scalaPosition - lineLengthSlider, x, rect(4)*scalaPosition  + lineLengthSlider, width);
        
        % Flip screen
        onsetStimulus = Screen('Flip', window);
        
        % Check if answer has been given
        if strcmp(device, 'mouse')
            secs = GetSecs;
            if buttons(responseKey) == 1
                answer = 1;
            end
        elseif strcmp(device, 'keyboard')
            secs = GetSecs; %[keyIsDown, secs, keyCode] = KbCheck;
            if keyCode(responseKey) == 1
                answer = 1;
            end
        else
            error('Unknown device');
        end
        
        %Abort if answer takes too long
        if secs - t0 > aborttimeNumber
            break
        end
    end
    %Display in the command windows the
    disp(['For iteration' num2str(WhichIterationNumber) 'answer=' num2str(answer)]);
    
    % converting RT to seconds
    RT=  secs - t0;
    
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
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyCues);
    
    %Give an output of the position of the cursor
    Screen('FillRect', window, [0 0 0])
    DrawFormattedText(window,['Position du curseur: ' num2str(position)],'center', 'center',white);
    Screen('Flip', window);
    
    %Enter the answer in the scale, the reaction time and if the
    %participant answered into the variable
    Answer_given_motor(WhichIterationNumber,1)=NumberTemp;
    Answer_given_motor(WhichIterationNumber,2:4)=[position, RT, answer];
    
    %Wait for 1 secon   ds before the next trial
    WaitSecs(1)
    
end

%%Second part of the instructions
for InstructionNumberPart2= 1:InstructionScreensPart2
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyInstruct);
    
    %Import the data for the instruction
    TempInstructionFile = fopen([path 'Instruction_' num2str(InstructionNumberPart2+InstructionScreensPart1) '.txt'],'r+','n',EncodingInstruction);
    
    %Scan all the lines of the instructions and put it in a variable
    TempInstruction = textscan(TempInstructionFile,'%s','delimiter','\n');
    
    %Close the file
    fclose(TempInstructionFile);
    
    %Draw the instructions on the screen
    DrawFormattedText(window, strrep(strjoin(TempInstruction{1}),'`',''''), 'center', 'center',white);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(0.5)
    
    %Wait for the participant to press a button to continue
    KbWait;
    
end

%%Normal training
for WhichIterationTraining = 1:NumberItemsTraining
    
    %Select a random number between 1 and 2.
    LeftOrRight_rnd=unidrnd(2,1);
    
    %If the number is one, the first item will be on the left and the
    %second on the right.
    %If the number is two, it will be the opposite.
    if LeftOrRight_rnd==1
        textString_Left_CurrIt = char(WordList_Training{WhichIterationTraining,1});
        textString_Right_CurrIt = char(WordList_Training{WhichIterationTraining,2});
    else
        textString_Left_CurrIt = char(WordList_Training{WhichIterationTraining,2});
        textString_Right_CurrIt = char(WordList_Training{WhichIterationTraining,1});
    end

    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyCues);
    
    %Draw the left item to get the size of the string so it can moved and
    %leave the same space between the two cues for each trial
    [~, ~, textBounds]=DrawFormattedText(window,textString_Left_CurrIt,LeftScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),white); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, [0 0 0])
    
    % Drawing the two cues as text
    DrawFormattedText(window, textString_Left_CurrIt,LeftScreenPosition-DisplaceText, rect(4)*(scalaPosition*CuesPositionYChg),white);
    DrawFormattedText(window, textString_Right_CurrIt,RightScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),white);
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyEndPoints);
    
    % Drawing the end points of the scala as text %textBounds(1, 3) -
    %   - rightTick(1, 1)/2
    DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
    DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
    
    % Drawing the scala
    Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
    Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
    Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
    Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
    
    Screen('Flip', window);
    
    %Wait for X seconds, depending of the time need to think
    WaitSecs(TimeToThink)
    
    %Set up the timer
    t0= GetSecs;
    
    %Set up the answer given at 0.
    answer= 0;
    %Set up the cheking of the movement of the cursor at 0
    Moved=0;
    %Set up the position of the mouse in the middle
    SetMouse(xCenter,yCenter,window)
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
            [x,~,buttons,~,~,~] = GetMouse(window, 1);
        elseif strcmp(device, 'keyboard')
            %Check the keyboard
            [keyIsDown,~, keyCode] = KbCheck;
            %Change the position of the cursor using left and right arrows
            if keyCode(leftKey)
                x = x - pixelsPerPress;
            elseif keyCode(rightKey)
                x = x + pixelsPerPress;
            end
        end
        
        %Change speed for cursor
        dx = x - x_prev;
        x = x_prev + dx*MouseSpeedFactor;
        
        %Verifiy the position of the cursos stay in the maximum bounds.
        if x > rect(3)*scalaLength
            x = rect(3)*scalaLength;
        elseif x < rect(3)*(1-scalaLength)
            x = rect(3)*(1-scalaLength);
        end
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyCues);
        
        %Draw the left item to get the size of the string so it can moved and
        %leave the same space between the two cues for each trial
        [~, ~, textBounds]=DrawFormattedText(window,textString_Left_CurrIt,LeftScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),white); %Left item
        DisplaceText=textBounds(3)-textBounds(1);
        
        %Fill the screen in black
        Screen('FillRect', window, [0 0 0])
        
        % Drawing the two cues as text
        DrawFormattedText(window, textString_Left_CurrIt,LeftScreenPosition-DisplaceText, rect(4)*(scalaPosition*CuesPositionYChg),wordColor);
        DrawFormattedText(window, textString_Right_CurrIt,RightScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),wordColor);
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyEndPoints);
        
        % Drawing the end points of the scala as text
        DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
        DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
        
        % Drawing the scala
        Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
        Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
        Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
        Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
        
        % The slider
        Screen('DrawLine', window, sliderColor, x, rect(4)*scalaPosition - lineLengthSlider, x, rect(4)*scalaPosition  + lineLengthSlider, width);
        
        % Flip screen
        onsetStimulus = Screen('Flip', window);
        
        % Check if answer has been given and if the cursos has moved a
        % little
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
    
    %Display in the command windows the
    disp(['For iteration' num2str(WhichIterationTraining) 'answer=' num2str(answer)]);
    
    %Wait for 1 seconds before the next trial
    WaitSecs(0.5)
    
    % converting RT to seconds
    RT= secs - t0;
    
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
    
    %Enter the answer in the scale, the reaction time and if the
    %participant answered into the variable
    Answer_given_training(WhichIterationTraining,:)=[position, RT, answer];
    
end

%%Third part of the instructions
for InstructionNumberPart3= 1:InstructionScreensPart3
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyInstruct);
    
    %Import the data for the instruction
    TempInstructionFile = fopen([path 'Instruction_' num2str(InstructionScreensPart3+InstructionNumberPart2+InstructionScreensPart1) '.txt'],'r+','n',EncodingInstruction);
    
    %Scan all the lines of the instructions and put it in a variable
    TempInstruction = textscan(TempInstructionFile,'%s','delimiter','\n');
    
    %Close the file
    fclose(TempInstructionFile);
    
    %Draw the instructions on the screen
    DrawFormattedText(window, strrep(strjoin(TempInstruction{1}),'`',''''), 'center', 'center',white);
    
    %Flip to the screen
    Screen('Flip', window);
    
    %Wait 0.5 seconds to ensure the slide don't skip.
    WaitSecs(0.5)
    
    %Wait for the participant to press a button to continue
    KbWait;
    
end

%%Start the loop for the test that will go for the number of items desired
for WhichIteration = 1:NumberItems
    
    %Select a random number between 1 and 2.
    LeftOrRight_rnd=unidrnd(2,1);
    
    %If the number is one, the first item will be on the left and the
    %second on the right.
    %If the number is two, it will be the opposite.
    if LeftOrRight_rnd==1
        textString_Left_CurrIt = char(WordList_shuffle_check{WhichIteration,1});
        textString_Right_CurrIt = char(WordList_shuffle_check{WhichIteration,2});
    else
        textString_Left_CurrIt = char(WordList_shuffle_check{WhichIteration,2});
        textString_Right_CurrIt = char(WordList_shuffle_check{WhichIteration,1});
    end
    
    %Wait for the participant to replay
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyCues);
    
    %Draw the left item to get the size of the string so it can moved and
    %leave the same space between the two cues for each trial
    [~, ~, textBounds]=DrawFormattedText(window,textString_Left_CurrIt,LeftScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),white); %Left item
    DisplaceText=textBounds(3)-textBounds(1);
    
    %Fill the screen in black
    Screen('FillRect', window, [0 0 0])
    
    % Drawing the two cues as text
    DrawFormattedText(window, textString_Left_CurrIt,LeftScreenPosition-DisplaceText, rect(4)*(scalaPosition*CuesPositionYChg),white);%/4-100
    DrawFormattedText(window, textString_Right_CurrIt,RightScreenPosition,rect(4)*(scalaPosition*CuesPositionYChg),white);
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyEndPoints);
    
    % Drawing the end points of the scala as text %textBounds(1, 3) -
    %   - rightTick(1, 1)/2
    DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
    DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
    
    % Drawing the scala
    Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
    Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
    Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
    Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
    
    Screen('Flip', window);
    
    %Wait for X seconds, depending of the time need to think
    WaitSecs(TimeToThink)
    
    %Set up the timer
    t0= GetSecs;
    
    %Set up the answer given at 0.
    answer= 0;
    %Set up the cheking of the movement of the cursor at 0
    Moved=0;
    %Set up the position of the mouse in the middle
    SetMouse(xCenter,yCenter,window)
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
            [x,~,buttons,~,~,~] = GetMouse(window, 1);
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
        
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyCues);
        
        %Draw the left item to get the size of the string so it can moved and
        %leave the same space between the two cues for each trial
        [~, ~, textBounds]=DrawFormattedText(window,textString_Left_CurrIt,LeftScreenPosition, rect(4)*(scalaPosition*CuesPositionYChg),white); %Left item
        DisplaceText=textBounds(3)-textBounds(1);
        
        %Fill the screen in black
        Screen('FillRect', window, [0 0 0])
        
        % Drawing the two cues as text
        DrawFormattedText(window, textString_Left_CurrIt,LeftScreenPosition-DisplaceText,rect(4)*(scalaPosition*CuesPositionYChg),wordColor);
        DrawFormattedText(window, textString_Right_CurrIt,RightScreenPosition,rect(4)*(scalaPosition*CuesPositionYChg),wordColor);
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, SizeFontModifyEndPoints);
        
        % Drawing the end points of the scala as text
        DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Left point
        DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)*EndPointsPositionXChg,  rect(4)*scalaPosition+rect(4)*EndPointsPositionYChg, white,[],[],[],[],[],[]); % Right point
        
        % Drawing the scala
        Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
        Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
        Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
        Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line
        
        % The slider
        Screen('DrawLine', window, sliderColor, x, rect(4)*scalaPosition - lineLengthSlider, x, rect(4)*scalaPosition  + lineLengthSlider, width);
        
        % Flip screen
        onsetStimulus = Screen('Flip', window);
        
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
    
    %Wait for 1 seconds before the next trial
    WaitSecs(0.5)
    
    % converting RT to seconds
    RT= secs - t0;
    
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
    
    %Enter the answer in the scale, the reaction time and if the
    %participant answered into the variable
    Answer_given_WordPair(WhichIteration,:)=[position, RT, answer];
    
    %Create a pause after X iterations.
    %increase the counter after each iteration
    CountPauseSet=CountPauseSet+1;
    %When the counter reach the threshold pause the task
    if WhenPause==CountPauseSet
        %Display a text on the screen
        PauseText='Vous pouvez maintenant prendre une pause. \n Appuyez sur la barre "Espace" pour continuer le test.';
        %Reset the counter
        CountPauseSet=0;
        
        %Ask the question to the participant if he gets a sudden response
        DrawFormattedText(window, PauseText, 'center', 'center',white);
        
        %Flip to the screen
        Screen('Flip', window);
        
        %Wait for 1 seconds
        WaitSecs(1)
        
        %Wait for input of the participant
        KbWait
    end
end


%%
%Create a last structure containing the seed of random number generator,
%the word list as well as the answers given.
save(['AJT_Pilot_PN' AnswerStart{1}],'Seed_is','WordList_shuffle_check','Answer_given_motor','Answer_given_training','Answer_given_WordPair')

%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
sca;









