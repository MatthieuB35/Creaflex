%PPTT parameter

OutputScreen=0;

pathList='Lists/PPTT/WordLists/';

pathInstru='Lists/PPTT/Instructions/';

%Specify the encoding of the txt file
EncodingInstruction='Macintosh';
EncodingList='UTF-8';

%Specify the number of instructions screens
InstructionScreens_Part1=1;
InstructionScreens_Part2=2;

FontSizeInstruct=45; %Define the size of the font for the instructions
FontSizeTrial=60; %Define the size of the font for the cues words in the trials

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

PNType='C17-61_2_';

%How many seconds to wait (always +1)
Time2Wait=10;

TypeResp='Choice';

WhichChoice={'LeftArrow','RightArrow'};

%Specify the only key enable for the task (space bar, Left_Arrow , Right_Arrow)
RestrictKeysForKbCheck([44, 79, 80]);

NormalColor=[255 255 255];

BackgroundWT= [0 0 0];
BackgroundNT=[127 127 127];

TimeThink=0.5;
TimeITI=0.5;

NumberItems=40; %40