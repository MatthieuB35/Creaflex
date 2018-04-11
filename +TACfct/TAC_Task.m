function TAC_List=TAC_Task(TAC_List,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition)

TACpar.Parameters

NumberItems=size(TAC_List,1);
NumberCol=size(TAC_List,2);


for WhichIteration_training = 1:NumberItems
    
    textString_Top = char(TAC_List{WhichIteration_training,2});
    textString_Left = char(TAC_List{WhichIteration_training,3});
    textString_Right = char(TAC_List{WhichIteration_training,4});
    
    ListElements={textString_Top textString_Left textString_Right};
    
    TempOutput=TACfct.TAC_Trials(ListElements,window,LeftScreenPosition,RightScreenPosition,BottomScreenPosition,TopScreenPosition);
    HowManyCol=length(TempOutput);
    
    TAC_List(WhichIteration_training,NumberCol+1:NumberCol+HowManyCol)=TempOutput;
    
    
    if WhichIteration_training==WhenPause
        TACfct.Break(window,NormalColor,60)
    end
end

end