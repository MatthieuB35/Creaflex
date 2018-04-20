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
Initials=OutputGUI.Initials;
Save=OutputGUI.SaveData;
TrainingMotor=OutputGUI.DoMotorTraining;
TrainingNormal=OutputGUI.DoNormalTraining;

NumberTrainingMotor=str2double(OutputGUI.MotorTraining);
NumberTrainingNormal=str2double(OutputGUI.NormalTraining);

Presentation=OutputGUI.Presentation;

WhichTask=OutputGUI.WhichTask;

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

WhichRun=str2double(OutputGUI.WhichRun);

%Import parameters
AJTpar.Parameters

load('AJTlists/AJT_Block_Correspondence.mat')
clear OutputBlocks seed
load('AJTlists/UniqueWords.mat')

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

Output.GUI=OutputGUI;

%Silent the input from keyboard and hide cursor
ListenChar(2)
HideCursor(OutputScreen);

%%
%Motor Training
if TrainingMotor==1
    AJTfct.Display_Instructions(InstructionScreensPart1,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window);
    OutputMotorTraining=AJTfct.MotorTrainingAJT(NumberTrainingMotor,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttimeNumber);
    Output.MotorTraining=OutputMotorTraining;
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(WhichRun)],'Output')
    end
end


%Normal training
if TrainingNormal==1
    Training=load('AJTlists/SelectionNodes_Training.mat');
    WordList_Training=Training.SelectionNodes(:,1:2);
    
    AJTfct.Display_Instructions(InstructionScreensPart2,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    OutputNormalTraining=AJTfct.NormalTrainingAJT(NumberTrainingNormal,WordList_Training,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime);
    Output.NormalTraining=OutputNormalTraining;
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(WhichRun)],'Output')
    end
end

%Display Words
if strcmp(WhichTask,'fMRI') && Presentation==1
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    Words=AJTfct.PresentationAllWords(UniqueWords,0.3,0.2,window,screenXpixels,screenYpixels,'mouse',1);
    Output.PresentationWords=Words;
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(WhichRun)],'Output')
    end
    if ismember(0,[Words{:,2}])
        UnknowWords=Words(ismember([Words{:,2}],0),1);
        Words2=AJTfct.PresentationAllWords(UnknowWords,0.3,0.2,window,screenXpixels,screenYpixels,'mouse',2);
        Output.PresentationWords2=Words2;
        if Save==1
            save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(WhichRun)],'Output')
        end
    end
elseif strcmp(WhichTask,'PRISME') && Presentation==1
    AJTfct.Display_Instructions(InstructionScreensPart3,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    Words=AJTfct.PresentationAllWords(UniqueWords,0.3,0.2,window,screenXpixels,screenYpixels,'keyboard',1);
    Output.PresentationWords=Words;
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(WhichRun)],'Output')
    end
    if ismember(0,[Words{:,2}])
        UnknowWords=Words(ismember([Words{:,2}],0),1);
        Words2=AJTfct.PresentationAllWords(UnknowWords,0.3,0.2,window,screenXpixels,screenYpixels,'keyboard',2);
        Output.PresentationWords2=Words2;
        if Save==1
            save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(WhichRun)],'Output')
        end
    end
end



%Instruction
if (strcmp(WhichTask,'fMRI') && WhichRun==1) || strcmp(WhichTask,'PRISME')
    %Instructions before task
    AJTfct.Display_Instructions(InstructionScreensPart4,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
end

%Main task
if strcmp(WhichTask,'fMRI') && WhichRun~=0 %Run by run
    HowManyRun=1;
    AllRun=WhichRun;
    
    %Instructions before task
    AJTfct.Display_Instructions(InstructionScreensPart5,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)
    
    Output=AJTfct.AJTRun(Output,AllRun,RunList,HowManyRun,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Save,DateString,PN,Initials);
    
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(WhichRun)],'Output');
    end
    
elseif strcmp(WhichTask,'PRISME') %All run at once
    HowManyRun=str2double(OutputGUI.HowManyRun);
    AllRun=[1,2,3,4,5,6];
    
    Output=AJTfct.AJTRun(Output,AllRun,RunList,HowManyRun,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Save,DateString,PN,Initials);
    
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_AllRun'],'Output');
    end
end

%%
ListenChar(0)
clearvars
sca
