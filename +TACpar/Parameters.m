%Set up the path where the list of the words are stored.
path=pwd;

KbName('UnifyKeyNames');

%Define the parameters used in the task
EncodingCSV='UTF-8'; %Specify the encoding of the csv file
EncodingTxT='Macintosh';%Specify the encoding of the txt file
InstructionScreensPart1=[1;2;3;4;5;6]; %How many instruction display before training
InstructionScreensPart2=7; %How many instruction display after training
Time2Wait=30; %How many seconds to wait for trial (always +1)
Time2Wait_Q=4.5; %How many seconds to wait for "eureka" (always +1)
WhenPause=20;%Decide the number of trial before to pause, if not integer, round the number to superior
%CountPauseSet=0; %Set up Pause counter
NumberTraining=10; %Define the number of training items (max10)
StartAnswer=5; %Define the columns where the first "answer" is store
EndAnswer=28; %Define the columns where the last "answer" is store
FontSizeInstruct=50; %Define the size of the font for the instructions
FontSizeTrial=60; %Define the size of the font for the cues words in the trials
FontSizeEureka=50; %Define the size of the font for the cues words in the trials
NormalColor=[255 255 255];

BackgroundBlack= [0 0 0];
BackgroundGrey=[127 127 127];

SpaceBar=KbName('SPACE');
VLetter=KbName('V');
NLetter=KbName('N');
%Specify the only key enable for the task (space bar, y , n)
RestrictKeysForKbCheck([SpaceBar, VLetter, NLetter]);

HowMuchItem=8;

QuestionInstruction='Est ce que votre reponse est apparue d''un coup, sans effort (Eureka)? \n \n Repondez avec les touches V (oui) ou N (non) du clavier.';