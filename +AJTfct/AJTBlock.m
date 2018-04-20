function Output=AJTBlock(Output,Run,TempIndexRun,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Save,DateString,PN,Initials)

AJTpar.Parameters;

BeginFirstCross=GetSecs;
%Fixation across appear for 8+2s
AJTfct.FixationCross(8,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
%2s before end, change of colour
AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
EndFirstCross=GetSecs;
Output.FirstCross=EndFirstCross-BeginFirstCross;

for WhichBlock=1:(length(Run))
    StartBlock=GetSecs;
    
    Block=load(['AJTlists/AJT_Block_' num2str(Run(WhichBlock)) '.mat']);
    WordList_AllTrial=Block.Block;
    Jittered=Block.Jittered.ListITI;
    NbrTrial=length(WordList_AllTrial);
    
    OutputTask=AJTfct.TaskAJT(NbrTrial,WordList_AllTrial,window,screenXpixels, screenYpixels,midTick,leftTick,rightTick,horzLine,rect,xCenter, yCenter,aborttime,Jittered);
    Output.(['TaskBlock' num2str(WhichBlock)])=OutputTask;
    
    if Save==1
        save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(TempIndexRun)],'Output');
    end
    
    EndBlock=GetSecs;
    Output.(['TimeBlock' num2str(WhichBlock)])=EndBlock-StartBlock;
    
    XStartCross=GetSecs;
    if WhichBlock ~= length(Run)
        %Fixation across appear for 18+2s
        AJTfct.FixationCross(18,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
        %2s before end, change of colour
        AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
    else
        %Fixation across appear for 8+2s
        AJTfct.FixationCross(8,NormalColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
        %2s before end, change of colour
        AJTfct.FixationCross(2,wordColor,window,screenXpixels, screenYpixels,xCenter, yCenter);
    end
    XEndCross=GetSecs;
    Output.(['Cross_Number' num2str(WhichBlock)])=XEndCross-XStartCross;
end

if Save==1
    save([DateString '_AJT_' PNType PN '_' Initials '_Run' num2str(TempIndexRun)],'Output');
end

end