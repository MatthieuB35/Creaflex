%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              AJT TASK V_B /!\PILOT
% Version: 4
% Last Edited: 08/03/2018
% Author: Matthieu Bernard (modified by MO)
% Language of the task: French
% Description; Present on screen for X seconds a pair of words and ask the
% participant to rate in a scale to 0 to 100, how he think the
% words are related or not. Participants need to repond in 2s.
% This pilot version contain two ways: verbal & button. You can choose the
% one you want to test at the start.
%
% Requires: - Psychtoolbox-3
%           - The 'AJTList_shuffle_Pilot.mat' for the 100 trials
%           - Instructions files
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear the workspace and the screen
sca;
close all;
clearvars;

KbName('UnifyKeyNames') % cross compatibility

%Create a input box where the experimenter can enter which part to launch
%as well as the participant number
prompt = {'Numero du participant?','Quelle version? [verbal OR button]','Combien de trials?'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0','button','100'};
AnswerStart = inputdlg(prompt,dlg_title,num_lines,defaultans);

%Change the seed for the random generator every time the function start
Seed_is = rng('shuffle');

%%
%Set up the path where the list of the words are stored.
path=[pwd '/'];

%Silent the input from keyboard
ListenChar(2)

%Import the list of the words and create a variable to contain it.
%WordBenedek_list=importdata([path 'AJT_list.txt']);

%Define the parameters used in the task
NumberItems = str2num(AnswerStart{3}); %Define the number of item to test
lineLength    = 10; %Line length of the scale
width         = 5; %Width fo the scale
% scalaLength   = 0.6; %Length of the marker in the scale
scalaLength   = 0.9; %Length of the marker in the scale
scalaPosition = 0.5; %Position of the marker in the scale
sliderColor    = [255 0 0]; % color of the slider; Red
%scaleColor    = [224 224 224]; %Color of the scale; grey
lineLengthSlider= 20; %Length of the slider
scaleColor = [0 255 0];
wordColor = [255 255 0];
device        = 'mouse'; %Which device to use the scale. If needed, use the
%following command to see in "UsageName" devices=PsychHID('Devices').
OutputScreen= 0;
OutputScreen= 3; % CENIR Benoît Windows
aborttime     = 2; %Abort time, use if want to limit time of participant
TimeToThink=2; %Decide the number of seconds where participants have the time to think
responseKey   = KbName('return'); %Return the keycode for the key 'return'
startPosition = 'center'; %Select the start position of the cursor
endPoints={'0 = Pas du tout Lié', '100= Complètement lié'}; %Which word there is at the end of the scale
WordBenedek_list_number=1:28; %The number associated with the word
% InstructionScreens_Button=2; %Instruction
InstructionScreens_Button=1; %Instruction
InstructionScreens_Verbal=2; %Instruction
Encoding='UTF-8'; %Encoding='Macintosh'; %Specify the encoding of the txt file
WhenPause=NumberItems/4; %Decide when to pause
CountPauseSet=0; %Counter for the pause
Type=AnswerStart{2}; %Define the type of experiment (either verbal or button)
leftKey = KbName('LeftArrow'); %GetName of left arrow in keyboard
rightKey = KbName('RightArrow'); %GetName of right arrow in keyboard
pixelsPerPress = 10; % Movement of pixel per change if keyboard
Time2Wait=1.8;
recObj = audiorecorder; %Define the recorder
TextAnswer='Reponse!';
OutputAudio= []; %Create the variable for the output audio

%% Benoît

MouseSpeedFactor = 2    ;

%%
%Create all the possible pairs of words by using a number associated with
%each word (there index in the variable)

%/!!!!!!\ OFF FOR PILOT VERSION; take pre-established filed
% AllWordPairs = nchoosek(WordBenedek_list_number,2);
%
% %Shuffle the pairs randomly.
% AllWordPairs_suffled = AllWordPairs(randperm(size(AllWordPairs,1)),:);
%
% %Use a function that will checked if there is no consecutive number (i.e.
% %word)
% New_WordPair_shuffled=ConsecutivePaired(AllWordPairs_suffled,20);
%
% %Create a empty variable that will contained the pairs of the real word.
% WordList_shuffle_check=cell(size(New_WordPair_shuffled));
%
% %Start the loop that will go through all the pairs and replace the number
% %by the associated word.
% for ReplaceNbrWord = 1:length(New_WordPair_shuffled)
%     WordList_shuffle_check{ReplaceNbrWord,1}=WordBenedek_list(New_WordPair_shuffled(ReplaceNbrWord,1));
%     WordList_shuffle_check{ReplaceNbrWord,2}=WordBenedek_list(New_WordPair_shuffled(ReplaceNbrWord,2));
% end

%/!!!!!!\ PILOT VERSION; 100 TRIALS
WordList_AllTrial=importdata([path 'AJTList_shuffle_Pilot.mat']);

if strcmp(Type,'verbal')
    WordList_shuffle_check=[WordList_AllTrial{1:100,1};WordList_AllTrial{1:100,2}]';
    %Create a variable where the answer will be stocked;
    Answer_given_WordPair=NaN(100,2);
elseif strcmp(Type,'button')
    WordList_shuffle_check=[WordList_AllTrial{101:200,1};WordList_AllTrial{101:200,2}]';
    %Create a variable where the answer will be stocked;
    Answer_given_WordPair=NaN(100,3);
end

%Create a variable where the answer will be stocked;
%C1; their reaction time
%C2; if they gave an answer
%Answer_given_WordPair=NaN(100,2);

%%
%Call some default settings for setting up Psychtoolbox or Debug mode
PsychDefaultSetup(2);
%PsychDebugWindowConfiguration

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
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Setup the text type for the window
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 40);

% Get the center coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
rect= [ 0 0 screenXpixels screenYpixels]; %Dimension of the screen
center= round([rect(3) rect(4)]/2); %Center of the screen
squareX = xCenter;

%%

%If use verbal response
if strcmp(Type,'verbal')
    %Define the left and right screen to put the text
    LeftScreenPosition=rect(3)*0.3;
    RightScreenPosition=rect(3)*0.7;
    
    for InstructionNumber= 1:InstructionScreens_Verbal
        %Import the data for the instruction
        TempInstructionFile = fopen([path 'Instruction_' num2str(InstructionNumber) '_' Type '.txt'],'r+','n',Encoding);
        
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
    
    %Start the loop for the test that will go for the number of items desired
    for WhichIteration = 1:NumberItems
        
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
        Screen('TextSize', window, 40);
        
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
        
        %Adjust size of left item display
        [~, ~, textBounds]=DrawFormattedText(window, textString_Left_CurrIt, LeftScreenPosition, yCenter,white); %Left item
        DisplaceText=textBounds(3)-textBounds(1);
        
        %Fill the screen in black
        Screen('FillRect', window, [0 0 0])
        
        % Drawing the two cues as text
        DrawFormattedText(window, textString_Left_CurrIt, LeftScreenPosition-DisplaceText, yCenter,white); %Left item
        DrawFormattedText(window, textString_Right_CurrIt, RightScreenPosition, yCenter,white); %Right item
        
        % Flip screen
        Screen('Flip', window);
        
        % get the time stamp at the start of waiting for key input
        % so we can evaluate timeout
        TimeStart = GetSecs;
        
        % repeat until a valid key is pressed or we time out
        TimeOut = false;
        
        %Wait for 0.2 seconds making sure participant read
        WaitSecs(0.2)
        
        while ~TimeOut
            % check if a key is pressed
            % only keys specified in activeKeys are considered valid
            [ keyIsDown, keyTime, keyCode ] = KbCheck;
            if(keyIsDown), break; end
            %Two seconds before the end, fill the screen in grey
            %             if( (keyTime - TimeStart) > Time2Wait-0.08)
            %
            %                 %Fill the screen in grey
            %                 Screen('FillRect', window, [127 127 127]);
            %
            %                 %Draw the words.  left and right
            %                 DrawFormattedText(window, textString_Left_CurrIt, LeftScreenPosition-DisplaceText, yCenter,white); %Left item
            %                 DrawFormattedText(window, textString_Right_CurrIt, RightScreenPosition, yCenter,white); %Right item
            %                 Screen('Flip', window);
            %             end
            if( (keyTime - TimeStart) > Time2Wait), TimeOut = true; end
        end
        
        RT=keyTime - TimeStart;
        answer=TimeOut;
        
        %Draw the response text in a black screen
        Screen('FillRect', window, [0 0 0]);
        DrawFormattedText(window,TextAnswer, xCenter, yCenter,white); %Left item
        Screen('Flip', window);
        %Start the recodring of the response for 1s and store the audio in
        %a temporary file
        recordblocking(recObj, 1.5);
        TempAudio = getaudiodata(recObj);
        
        %Fill up the screen in black and wait for 0.3 for ISI
        Screen('FillRect', window, [0 0 0]);
        Screen('Flip', window);
        WaitSecs(0.3)
        
        %Store the temporary temporary audio in the output file before next
        %trial
        OutputAudio= [OutputAudio;TempAudio];
        
        %Enter the answer in the scale, the reaction time and if the
        %participant answered into the variable
        Answer_given_WordPair(WhichIteration,:)=[RT, answer];
        
        %Create a pause after X iterations.
        CountPauseSet=CountPauseSet+1;
        if WhenPause==CountPauseSet
            PauseText='Vous pouvez maintenant prendre une pause. \n Appuyez sur la barre "Espace" pour continuer le test.';
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
    %Export the audio recorded in the test
    filename = ['AudioOutput_PN' AnswerStart{1} '.wav'];
    audiowrite(filename,OutputAudio,8000)
    
    
    %%
    %If use button responses
elseif strcmp(Type,'button')
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
    
    SetMouse(round(x), round(rect(4)*scalaPosition));
    midTick    = [center(1) rect(4)*scalaPosition - lineLength - 5 center(1) rect(4)*scalaPosition  + lineLength + 5];
    leftTick   = [rect(3)*(1-scalaLength) rect(4)*scalaPosition - lineLength rect(3)*(1-scalaLength) rect(4)*scalaPosition  + lineLength];
    rightTick  = [rect(3)*scalaLength rect(4)*scalaPosition - lineLength rect(3)*scalaLength rect(4)*scalaPosition  + lineLength];
    horzLine   = [rect(3)*scalaLength rect(4)*scalaPosition rect(3)*(1-scalaLength) rect(4)*scalaPosition];
    textBounds = [Screen('TextBounds', window, endPoints{1}); Screen('TextBounds', window, endPoints{2})];
    
    
    for InstructionNumber= 1:InstructionScreens_Button
        %Import the data for the instruction
        TempInstructionFile = fopen([path 'Instruction_' num2str(InstructionNumber) '_' Type '.txt'],'r+','n',Encoding);
        
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
    
    HideCursor;
    
    %Start the loop for the test that will go for the number of items desired
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
%         Screen('TextSize', window, 70);
        Screen('TextSize', window, 30);
        
        % Drawing the two cues as text
        DrawFormattedText(window, textString_Left_CurrIt,midTick(1, 1)-midTick(1, 1)/4-100, rect(4)*(scalaPosition - 0.15 ),white);
        DrawFormattedText(window, textString_Right_CurrIt, midTick(1, 1)+midTick(1, 1)/4-40, rect(4)*(scalaPosition - 0.15),white);
        
        % Setup the text type for the window
        Screen('TextFont', window, 'Arial');
%         Screen('TextSize', window, 30);
        Screen('TextSize', window, 10);
        
        % Drawing the end points of the scala as text %textBounds(1, 3) -
        %   - rightTick(1, 1)/2
        DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)/4,  rect(4)*scalaPosition+50, white,[],[],[],[],[],[]); % Left point
        DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)/10,  rect(4)*scalaPosition+50, white,[],[],[],[],[],[]); % Right point
        
        % Drawing the scala
        Screen('DrawLine', window, scaleColor, midTick(1), midTick(2), midTick(3), midTick(4), width);         % Mid tick
        Screen('DrawLine', window, scaleColor, leftTick(1), leftTick(2), leftTick(3), leftTick(4), width);     % Left tick
        Screen('DrawLine', window, scaleColor, rightTick(1), rightTick(2), rightTick(3), rightTick(4), width); % Right tick
        Screen('DrawLine', window, scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), width);     % Horizontal line

        Screen('Flip', window);
        
        %Wait for 2 seconds
        WaitSecs(TimeToThink)
        
        %Useful only with the timer
        t0= GetSecs;
        
        %Set up the answer given as 0.
        answer= 0;
        
        SetMouse(xCenter,yCenter,window)
        x_prev = xCenter; % initialize
        
        while answer == 0
            
            
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
            fprintf('%d\n',dx)
            x = x_prev + dx*MouseSpeedFactor;
            
            % Keep cursor in the "line"
            if x > rect(3)*scalaLength
                x = rect(3)*scalaLength;
            elseif x < rect(3)*(1-scalaLength)
                x = rect(3)*(1-scalaLength);
            end
            x_prev = x;
            
            % Setup the text type for the window
            Screen('TextFont', window, 'Arial');
%             Screen('TextSize', window, 70);
            Screen('TextSize', window, 30);
            
            % Drawing the two cues as text
            DrawFormattedText(window, textString_Left_CurrIt,midTick(1, 1)-midTick(1, 1)/4-100, rect(4)*(scalaPosition - 0.15),wordColor);
            DrawFormattedText(window, textString_Right_CurrIt, midTick(1, 1)+midTick(1, 1)/4-40, rect(4)*(scalaPosition - 0.15),wordColor);
            
            % Setup the text type for the window
            Screen('TextFont', window, 'Arial');
%             Screen('TextSize', window, 30);
            Screen('TextSize', window, 10);
            
            % Drawing the end points of the scala as text
            DrawFormattedText(window, endPoints{1}, leftTick(1, 1)-leftTick(1, 1)/4,  rect(4)*scalaPosition+50, white,[],[],[],[],[],[]); % Left point
            DrawFormattedText(window, endPoints{2}, rightTick(1, 1)-leftTick(1, 1)/10,  rect(4)*scalaPosition+50, white,[],[],[],[],[],[]); % Right point
            
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
            if secs - t0 > aborttime
                break
            end
        end
        
        
        
        %Wait for 1 seconds before the next trial
        WaitSecs(0.5)
        
        % converting RT to millisecond
        RT= (secs - t0)*1000;
        
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
        %         CountPauseSet=CountPauseSet+1;
        %         if WhenPause==CountPauseSet
        %             PauseText='Vous pouvez maintenant prendre une pause. \n Appuyez sur la barre "Espace" pour continuer le test.';
        %             CountPauseSet=0;
        %
        %             %Ask the question to the participant if he gets a sudden response
        %             DrawFormattedText(window, PauseText, 'center', 'center',white);
        %
        %             %Flip to the screen
        %             Screen('Flip', window);
        %
        %             %Wait for 1 seconds
        %             WaitSecs(1)
        %
        %             %Wait for input of the participant
        %             KbWait
        %         end
    end
end

%%
%Create a last structure containing the seed of random number generator,
%the word list as well as the answers given.
save(['AJT_Pilot_PN' AnswerStart{1} '_' Type],'Seed_is','WordList_shuffle_check','Answer_given_WordPair')

%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
sca;









