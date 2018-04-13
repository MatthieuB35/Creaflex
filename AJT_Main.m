%AJT main


% Clear the workspace and the screen
%sca;
%close all;
%clearvars;


%Create the GUI
%OutputGUI=GUI_AJT;

load('TempOutputGUI.mat')
delete TempOutputGUI.mat

Output=struct;
WhichScreen=OutputGUI.ScreenDisplay{1};%Define the screen where the display should be on
PN=OutputGUI.ParticipantNumber;
Save=OutputGUI.SaveData;
TrainingMotor=OutputGUI.DoMotorTraining;
TrainingNormal=OutputGUI.DoNormalTraining;

NumberTrainingMotor=str2double(OutputGUI.MotorTraining);
NumberTrainingNormal=str2double(OutputGUI.NormalTraining);

WhichTask=OutputGUI.WhichTask;

%WhichSeq=OutputGUI.ScanSeq;

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');
%TimeString = datestr(CurrentDate,'HH:mm');

WhichRun=str2double(OutputGUI.WhichRun);

%Import parameters and create one from GUI
AJTpar.Parameters 

load([path 'AJTlists/AJT_Block_Correspondence.mat'])
clear OutputBlocks seed
load([path 'AJTlists/UniqueWords.mat'])

if strcmp(WhichScreen,'Testing')
    Screen('Preference', 'SkipSyncTests', 1);
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

AJTpar.Screen_parameters




%Silent the input from keyboard
ListenChar(2)
HideCursor(OutputScreen);

%%
%Motor Training
if TrainingMotor==1
    AJTfct.Display_Instructions(InstructionScreensPart1,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputMotorTraining=AJTfct.MotorTrainingAJT(NumberTrainingMotor,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttimeNumber);
    Output.MotorTraining=OutputMotorTraining;
    if Save==1
        save([DateString '_AJT_PN' PN '_Run' num2str(WhichRun)],'Output','OutputGUI')
    end
end


%Normal training
if TrainingNormal==1
    Training=importdata([path 'AJTlists/SelectionNodes_Training.mat']);
    WordList_Training=Training.SelectionNodes(:,1:2);
    
    AJTfct.Display_Instructions(InstructionScreensPart2,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputNormalTraining=AJTfct.NormalTrainingAJT(NumberTrainingNormal,WordList_Training,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime);
    Output.NormalTraining=OutputNormalTraining;
    if Save==1
        save([DateString '_AJT_PN' PN '_Run' num2str(WhichRun)],'Output','OutputGUI')
    end
end

%Main task

if strcmp(WhichTask,'fMRI') && WhichRun~=0 %Run by run
    Run=RunList(WhichRun,:);
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    StartSequence=GetSecs;
    Output.StartSeq=StartSequence;
    %Fixation across appear for 30s
    AJTfct.FixationCross(8,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
    %2s before end, change of colour
    AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
    
    %Calculate time after cross
    EndFirstCross=GetSecs;
    Output.FirstCross=EndFirstCross-StartSequence;
    
    for WhichBlock=1:(length(Run))
        Block=importdata([path 'AJTlists/AJT_Block_' num2str(Run(WhichBlock)) '.mat']);
        WordList_AllTrial=Block.Block;
        Jittered=Block.Jittered.ListITI;
        NbrTrial=length(WordList_AllTrial);
        OutputTask=AJTfct.TaskAJT(NbrTrial,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Jittered);
        Output.(['TaskBlock' num2str(WhichBlock)])=OutputTask;
        if Save==1
            save([DateString '_AJT_PN' PN '_Run' num2str(WhichRun)],'Output')
        end
        
        XStartCross=GetSecs;
        if WhichBlock ~= length(Run)
            %Fixation across appear for 30s
            AJTfct.FixationCross(18,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
            %2s before end, change of colour
            AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
        else
            %Fixation across appear for 30s
            AJTfct.FixationCross(8,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
            %2s before end, change of colour
            AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
        end
        XEndCross=GetSecs;
        Output.(['Cross_Number' num2str(WhichBlock)])=XEndCross-XStartCross;
    end
    EndSequence=GetSecs;
    AllSequence=EndSequence-StartSequence;
    Output.EndSeq=EndSequence;
    Output.AllSeq=AllSequence;
    
    %Save
    if Save==1
        save([DateString '_AJT_PN' PN '_Run' num2str(WhichRun)],'Output','OutputGUI')
    end
 

elseif strcmp(WhichTask,'PRISME') %All run at once
    HowManyRun=str2double(OutputGUI.HowManyRun);
    
    %Instruction display words
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    AJTfct.PresentationAllWords(UniqueWords,1,0.3,window,screenXpixels,screenYpixels)
    %Instructions before task
    AJTfct.Display_Instructions(InstructionScreensPart4,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    
    for CurrentRun = 1:HowManyRun
        Run=RunList(CurrentRun,:);
        StartSequence=GetSecs;
        Output.StartSeq=StartSequence;
        %Fixation across appear for 8+2s
        AJTfct.FixationCross(8,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
        %2s before end, change of colour
        AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
        for WhichBlock=1:(length(Run))
            Block=importdata([path 'AJTlists/AJT_Block_' num2str(Run(WhichBlock)) '.mat']);
            WordList_AllTrial=Block.Block;
            Jittered=Block.Jittered.ListITI;
            NbrTrial=length(WordList_AllTrial);
            %NbrTrial
            OutputTask=AJTfct.TaskAJT(NbrTrial,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Jittered);
            Output.(['TaskBlock' num2str(WhichBlock)])=OutputTask;
            if Save==1
                save([DateString '_AJT_PN' PN '_Run' num2str(CurrentRun)],'Output','OutputGUI');
            end
            if WhichBlock ~= length(Run)
                %Fixation across appear for 18+2s
                AJTfct.FixationCross(18,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
                %2s before end, change of colour
                AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
            else
                %Fixation across appear for 8+2s
                AJTfct.FixationCross(8,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
                %2s before end, change of colour
                AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
            end
        end
        EndSequence=GetSecs;
        AllSequence=EndSequence-StartSequence;
        Output.EndSeq=EndSequence;
        Output.AllSeq=AllSequence;
        
        %Save
        if Save==1
            save([DateString '_AJT_PN' PN '_Run' num2str(CurrentRun)],'Output','OutputGUI');
        end
        
        if CurrentRun~=HowManyRun
            AJTfct.Break(window,NormalColor,60);
        end
    end
    
end

%%


ListenChar(0)
clearvars
sca
