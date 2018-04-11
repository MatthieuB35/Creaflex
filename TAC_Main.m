OutputScreen=1;
PN='0';
Save=1;

TACpar.Parameters

TAC_task=table2array(readtable([path '/TAC_list/TAC40_list.csv'],'ReadVariableNames',true,'FileEncoding',EncodingCSV));
 
 
%Import the training list of the words and create a variable to contain it.
TAC_training=table2array(readtable([path '/TAC_list/TAC_training.csv'],'ReadVariableNames',true,'FileEncoding',EncodingTxT));

TACpar.Screen_parameters

CurrentDate = datetime('now');
DateString = datestr(CurrentDate,'yyyymmdd');

%Silent the input from keyboard
ListenChar(2)
HideCursor(OutputScreen);

TACfct.Display_Instructions(InstructionScreensPart1,EncodingTxT,NormalColor,path,window)

Results_Training=TACfct.TAC_Task(TAC_training,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition);

TACfct.Display_Instructions(InstructionScreensPart2,EncodingTxT,NormalColor,path,window)

Results_Task=TACfct.TAC_Task(TAC_task,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition);

if Save==1
    save([DateString '_TAC_Pilot_PN' PN '_Run'],'Results_Training','Results_Task');
end


ListenChar(0)
clearvars
sca