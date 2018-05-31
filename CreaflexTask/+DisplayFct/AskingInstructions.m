function Output=AskingInstructions(Question,Encoding,WhichColor,path,window,LeftArrow,RightArrow,FontSizeInstruct)



RestrictKeysForKbCheck([LeftArrow, RightArrow]);

Output=cell(2,1);

%%First part of the instructions
% Setup the text type for the window
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, FontSizeInstruct);

%Import the data for the instruction
TempInstructionFile = fopen([path 'Instruction_' num2str(Question) '.txt'],'r+','n',Encoding);

%Scan all the lines of the instructions and put it in a variable
TempInstruction = textscan(TempInstructionFile,'%s','delimiter','\n');

%Close the file
fclose(TempInstructionFile);

%Draw the instructions on the screen
DrawFormattedText(window, strrep(strjoin(TempInstruction{1}),'`',''''), 'center', 'center',WhichColor);

%Flip to the screen
Screen('Flip', window);

%Wait 0.5 seconds to ensure the slide don't skip.
WaitSecs(0.5);

%Wait for the participant to press a button to continue
[~, keyCode, deltaSecs]=KbWait;
if strcmp(KbName(find(keyCode)),'LeftArrow')
    TempResponse=1;
else
    TempResponse=0;
end
Output{1}=TempResponse;
Output{2}=deltaSecs;

RestrictKeysForKbCheck([]);
end