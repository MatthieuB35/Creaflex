%Similarity parameters

%Set up the path where the list of the words are stored.
path='/Users/clarisseaichelburg/Documents/Master2-MatthieuB/Taches_CreaFlex/tests_neuropsy/Similitudes/';


pathList='Lists/Similarity/WordLists/';

pathInstru='Lists/Similarity/Instructions/';

%Specify the encoding of the txt file
EncodingList='UTF-8';
EncodingInstru='Macintosh';
FontSizeInstruct=45; %Define the size of the font for the instructions
FontSizeTrial=60; %Define the size of the font for the cues words in the trials

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

PNType='C17-61_2_';

%Specify the number of instructions screens
InstructionScreens=[1;2];
InstructionScreen2=3;


%How many seconds to wait (always +1)
Time2Wait=20;

NormalColor=[255 255 255];

BackgroundWT= [0 0 0];
BackgroundNT=[127 127 127];

TimeThink=0.5;
TimeITI=0.5;

OutputScreen=0;

TypeResp='keyboard';

NumberItems=28; %28
