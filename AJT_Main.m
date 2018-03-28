%AJT main


% Clear the workspace and the screen
sca;
close all;
clearvars;


OutputGUI=GUI_AJT;


%Silent the input from keyboard
%ListenChar(2)

Parameters

Output=struct;

Type='default';
WhichScreen=OutputGUI.ScreenDisplay{1};%Define the screen where the display should be on
PN=OutputGUI.ParticipantNumber;
Save=OutputGUI.SaveData;
TrainingMotor=OutputGUI.DoMotorTraining;
TrainingNormal=OutputGUI.DoNormalTraining;

NumberTrainingMotor=str2double(OutputGUI.MotorTraining);
NumberTrainingNormal=str2double(OutputGUI.NormalTraining);

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

if strcmp(Type,'default')
    WordList_AllTrial=importdata([path 'AJTList_shuffle_DefaultNounsOnly1.mat']);
elseif strcmp(Type,'nouns')
    WordList_AllTrial=importdata([path 'AJTList_shuffle_DefaultSelect1.mat']);
end

WordList_Training=importdata([path 'AJTList_shuffle_Pilot.mat']);

Screen_parameters



if TrainingMotor==1
    Display_Instructions(InstructionScreensPart1,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputMotorTraining=MotorTrainingAJT(NumberTrainingMotor,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttimeNumber);
    Output.MotorTraining=OutputMotorTraining;
end
 
     

if TrainingNormal==1
    Display_Instructions(InstructionScreensPart2,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputNormalTraining=NormalTrainingAJT(NumberTrainingNormal,WordList_Training,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime);
    Output.NormalTraining=OutputNormalTraining;
end

Display_Instructions(InstructionScreensPart3,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)

OutputTask=NormalTrainingAJT(3,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime);
Output.Task=OutputTask;


if Save==1
    save(['AJT_Pilot_PN' PN],'Output')
end

sca
