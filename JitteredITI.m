function Output=JitteredITI(Mean,Max,Min,Steps,HowManyITI)
Output=struct;
Output.Seed=rng('shuffle');

Output.ListITI=zeros(HowManyITI,1);

StepsTemp=(Max-Mean)/Steps;

AllPossib=linspace(Max,Min,StepsTemp*2+1);

for WhichITI = 1:HowManyITI
    Output.ListITI(WhichITI)= AllPossib(randperm(length(AllPossib),1));
end
end


