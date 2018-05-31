function Output=AJTRun(Output,AllRun,RunList,HowManyRun,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Save,DateString,PN,Initials)

AJTpar.Parameters;

%Instructions before task
%AJTfct.Display_Instructions(InstructionScreensPart4,EncodingInstruction,WhichTask,NormalColor,path,screenXpixels,screenYpixels,InstructFontChg,window)

for CurrentRun = 1:HowManyRun
    TempIndexRun=AllRun(CurrentRun);
    Run=RunList(TempIndexRun,:);
    StartSequence=GetSecs;
    Output.StartSeq=StartSequence;

    Output=AJTfct.AJTBlock(Output,Run,TempIndexRun,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Save,DateString,PN,Initials);
    
    EndSequence=GetSecs;
    AllSequence=EndSequence-StartSequence;
    Output.EndSeq=EndSequence;
    Output.AllSeq=AllSequence;
    
    %Save
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(TempIndexRun)],'Output');
    end
    
    if CurrentRun~=HowManyRun
        AJTfct.Break(window,NormalColor,60);
    end
end

end