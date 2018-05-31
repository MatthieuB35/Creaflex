%%%%%%%%%%%FGAT_Task

%Loading parameters and files

load('TempOutputGUI.mat')
delete TempOutputGUI.mat
PN=OutputGUI.ParticipantNumber;
Initials=OutputGUI.Initials;


Parameters.FGAT_Parameters;

Seed_is = rng('shuffle');

%Import the list of the words and create a variable to contain it.
FGAT_Part1_list=table2array(readtable([pathList 'FGAT_Part1_list.txt'],'FileEncoding',EncodingFile));
FGAT_Part2_list=table2array(readtable([pathList 'FGAT_Part2_list.txt'],'FileEncoding',EncodingFile));

%Shuffle the pairs randomly.
FGAT_Part1_suffled = FGAT_Part1_list(randperm(size(FGAT_Part1_list,1)),:);
FGAT_Part2_suffled = FGAT_Part2_list(randperm(size(FGAT_Part2_list,1)),:);

%Strat screen parameters
DisplayFct.ScreenStart;


Answer_FGAT_Part1=num2cell(NaN(NumberItems,5));
Answer_FGAT_Part1(:,1)=FGAT_Part1_suffled(1:NumberItems);
Answer_FGAT_Part2=num2cell(NaN(NumberItems,5));
Answer_FGAT_Part2(:,1)=FGAT_Part2_suffled(1:NumberItems);


%Silent the input from keyboard
ListenChar(2);
HideCursor(screenNumber);
%%
%Part 1

DisplayFct.Display_Instructions(InstructionScreens_Part1,EncodingInstruction,NormalColor,pathInstru,window,FontSizeInstruct)

for WhichIterationFGAT = 1:NumberItems
    
    ListElements=FGAT_Part1_suffled{WhichIterationFGAT};
    
    OutputFGAT_trials=DisplayFct.DisplayTrial_Resp(ListElements,window,LeftScreenPosition,RightScreenPosition,[],[],FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait_Part1,TypeResp);
   
    Answer_FGAT_Part1(WhichIterationFGAT,2:5)=OutputFGAT_trials;
    
end

%%
%Part 2

DisplayFct.Display_Instructions(InstructionScreens_Part2,EncodingInstruction,NormalColor,pathInstru,window,FontSizeInstruct)

for WhichIterationFGAT = 1:NumberItems
    
    ListElements=FGAT_Part2_suffled{WhichIterationFGAT};
    
    OutputFGAT_trials=DisplayFct.DisplayTrial_Resp(ListElements,window,LeftScreenPosition,RightScreenPosition,[],[],FontSizeTrial,NormalColor,BackgroundWT,BackgroundNT,TimeThink,TimeITI,Time2Wait_Part2,TypeResp);
   
    Answer_FGAT_Part2(WhichIterationFGAT,2:5)=OutputFGAT_trials;
    
end

%%
Output=struct('Seed',Seed_is,'FGAT_Part1',{Answer_FGAT_Part1},'FGAT_Part2',{Answer_FGAT_Part2});

NameFolder=[DateString '_' PN '_' Initials];

Created=OtherFct.CreationFolderSaveData('Results',1,NameFolder);

save([Created '/' DateString '_FGAT_' PNType PN '_' Initials],'Output');


%Allow input again on command line
ListenChar(0)

% Clear the screen and finish the experiment
clearvars;
sca;




