%Parameters
KbName('UnifyKeyNames') % cross compatibility
% CreationOnlySet=str2num(AnswerStart{2}); %Decide if should only create a set
% NumberMotorvisuo=str2num(AnswerStart{3}); %Define the number of training of motor
% NumberItemsTraining=str2num(AnswerStart{4}); %Define the number of normal training
% NumberItems = str2num(AnswerStart{5}); %Define the number of item to test
path=[pwd '/'];
lineLength    = 10; %Line length of the scale
width         = 5; %Width fo the scale
scalaLength   = 0.7; %Length of the marker in the scale
scalaPosition = 0.5; %Position of the marker in the scale
sliderColorThink    = [255 0 0]; % color of the slider; Red
sliderColorSelection    = [0 255 0]; % color of the slider; green

lineLengthSlider= 20; %Length of the slider
scaleColor = [0 255 0]; %Color of the scale; grey
NormalColor=[255 255 255];
wordColor = [255 255 0]; %Color of the word when need to choose; Yellow
device = 'mouse'; %Which device to use the scale. 

fixCrossDim=0.09; %Size fixation Cross
lineWidthPix=0.01; %Width fixation Cross

TimeToThink=2; %Decide the number of seconds where participants have the time to think
responseKey   = KbName('return'); %Return the keycode for the key 'return'
startPosition = 'center'; %Select the start position of the cursor
endPoints={'0 = Pas du tout lie', '100= Completement lie'}; %Which word there is at the end of the scale



InstructionScreensPart1=[1;2;3;4]; %Instruction at the beginning
InstructionScreensPart2=[5;6;7;8;9;10]; %Instruction after motor training and before normal training
InstructionScreensPart3=11; %Instruction after normal training and experiment
InstructionScreensPart4=[12;13;14]; %Instruction after normal training and experiment
InstructionScreensPart5=15;


EncodingInstruction='UTF-8'; %Specify the encoding of the instruction file
EncodingFile='Macintosh'; %Specify the encoding of the txt file
leftKey = KbName('LeftArrow'); %GetName of left arrow in keyboard
rightKey = KbName('RightArrow'); %GetName of right arrow in keyboard

pixelsPerPress = 10; % Movement of pixel per change if keyboard
PercentToMove=0.01; %Percent to move the cursor before can do something

EscKey=KbName('ESCAPE');
SpaceKey=KbName('SPACE');
KeyT=KbName('t');
KeyTTL=KbName('5%');

Enablekeys = RestrictKeysForKbCheck([EscKey SpaceKey]);

TTLSreen=InstructionScreensPart5;

InstructFontChg=30; %Modify the font size of the instruction; 0.15/0.08
CuesFontChg=35; %Modify the font size of the cues 0.15/0.08
EndPointsFontChg=25; %Modify the font size of the end points 0.07/0.04
EndPointsPositionYChg=0.08; %Modify the Y position of the end points
%EndPointsPositionXChg=0.16; %Modify the X position of the end points
CuesPositionYChg=0.85; %Modify the Y position of the cues
MouseSpeedFactor = 2.4; %Define the parameter of the speed of the mouse 

if strcmp(device, 'mouse')
    responseKey   = 1; % X mouse button
    responseKeySecond=2;
elseif strcmp(device, 'keyboard')
    responseKey   = KbName('ENTER'); % Enter on the keyboard
end

if IsWindows || IsOSX
    MouseDeviceIndex = 1; % Matthieu
elseif IsLinux
    MouseDeviceIndex = 12; % Linux -> trackball
end


WhenCrossTraining=[4,8,12];


PauseScreen=1;

%Need to change to 2 fro groupe phase 2
PNType='C17-61_1_';
