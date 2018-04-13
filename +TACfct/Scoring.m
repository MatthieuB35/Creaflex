function TAC_ResList=Scoring(TAC_ResList)

TACpar.Parameters

%Check if the answer is correct:

HowManyRow=size(TAC_ResList,1);
HowManyCol=size(TAC_ResList,2);
AllSets=StartAnswer:EndAnswer;

for WhichRow =1:HowManyRow
    AllIndex=strcmp(TAC_ResList(WhichRow,AllSets),TAC_ResList(WhichRow,WhereAnswer));
    if sum(AllIndex)>=1
        RealIndex=AllSets(AllIndex);
        TAC_ResList{WhichRow,HowManyCol+1}=1;
        TAC_ResList{WhichRow,HowManyCol+2}=RealIndex;
    else
        TAC_ResList{WhichRow,HowManyCol+1}=0;
        TAC_ResList{WhichRow,HowManyCol+2}='none';
    end
end

end