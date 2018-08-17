function Display_Instructions(ListNumberInstructions,EncodingInstruction,WhichType,WhichColor,path,screenXpixels,screenYpixels,InstructFontChg,window)

AJTpar.Parameters;



%Modify screen size
%ModifyResolution=(screenYpixels/screenXpixels)+1;
ModifyResolution=(screenXpixels/screenYpixels);

%SizeFontModifyInstruct=round((screenXpixels-screenYpixels)*InstructFontChg*ModifyResolution);
SizeFontModifyInstruct=round(ModifyResolution*InstructFontChg);

%%First part of the instructions
for InstructionNumber= 1:length(ListNumberInstructions)
    
    % Setup the text type for the window
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, SizeFontModifyInstruct);
    
    %Import the data for the instruction
    TempInstructionFile = fopen([path 'AJTinstr/' WhichType '/Instruction_' num2str(ListNumberInstructions(InstructionNumber)) '.txt'],'r+','n',EncodingInstruction);
    
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
    
    if ListNumberInstructions==TTLSreen
        RestrictKeysForKbCheck(KeyTTL);
        fprintf('******************* \n')
        fprintf('Waiting for MRI key \n')
        fprintf('******************* \n')
        KbWait;
        fprintf('Key received ! \n')
    else

        fprintf('Waiting for any click...')
        
        % Wait for a click on the mouse (any button)
        while 1
            [~,~,buttons,~,~,~] = GetMouse(window, MouseDeviceIndex);
            if any(buttons)
                break
            end
        end
        
        fprintf('done.\n')
        
    end
    
end

if ListNumberInstructions==TTLSreen
    RestrictKeysForKbCheck([]);
end

end