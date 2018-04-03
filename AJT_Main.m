%AJT main


% Clear the workspace and the screen
sca;
close all;
clearvars;

%Create the GUI
OutputGUI=GUI_AJT;

%Import parameters and create one from GUI
AJTpar.Parameters    

Output=struct;
WhichScreen=OutputGUI.ScreenDisplay{1};%Define the screen where the display should be on
PN=OutputGUI.ParticipantNumber;
Save=OutputGUI.SaveData;
TrainingMotor=OutputGUI.DoMotorTraining;
TrainingNormal=OutputGUI.DoNormalTraining;

NumberTrainingMotor=str2double(OutputGUI.MotorTraining);
NumberTrainingNormal=str2double(OutputGUI.NormalTraining);

WhichTask=OutputGUI.WhichTask;

WhichSeq=OutputGUI.ScanSeq;
WhichRun=str2double(OutputGUI.WhichRun);

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

load([path 'AJTlists/AJT_Block_Correspondance.mat'])
clear NamesBlock seed

if WhichRun ~=0
    Run=RunList(WhichRun,:);
else
    Run=0;
end

AJTpar.Screen_parameters

%Silent the input from keyboard
ListenChar(2)

%%
%Motor Training
if TrainingMotor==1
    AJTfct.Display_Instructions(InstructionScreensPart1,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputMotorTraining=AJTfct.MotorTrainingAJT(NumberTrainingMotor,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttimeNumber);
    Output.MotorTraining=OutputMotorTraining;
    if Save==1
        save(['AJT_Pilot_PN' PN '_Run' num2str(WhichRun)],'Output')
    end
end


%Normal training
if TrainingNormal==1
    Training=importdata([path 'AJTlists/SelectionNodes_Training.mat']);
    WordList_Training=Training.SelectionNodes(:,1:2);
    
    AJTfct.Display_Instructions(InstructionScreensPart2,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputNormalTraining=AJTfct.NormalTrainingAJT(NumberTrainingNormal,WordList_Training,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime);
    Output.NormalTraining=OutputNormalTraining;
    if Save==1
        save(['AJT_Pilot_PN' PN '_Run' num2str(WhichRun)],'Output')
    end
end

%Main task
if strcmp(WhichTask,'fMRI')
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    for WhichBlock=1:(length(Run)-1)
        Block=importdata([path 'AJTlists/AJT_Block_' num2str(Run(WhichBlock+1)) '.mat']);
        WordList_AllTrial=Block.Block;
        Jittered=Block.Jittered.ListITI;
        NbrTrial=length(WordList_AllTrial);
        OutputTask=AJTfct.TaskAJT(NbrTrial,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Jittered);
        Output.(['TaskBlock' num2str(WhichBlock)])=OutputTask;
        if Save==1
            save(['AJT_Pilot_PN' PN '_Run' num2str(WhichRun)],'WhichSeq','Output')
        end
        %Fixation across appear for 30s
        AJTfct.FixationCross(28,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter)
        %2s before end, change of colour
        AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter)
    end
    
elseif strcmp(WhichTask,'PRISM') 
    Break=str2double(OutputGUI.WhenPause);
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputTask=AJTfct.TaskAJT(5,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Jittered,Break);
    Output.Task=OutputTask;
end

%%
%Save
if Save==1
    save(['AJT_Pilot_PN' PN '_Run' num2str(WhichRun)],'WhichSeq','Output')
end

ListenChar(0)
sca
