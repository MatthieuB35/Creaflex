%Set up the path where the list of the words are stored.

KbName('UnifyKeyNames');


pathList='Lists/TAC/WordLists/';

pathInstru='Lists/TAC/Instructions/';

%NumberItems=40;

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

%Define the parameters used in the task
EncodingCSV='UTF-8'; %Specify the encoding of the csv file
EncodingTxT='Macintosh';%Specify the encoding of the txt file

InstructionScreensPart1=[1;2;3;4;5]; %How many instruction display before training
InstructionQuestion=6;
InstructionScreensPart2=[7;8;9]; %How many instruction display before training
InstructionScreensPart3=10; %How many instruction display after training
Time2Wait=30; %How many seconds to wait for trial (always +1)
Time2Wait_Q=4.5; %How many seconds to wait for "eureka" (always +1)
WhenPause=50;%Decide the number of trial before to pause, if not integer, round the number to superior
%CountPauseSet=0; %Set up Pause counter
NumberTraining=10; %Define the number of training items (max10)
StartAnswer=5; %Define the columns where the first "answer" is store
EndAnswer=28; %Define the columns where the last "answer" is store
WhereAnswer=32; %Define the columns where answer from participant is store
WhereScore=38; %Define the columns where answer from participant is store
WhereEureka=35; %Define the columns where answer from participant is store

FontSizeInstruct=45; %Define the size of the font for the instructions
FontSizeTrial=60; %Define the size of the font for the cues words in the trials
FontSizeEureka=40; %Define the size of the font for the cues words in the trials
NormalColor=[255 255 255];

BackgroundWT= [0 0 0];
BackgroundNT=[127 127 127];

SpaceBar=KbName('SPACE');
VLetter=KbName('V');
NLetter=KbName('N');
LeftArrow=KbName('LeftArrow');
RightArrow=KbName('RightArrow');
%Specify the only key enable for the task (space bar, y , n)
RestrictKeysForKbCheck(SpaceBar);

TimeThink=0.5;
TimeITI=0.5;
TypeRespTrial='keyboard';
TypeRespEureka='Choice';

WhichChoice={'v','n'};

HowMuchItem=8;

NumberITemsTrain=10;

NumberItemsTask=100;

OutputScreen=0;

%Need to change to 2 fro groupe phase 2
PNType='C17-61_2_';

QuestionInstruction='Est ce que votre reponse est apparue d''un coup, sans effort (Eureka)? \n \n Repondez avec les touches V (oui) ou N (non) du clavier.';