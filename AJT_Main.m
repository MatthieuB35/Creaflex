%AJT main


% Clear the workspace and the screen
sca;
close all;
clearvars;

%Create the GUI
OutputGUI=GUI_AJT;

%Import parameters and create one from GUI
AJTpar.Parameters    

Type='default';

Output=struct;
WhichScreen=OutputGUI.ScreenDisplay{1};%Define the screen where the display should be on
PN=OutputGUI.ParticipantNumber;
Save=OutputGUI.SaveData;
TrainingMotor=OutputGUI.DoMotorTraining;
TrainingNormal=OutputGUI.DoNormalTraining;

NumberTrainingMotor=str2double(OutputGUI.MotorTraining);
NumberTrainingNormal=str2double(OutputGUI.NormalTraining);

WhichTask=OutputGUI.WhichTask;

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

HideCursor(OutputScreen)

if strcmp(Type,'default')
    WordList_AllTrial=importdata([path '@AJTlists/AJTList_shuffle_DefaultNounsOnly1.mat']);
elseif strcmp(Type,'nouns')
    WordList_AllTrial=importdata([path '@AJTlists/AJTList_shuffle_DefaultSelect1.mat']);
end

WordList_Training=importdata([path '@AJTlists/AJTList_shuffle_Pilot.mat']);

AJTpar.Screen_parameters

%Silent the input from keyboard
%ListenChar(2)

%%
%Motor Training
if TrainingMotor==1
    AJTfct.Display_Instructions(InstructionScreensPart1,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputMotorTraining=AJTfct.MotorTrainingAJT(NumberTrainingMotor,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttimeNumber);
    Output.MotorTraining=OutputMotorTraining;
    if Save==1
        save(['AJT_Pilot_PN' PN],'Output')
    end
end


%Normal training     
if TrainingNormal==1
    AJTfct.Display_Instructions(InstructionScreensPart2,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputNormalTraining=AJTfct.NormalTrainingAJT(NumberTrainingNormal,WordList_Training,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime);
    Output.NormalTraining=OutputNormalTraining;  
    if Save==1
        save(['AJT_Pilot_PN' PN],'Output')
    end
end

     
%Main task
if strcmp(WhichTask,'fMRI')
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputTask=AJTfct.TaskAJT(1,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime);
    Output.Task=OutputTask;
elseif strcmp(WhichTask,'PRISM') 
    Break=str2double(OutputGUI.WhenPause);
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputTask=AJTfct.TaskAJT(5,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Break);
    Output.Task=OutputTask;
end

%%
%Save
if Save==1
    save(['AJT_Pilot_PN' PN],'Output')
end

sca
