%Stroop parameters

%Specify the encoding of the txt file
EncodingInstru='Macintosh';

pathPictures='Lists/Stroop/Pictures/';

pathInstru='Lists/Stroop/Instructions/';

OutputScreen=0;

%Specify the number of instructions screens for each part
InstructionScreens_AfterTraining=0;
Instr=struct;
Instr.InstructionScreens_Part1=[1;2];
Instr.InstructionScreens_Part2=3;
Instr.InstructionScreens_Part3=4;
Instr.InstructionScreens_Part4=5;

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

FontSizeInstruct=45; %Define the size of the font for the instructions
FontSizeTrial=60; %Define the size of the font for the cues words in the trials

PNType='C17-61_2_';

%Write the instruction after the training
AfterInstruction='Si vous n''avez pas de question concernant la tache vous pouvez commencer le test. \n \n Appuyez sur la touche Espace pour commencer.';

BackgroundWT= [0 0 0];
NormalColor=[255 255 255];

NumberItems=4;

TimeThink=0.5;

HowManyTimeAsk=2;

OutputOfInterest=[1;3;5];

TypeResp='keyboard';

Str2Ask={'EC?','ENC?'};

Time2Answer=100;