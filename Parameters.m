%Parameters
KbName('UnifyKeyNames') % cross compatibility
% CreationOnlySet=str2num(AnswerStart{2}); %Decide if should only create a set
% NumberMotorvisuo=str2num(AnswerStart{3}); %Define the number of training of motor
% NumberItemsTraining=str2num(AnswerStart{4}); %Define the number of normal training
% NumberItems = str2num(AnswerStart{5}); %Define the number of item to test
path=[pwd '/'];
lineLength    = 10; %Line length of the scale
width         = 5; %Width fo the scale
scalaLength   = 0.6; %Length of the marker in the scale
scalaPosition = 0.5; %Position of the marker in the scale
sliderColor    = [255 0 0]; % color of the slider; Red
lineLengthSlider= 20; %Length of the slider
scaleColor = [0 255 0]; %Color of the scale; grey
NormalColor=[255 255 255];
wordColor = [255 255 0]; %Color of the word when need to choose; Yellow
device = 'mouse'; %Which device to use the scale. 

TimeToThink=2; %Decide the number of seconds where participants have the time to think
responseKey   = KbName('return'); %Return the keycode for the key 'return'
startPosition = 'center'; %Select the start position of the cursor
endPoints={'0 = Pas du tout Lié', '100= Complètement lié'}; %Which word there is at the end of the scale
InstructionScreensPart1=[1;2]; %Instruction at the beginning
InstructionScreensPart2=[3;4]; %Instruction after motor training and before normal training
InstructionScreensPart3=5; %Instruction after normal training and experiment
EncodingInstruction='UTF-8'; %Specify the encoding of the instruction file
EncodingFile='Macintosh'; %Specify the encoding of the txt file
leftKey = KbName('LeftArrow'); %GetName of left arrow in keyboard
rightKey = KbName('RightArrow'); %GetName of right arrow in keyboard
pixelsPerPress = 10; % Movement of pixel per change if keyboard
PercentToMove=0.05; %Percent to move the cursor before can do something
InstructFontChg=0.07; %Modify the font size of the instruction
CuesFontChg=0.09; %Modify the font size of the cues
EndPointsFontChg=0.05; %Modify the font size of the end points
EndPointsPositionYChg=0.05; %Modify the Y position of the end points
EndPointsPositionXChg=0.16; %Modify the X position of the end points
CuesPositionYChg=0.75; %Modify the Y position of the cues
MouseSpeedFactor = 1.5; %Define the parameter of the speed of the mouse 

if strcmp(device, 'mouse')
    responseKey   = 1; % X mouse button
elseif strcmp(device, 'keyboard')
    responseKey   = 88; % Enter on the keyboard
end

if IsWindows || IsOSX
    MouseDeviceIndex = 1; % Matthieu
elseif IsLinux
    MouseDeviceIndex = 12; % Linux -> trackball
end