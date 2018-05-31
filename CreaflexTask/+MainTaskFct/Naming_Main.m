%%%%%%%%%%%%Naming Task
load('TempOutputGUI.mat')
delete TempOutputGUI.mat
PN=OutputGUI.ParticipantNumber;
Initials=OutputGUI.Initials;


Parameters.Naming_Parameters;

%Strat screen parameters
DisplayFct.ScreenStart;



DirPictures= dir(pathPic);
CellPictures={DirPictures.name};
NamePictures=CellPictures(contains(CellPictures,'Pic'));

%Stock the reponse size of the three parts
Output_Naming=num2cell(NaN(NumberItems,4));
Output_Naming(:,1)=NamePictures(1:NumberItems);

%Silent the input from keyboard
ListenChar(2);
HideCursor(screenNumber);


%%

DisplayFct.Display_Instructions(InstructionScreens,EncodingInstru,NormalColor,pathInstru,window,FontSizeInstruct)


for CurrentPicture = 1:NumberItems
    
    TaskPicture = [pathPic NamePictures{CurrentPicture}];
    
    OutputTask=DisplayFct.DisplayPictures_Resp(TaskPicture,window,FontSizeTrial,NormalColor,BackgroundWT,TimeThink,HowManyTimeAsk,Str2Ask,Time2Answer);
    
    Output_Naming(CurrentPicture,2:length(OutputTask)+1)=OutputTask;
    
end


%%
NameFolder=[DateString '_' PN '_' Initials];

Created=OtherFct.CreationFolderSaveData('Results',1,NameFolder);

save([Created '/' DateString '_NAMING_' PNType PN '_' Initials],'Output_Naming');


%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
clearvars;
sca;













