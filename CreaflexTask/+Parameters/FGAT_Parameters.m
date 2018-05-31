%FGAT parameter


%Define the parameters used in the task

OutputScreen=0;

pathList='Lists/FGAT/WordLists/';

pathInstru='Lists/FGAT/Instructions/';

EncodingFile='UTF-8'; %'Macintosh'%Specify the encoding of the txt file
EncodingInstruction='UTF-8'; %'Macintosh'%Specify the encoding of the txt file

FontSizeInstruct=45; %Define the size of the font for the instructions
FontSizeTrial=60; %Define the size of the font for the cues words in the trials
InstructionScreens_Part1=[1;2]; %number of screens of instruction display for part 1
InstructionScreens_Part2=[3;4;5]; %number of screens of instruction display for part 2
Time2Wait_Part1=10; %Specify time to wait for part 1 (+1)
Time2Wait_Part2=20; %Specify time to wait for part 2 (+1)


CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');
PNType='C17-61_2_';

NormalColor=[255 255 255];

BackgroundWT= [0 0 0];
BackgroundNT=[127 127 127];

TimeThink=0.5;
TimeITI=0.5;

TypeResp='keyboard';

NumberItems=63;%63