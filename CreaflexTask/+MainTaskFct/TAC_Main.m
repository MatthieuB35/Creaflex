%%%%%%%%%%TAC task

%Load GUI
load('TempOutputGUI.mat')
delete TempOutputGUI.mat

PN=OutputGUI.ParticipantNumber;
Initials=OutputGUI.Initials;

Parameters.TAC_Parameters;

%Import the training list of the words and create a variable to contain it.
TempTAC_task=table2array(readtable([pathList 'TAC_list100.csv'],'ReadVariableNames',true,'FileEncoding',EncodingTxT));
TAC_task = TempTAC_task(randperm(size(TempTAC_task,1)),:);

TAC_training=table2array(readtable([pathList 'TAC_training.csv'],'ReadVariableNames',true,'FileEncoding',EncodingTxT));

Output_TAC=struct;

%Create screen display
DisplayFct.ScreenStart;

%Silent the input from keyboard
ListenChar(2)
HideCursor(OutputScreen);

%%
%Training
DisplayFct.Display_Instructions(InstructionScreensPart1,EncodingTxT,NormalColor,pathInstru,window,FontSizeInstruct)

Q_Eureka=DisplayFct.AskingInstructions(InstructionQuestion,EncodingTxT,NormalColor,pathInstru,window,LeftArrow,RightArrow,FontSizeInstruct);

Output_TAC.QEureka=Q_Eureka;

DisplayFct.Display_Instructions(InstructionScreensPart2,EncodingTxT,NormalColor,pathInstru,window,FontSizeInstruct);


NumberItems_Train=NumberITemsTrain; % size(TAC_training,1)
NumberCol_Train=size(TAC_training,2);


for WhichIterationTrain = 1:NumberItems_Train
    
    textString_Top = char(TAC_training{WhichIterationTrain,2});
    textString_Left = char(TAC_training{WhichIterationTrain,3});
    textString_Right = char(TAC_training{WhichIterationTrain,4});
    
    ListElements={textString_Top textString_Left textString_Right};
    
    TempOutput=DisplayFct.DisplayTrial_Resp(ListElements,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait,TypeRespTrial);
    
    EurekaOutput=DisplayFct.DisplayTrial_Resp(QuestionInstruction,window,[],[],[],[],FontSizeEureka,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait_Q,TypeRespEureka,WhichChoice);
    
    HowManyCol=length(TempOutput)+length(EurekaOutput);
    
    TAC_training(WhichIterationTrain,NumberCol_Train+1:NumberCol_Train+HowManyCol)=[TempOutput,EurekaOutput];
    
    
    if WhichIterationTrain==WhenPause
        TACfct.Break(window,NormalColor,10)
    end
end



Output_TAC.ResTraining=TAC_training;

%%
%Task

%Display Instructions
DisplayFct.Display_Instructions(InstructionScreensPart3,EncodingTxT,NormalColor,pathInstru,window,FontSizeInstruct)



NumberItems_Task=NumberItemsTask; %size(TAC_task,1)
NumberCol_Task=size(TAC_task,2);


for WhichIterationTask = 1:NumberItems_Task
    
    textString_Top = char(TAC_task{WhichIterationTask,2});
    textString_Left = char(TAC_task{WhichIterationTask,3});
    textString_Right = char(TAC_task{WhichIterationTask,4});
    
    ListElements={textString_Top textString_Left textString_Right};
    
    TempOutput=DisplayFct.DisplayTrial_Resp(ListElements,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition,FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait,TypeRespTrial);
    
    EurekaOutput=DisplayFct.DisplayTrial_Resp(QuestionInstruction,window,[],[],[],[],FontSizeEureka,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait_Q,TypeRespEureka,WhichChoice);
    
    HowManyCol=length(TempOutput)+length(EurekaOutput);
    
    TAC_task(WhichIterationTask,NumberCol_Task+1:NumberCol_Task+HowManyCol)=[TempOutput,EurekaOutput];
    
    
    if WhichIterationTask==WhenPause
        TACfct.Break(window,NormalColor,10)
    end
end



%Creation scoring
%Results_Task=OtherFct.TAC_Scoring(TempOutput,StartAnswer,EndAnswer,WhereAnswer);




Output_TAC.ResTask=TAC_task;
%Display Score
%TACfct.DisplayScore(Results_Task,window);


%%

NameFolder=[DateString '_' PN '_' Initials];

Created=OtherFct.CreationFolderSaveData('Results',1,NameFolder);


save([Created '/' DateString '_TAC_' PNType PN '_' Initials],'Output_TAC');


ListenChar(0)
sca