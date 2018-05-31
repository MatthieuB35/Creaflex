%%%%%%%%%%%%Stroop Task
load('TempOutputGUI.mat')
delete TempOutputGUI.mat
PN=OutputGUI.ParticipantNumber;
Initials=OutputGUI.Initials;

Parameters.Stroop_Parameters;

%Strat screen parameters
DisplayFct.ScreenStart;

%Stock the reponse size of the three parts
OutputStroop=num2cell(NaN(NumberItems,3));


%Silent the input from keyboard
ListenChar(2);
HideCursor(screenNumber);


%%
%

for WhichPart = 1:NumberItems
    
    %Training
    DisplayFct.Display_Instructions(Instr.(['InstructionScreens_Part' num2str(WhichPart)]),EncodingInstru,NormalColor,pathInstru,window,FontSizeInstruct)
    
    TrainingPicture = [pathPictures 'Part' num2str(WhichPart) '_Stroop_train.png'];
    
    DisplayFct.DisplayPictures_Resp(TrainingPicture,window,FontSizeTrial,NormalColor,BackgroundWT,TimeThink,0,[],[]);
    
    %Task
    DisplayFct.Display_Instructions(InstructionScreens_AfterTraining,EncodingInstru,NormalColor,pathInstru,window,FontSizeInstruct)
    
    TaskPicture = [pathPictures 'Part' num2str(WhichPart) '_Stroop.png'];
    
    OutputTask=DisplayFct.DisplayPictures_Resp(TaskPicture,window,FontSizeTrial,NormalColor,BackgroundWT,TimeThink,HowManyTimeAsk,Str2Ask,Time2Answer);
    
    OutputStroop(WhichPart,:)=OutputTask(OutputOfInterest); 
    
end


%%
NameFolder=[DateString '_' PN '_' Initials];

Created=OtherFct.CreationFolderSaveData('Results',1,NameFolder);

save([Created '/' DateString '_STROOP_' PNType PN '_' Initials],'OutputStroop');

%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
clearvars;
sca;




