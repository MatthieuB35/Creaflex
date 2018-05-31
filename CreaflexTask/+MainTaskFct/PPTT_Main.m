%%%%%%%%%%%PPTT_Task
load('TempOutputGUI.mat')
delete TempOutputGUI.mat
PN=OutputGUI.ParticipantNumber;
Initials=OutputGUI.Initials;


Parameters.PPTT_Parameters;


PPTT_list=table2array(readtable([pathList 'SemanticMatching_list.txt'],'FileEncoding',EncodingList));

%Strat screen parameters
DisplayFct.ScreenStart;

Output_PPTT=num2cell(NaN(NumberItems+2,4));

Output_PPTT(:,1)=PPTT_list(1:NumberItems+2,1);

%Silent the input from keyboard
ListenChar(2);
HideCursor(screenNumber);



%%

%Training
DisplayFct.Display_Instructions(InstructionScreens_Part1,EncodingInstruction,NormalColor,pathInstru,window,FontSizeInstruct)


for WhichTraining = 1:2
    
    TempListElements=PPTT_list(WhichTraining,:);
    
    TempPPTT_training=DisplayFct.DisplayTrial_Resp(TempListElements,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait,TypeResp,WhichChoice);
   
    Output_PPTT(WhichTraining,2:length(TempPPTT_training)+1)=TempPPTT_training;
    
end

%%
%Task

DisplayFct.Display_Instructions(InstructionScreens_Part2,EncodingInstruction,NormalColor,pathInstru,window,FontSizeInstruct)


for WhichTraining = 3:NumberItems+2
    
    TempListElements=PPTT_list(WhichTraining,:);
    
    TempPPTT_task=DisplayFct.DisplayTrial_Resp(TempListElements,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait,TypeResp,WhichChoice);
   
    Output_PPTT(WhichTraining,2:length(TempPPTT_task)+1)=TempPPTT_task;
    
end



%%
NameFolder=[DateString '_' PN '_' Initials];

Created=OtherFct.CreationFolderSaveData('Results',1,NameFolder);

save([Created '/' DateString '_PPTT_' PNType PN '_' Initials],'Output_PPTT');


%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
clearvars;
sca;





