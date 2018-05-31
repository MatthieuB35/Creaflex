%%%%%%%%%%%Similarity Task

load('TempOutputGUI.mat')
delete TempOutputGUI.mat
PN=OutputGUI.ParticipantNumber;
Initials=OutputGUI.Initials;

Parameters.Similarity_Parameters;

%Seed_is = rng('shuffle');


%Import the list of the words and create a variable to contain it.
Similarity_list=table2array(readtable([pathList 'Similitude_list_long.txt'],'ReadVariableNames',false,'FileEncoding',EncodingList));

%Strat screen parameters
DisplayFct.ScreenStart;

Answer_Similarity=num2cell(NaN(NumberItems,6));
Answer_Similarity(:,1:2)=Similarity_list(1:NumberItems,:);


%Silent the input from keyboard
ListenChar(2);
HideCursor(screenNumber);
%%

%Training
DisplayFct.Display_Instructions(InstructionScreens,EncodingInstru,NormalColor,pathInstru,window,FontSizeInstruct)

TrainingElement=Similarity_list(1,:);
OutputSimi_training=DisplayFct.DisplayTrial_Resp(TrainingElement,window,LeftScreenPosition,RightScreenPosition,[],[],FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait,TypeResp);

Answer_Similarity(1,3:length(OutputSimi_training)+2)=OutputSimi_training;

%%
%Real Task
DisplayFct.Display_Instructions(InstructionScreen2,EncodingInstru,NormalColor,pathInstru,window,FontSizeInstruct)

for WhichIterationSimi = 2:NumberItems

TrainingElement=Similarity_list(WhichIterationSimi,:);
OutputSimi_trials=DisplayFct.DisplayTrial_Resp(TrainingElement,window,LeftScreenPosition,RightScreenPosition,[],[],FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait,TypeResp);
Answer_Similarity(WhichIterationSimi,3:length(OutputSimi_trials)+2)=OutputSimi_trials; 

end


%%
NameFolder=[DateString '_' PN '_' Initials];

Created=OtherFct.CreationFolderSaveData('Results',1,NameFolder);

save([Created '/' DateString '_SIMILARITY_' PNType PN '_' Initials],'Answer_Similarity');

%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
clearvars;
sca;


