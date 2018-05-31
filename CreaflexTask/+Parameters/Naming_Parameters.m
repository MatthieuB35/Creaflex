%Naming Parameter
%Specify the number of instruction screens
InstructionScreens=[1;2];

FontSizeInstruct=45; %Define the size of the font for the instructions
FontSizeTrial=60; %Define the size of the font for the cues words in the trials

pathPic='Lists/Naming/Pictures/';

pathInstru='Lists/Naming/Instructions/';

%create variable that will contains the name of the picture and how many
%time the participant need to answered


%Specify the encoding of the txt file
EncodingInstru='Macintosh';

%Specify the maximum amount of time to answer (+1)
Time2Wait=10;

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

PNType='C17-61_2_';

NormalColor=[255 255 255];

BackgroundWT= [0 0 0];
BackgroundNT=[127 127 127];

OutputScreen=0;

NumberItems=40; %40

TypeResp='keyboard';

TimeThink=0.5;

HowManyTimeAsk=1;

Str2Ask={'Reponse?'};

Time2Answer=5;