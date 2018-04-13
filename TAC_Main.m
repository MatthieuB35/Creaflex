%Load GUI
load('TempOutputGUI.mat')
delete TempOutputGUI.mat

WhichScreen=OutputGUI.ScreenDisplay{1};%Define the screen where the display should be on
PN=OutputGUI.ParticipantNumber;
Save=OutputGUI.SaveData;

DoTraining=OutputGUI.DoTraining;
DoTask=OutputGUI.DoTask;

if strcmp(WhichScreen,'Screen0')
    OutputScreen= 0; %PRISME
elseif strcmp(WhichScreen,'Screen1')
    OutputScreen= 1; %Testing
end
CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

TACpar.Parameters

%Import the training list of the words and create a variable to contain it.
TAC_task=table2array(readtable([path '/TAC_list/TAC40_list.csv'],'ReadVariableNames',true,'FileEncoding',EncodingCSV));
TAC_training=table2array(readtable([path '/TAC_list/TAC_training.csv'],'ReadVariableNames',true,'FileEncoding',EncodingTxT));

%Create screen display
TACpar.Screen_parameters

%Silent the input from keyboard
ListenChar(2)
HideCursor(OutputScreen);

%%
if DoTraining==1
    TACfct.Display_Instructions(InstructionScreensPart1,EncodingTxT,NormalColor,path,window)
    
    Results_Training=TACfct.TAC_Task(TAC_training,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition);
    if Save==1
        save([DateString '_TAC_PN' PN],'Results_Training');
    end
end

if DoTask==1
    %Display Instructions
    TACfct.Display_Instructions(InstructionScreensPart2,EncodingTxT,NormalColor,path,window)
    
    %Launch main task
    Results_Task=TACfct.TAC_Task(TAC_task,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition);
    
    %Creation scoring
    Results_Task=TACfct.Scoring(Results_Task);
    
    %Display Score
    TACfct.DisplayScore(TAC_ResList,window);
    
    %Save
    if Save==1 && DoTraining==1
        save([DateString '_TAC_PN' PN],'Results_Training','Results_Task');
    else
        save([DateString '_TAC_PN' PN],'Results_Task');
    end
end

ListenChar(0)
clearvars
sca