%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Selection nodes
% Version: 3.5
% Last Edited: 22/03/2018
% Author: Matthieu Bernard
% Language of the task: English
% Description;
%
% Requires: - A distance matrix in a mat format.
%           - A community matrix for the different nodes in a mat format.
%           - Lexical dictionnary with the syllabes, and lexical
%           frequencies
%           - The labels of theses nodes in a csv file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%%Create a input box to decide if need to load the files

clearvars;

OutputGUI=GUI_SelectionNode;


LoadingNeeded=OutputGUI.LoadData;
WhichSelection=OutputGUI.WhichSelection;

%Define the parameters used in the task
CreationIndex=OutputGUI.DoCreationIndex; %Decide if create of the index variables

NumberNodes=OutputGUI.NumberNodes; %Number of nodes within the graph
NumberNodesSelect=OutputGUI.NbrNodesSelect; %Number of nodes that should be selected
NumberPairs=NumberNodesSelect*(NumberNodesSelect-1)/2; %Number of pairs from the permutation of the nodes selected
Categories=OutputGUI.DistCat; %Which distance categories are selected
NumberCat=length(Categories); %The number of distance category selected
NumberPairsPerCat=NumberPairs/NumberCat; %The ideal number of pairs of nodes per distance category
MinimumFrequency=OutputGUI.MinFreq; %The minimal lexical frequency accepted
MaximumSyllabes=OutputGUI.MaxSyl; %The maximum number of syllabes accepted
OnlyNoun=OutputGUI.OnlyNouns; %Decide if take only nouns
WordsOtherTask=OutputGUI.WordsOtherTask; %Decide if delete the words used in other tasks
NodesArticles=OutputGUI.Articles; %Decide if delete words with articles in the nodes
AmbiguousRemove=OutputGUI.Ambiguous; %Decide if delete words that are ambiguous

%Define the parameters used in the task
TreeCreation=OutputGUI.DoCreationTree; %Decide if create trees
OriginTree=OutputGUI.KeepOrigin; %Decide if keep the origin of the trees
TreeSummary=OutputGUI.CreateSummaryTable; %Decide if create a summary of the tree
TreeSummaryCommu=OutputGUI.CreateCommuTable; %Decide if create a summary of the tree with the communities details


%Define the parameters used in the task
OutputLabel=OutputGUI.DoSelectionTree;%Decide if select subset of trees and create their label outputs
PercMinDistCat=OutputGUI.MinStep1; %Decide the minimum % of distance categorie 1
PercMaxDistCat=OutputGUI.MaxStep5; %Decide the maximum % of distance categorie 5+
MinNodes=OutputGUI.MinNbrNodes; %Decide the minimum of nodes that should be selected in the subset
MaxNodes=OutputGUI.MaxNbrNodes; %Decide the maximum of nodes that should be selected in the subset
Save=OutputGUI.SaveSelection; %Decide if save the subset output

%%%Loading of all the different files
if LoadingNeeded == 1
    %Set up the path where the files are stored
    path=pwd;
    %Specify the encoding for the lexical file
    EncodingLexical='macintosh';
    %Specify the encoding for the labels
    EncodingLabels='UTF-8';
    
    %Load/import the distance matrix and the community files
    load([path '/Community_partition.mat']); %variable name as ciu1
    load([path '/Distance_matrix.mat']); %variable name as D
    
    %Load the dictionnary and create different variable to store the
    %elements of interest (frequence, type, syllabes)
    LexicalFreq=readtable([path '/LexiqueCheck.csv'],'ReadVariableNames',true,'FileEncoding',EncodingLexical);
    LexicalFreqWordIndex=table2array(LexicalFreq(:,1));
    LexicalFreqType=table2array(LexicalFreq(:,3));
    LexicalSyllabes=table2array(LexicalFreq(:,8));
    
    %Load the labels of the nodes and put in two variables the names and
    %their labels.
    Labels=readtable([path '/IndexNames_cues.csv'],'FileEncoding',EncodingLabels);
    %Create a variable for the index of the labels
    Labels_Index=table2array(Labels(:,1));
    %Create a variable for the labels names
    Labels_Names=table2array(Labels(:,2));
    %Clear the main variable for space saving
    clear Labels
    
    %Load the words list of the other task
    WordOtherList=table2array(readtable([path '/WordsOtherTask.csv'],'ReadVariableNames',true,'FileEncoding',EncodingLexical));
end

%%

%%%Creation of the index of the distance categories
if CreationIndex==1
    %Select only the upper triangle of the matrix since it's a mirror
    %matrix
    Distances=triu(D);
    %Create a variable where all the rejected nodes will be stored
    RejectedNodes=[];
    %Create a structure where the different index for the distances category will be stored
    AllIndex=struct;
    
    %/!!!\ Create varibales for nodes that contains article or non-word
    %character
    Index_Le = find(contains(Labels_Names,'le '));
    Index_La = find(contains(Labels_Names,'la '));
    Index_Un = find(contains(Labels_Names,'un '));
    Index_Une = find(contains(Labels_Names,'une '));
    Index_vb = find(contains(Labels_Names,'(vb),'));
    Index_L = find(contains(Labels_Names,"l'"));
    
    %Checking of the different words, if it's not correct, replace the row
    %and columns by a 0 for the current node.
    for WhichNodes = 1:NumberNodes
        %Reset the counter checking if there is a deleted node
        DeleteNode=0;
        %Create/reset a variable that control if the current node should be
        %deleted or not
        ToBeDeleteNoun=0;
        %Check if the current nodes as any of the article. If so, it
        %determines that it's a noun and will select the row in the
        %dictionnary where it's a noun.
        if ismember(WhichNodes,Index_Le)
            [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WhichNodes,LexicalFreqWordIndex,LexicalFreq,LexicalFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove,'le ');
            
        elseif ismember(WhichNodes,Index_La)
            [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WhichNodes,LexicalFreqWordIndex,LexicalFreq,LexicalFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove,'la ');
            
        elseif ismember(WhichNodes,Index_L)
            [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WhichNodes,LexicalFreqWordIndex,LexicalFreq,LexicalFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove,"l'");
            
        elseif ismember(WhichNodes,Index_vb)
            [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WhichNodes,LexicalFreqWordIndex,LexicalFreq,LexicalFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove,'(vb),');
            
        elseif ismember(WhichNodes,Index_Un)
            [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WhichNodes,LexicalFreqWordIndex,LexicalFreq,LexicalFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove,'un ');
           
        elseif ismember(WhichNodes,Index_Une)
            [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WhichNodes,LexicalFreqWordIndex,LexicalFreq,LexicalFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove,'une ');
            
        else
            [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WhichNodes,LexicalFreqWordIndex,LexicalFreq,LexicalFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove);
            
        end
        
        %If didn't find an index, put index as 1 because will be deleted
        %anyway
        if isempty(Index)
            Index=1;
            ToBeDeleteCurrent=1;
        end
        
        if isempty(IndexOfInterest) %If didn't find any IndexOfInterest
            ToBeDeleteCurrent=1; %Delete current word
        end
        
        if isempty(SimilarWordDelete)==0 %If similar word not empty
            %Replace row
            Distances(SimilarWordDelete,:)=0;
            %Replace column
            Distances(:,SimilarWordDelete)=0;
            %Add up the rejected nodes in a variable.
            %Add up 1 to counter if there is a deleted node
            DeleteNode=DeleteNode+1;
        end
        
        %If not a noun, replace the current node and column by 0
        if isempty(ToBeDeleteCurrent)==0 && OnlyNoun==1
            %Replace row
            Distances(WhichNodes,:)=0;
            %Replace column
            Distances(:,WhichNodes)=0;
            %Add up the rejected nodes in a variable.
            %Add up 1 to counter if there is a deleted node
            DeleteNode=DeleteNode+1;
        end
        
        %If the lexical frequency is strictly under the maximum defined,
        %replace the current node row and column with 0
        Frequency=mean(table2array(LexicalFreq(Index(IndexOfInterest),4:7)));
        if Frequency < MinimumFrequency
            %Replace row
            Distances(WhichNodes,:)=0;
            %Replace column
            Distances(:,WhichNodes)=0;
            %Add up 1 to counter if there is a deleted node
            DeleteNode=DeleteNode+1;
        end
        
        %If the number of syllabes is strictly above the maximum defined,
        %replace the current node row and column with 0
        Syllabes=LexicalSyllabes(Index(IndexOfInterest));
        if Syllabes > MaximumSyllabes
            %Replace row
            Distances(WhichNodes,:)=0;
            %Replace column
            Distances(:,WhichNodes)=0;
            %Add up 1 to counter if there is a deleted node
            DeleteNode=DeleteNode+1;
        end
        
        %Delete if in FGAT/CAT/Simi (other tasks of the experience)
        InOtherTask=find(ismember(WordOtherList,TempWord));
        if isempty(InOtherTask)==0 && WordsOtherTask==1
            %Replace row
            Distances(WhichNodes,:)=0;
            %Replace column
            Distances(:,WhichNodes)=0;
            %Add up 1 to counter if there is a deleted node
            DeleteNode=DeleteNode+1;
        end
        
        %Store in a variable all the nodes deleted
        if ToBeDeleteCurrent==1
            %Add up the rejected nodes in a variable.
            RejectedNodes=[RejectedNodes WhichNodes];
        end
    end
    
    %Create sub-structure storing the different distance categoriesAll
    %index (row/col) comparaisons for the different categories
    for WhichCategory = 1:NumberCat
        %Check if it is the last category wanted
        if WhichCategory==NumberCat
            %If yes, store in the sub-structure all the distance categories
            %for the last one and for the above.
            [row,col]=find(Distances==WhichCategory);
            AllIndex.(['N' num2str(WhichCategory)])=[row,col];
            
            [row,col]=find(Distances>WhichCategory);
            AllIndex.(['N' num2str(WhichCategory+1)])=[row,col];
        else
            %If not, store in the sub-structure the current distance
            %categories of interest
            CurrentCat=Categories(WhichCategory);
            [row,col]=find(Distances==WhichCategory);
            AllIndex.(['N' num2str(WhichCategory)])=[row,col];
        end
    end
end

%%
%%%Select the X nodes

%%%Creation of the trees
if TreeCreation==1
    %Create a variable that contains all the index that survive the cleaning
    IndexAll=1:1080;
    ListOfAllIndex=setdiff(IndexAll,RejectedNodes);
    
    %Set up a counter for the number of iteration for the ouput structure
    CounterIteration=1;
    %Create a structure that will contains the selection of nodes
    OutputSelectionNodes=struct;
    
    %Start a for loop that will turn and put in the ouput matrix all the "tree"
    %that have a number of nodes above that the number desired.
    for WhichStartNode=1:length(ListOfAllIndex)
        %Create a temporary structure that will contains the details of the
        %selection of nodes
        TempStoreIteration=struct;
        %Select a starting node in a random way and store it in the structure
        StartNode=ListOfAllIndex(WhichStartNode);
        TempStoreIteration.StartNode=StartNode;
        %Create a temporary variable that store all the nodes used in the "tree".
        AllNodesTemp=StartNode;
        
        %Start the creation of a "tree" starting for the node selected and
        %finding all the neigbors nodes. In a reccursive fashion, the next
        %iteration of the loop will look at the neigbors nodes of the previous
        %nodes. So on until it reaches the maximum of distance categories of
        %interest.
        for WhichStep = 1:NumberCat
            %Check if it's the start node or not
            if WhichStep==1
                %Check all the neigbors nodes for the starting node and find
                %their index.
                AllEdgesCatTemp=ismember(AllIndex.N1,StartNode);
                CorrectEdgesCatTemp = find(AllEdgesCatTemp(:,1)==1 | AllEdgesCatTemp(:,2)==1);
                %Store the pairs of nodes in the structure
                TempStoreIteration.(['Step' num2str(WhichStep)])= AllIndex.N1(CorrectEdgesCatTemp,:);
                %Create and store the list of the neigbors nodes of the
                %current iteration (minus the starting nodes).
                GoodSelection=setdiff(TempStoreIteration.(['Step' num2str(WhichStep)]),StartNode);
                TempStoreIteration.(['Selection' num2str(WhichStep)])=GoodSelection;
                %Store in a temporary variable the list of the neigbors nodes
                %for the next iteration.
                TempSelection=GoodSelection;
                %Put in a temporary variable the index to check in the next
                %iteration
                PreviousIndex= CorrectEdgesCatTemp;
            else
                %Check all the neigbors nodes of the previous iteration and
                %find their index.
                AllEdgesCatTemp=ismember(AllIndex.N1,TempSelection);
                CorrectEdgesCatTemp = find(AllEdgesCatTemp(:,1)==1 | AllEdgesCatTemp(:,2)==1);
                %Delete all the nodes that where in the previous iteration to
                %keep only the new pairs of nodes.
                GoodIndex=setdiff(CorrectEdgesCatTemp,PreviousIndex);
                %Store the pairs of nodes in the structure
                TempStoreIteration.(['Step' num2str(WhichStep)])= AllIndex.N1(GoodIndex,:);
                %Create and store the list of the neigbors nodes of the
                %current iteration (minus the previous nodes).
                GoodSelection=setdiff(TempStoreIteration.(['Step' num2str(WhichStep)]),TempSelection);
                TempStoreIteration.(['Selection' num2str(WhichStep)])=GoodSelection;
                %Store in a temporary variable the list of the neigbors nodes
                %for the next iteration.
                TempSelection=GoodSelection;
                %Put in a temporary variable the index to check in the next
                %iteration
                PreviousIndex=GoodIndex;
            end
            %Store in the temporary variable the selection of nodes of the
            %current iteration
            AllNodesTemp=[AllNodesTemp; GoodSelection];
        end
        if OriginTree==0
            %Delete the starting nodes from the total of nodes
            AllNodesTemp(1)=[];
        end
        %Store in the structure in a variable, all the nodes used for the
        %creation of the three
        TempStoreIteration.AllNodes=AllNodesTemp;
        
        %Check if the current amount of nodes in the "tree" is above to the
        %number desired, if so store the structure and start the next iteration
        if length(TempStoreIteration.AllNodes)>=NumberNodesSelect
            OutputSelectionNodes.(['Iteration' num2str(CounterIteration)])=TempStoreIteration;
            %Add 1 to the counter for the iteration item structure
            CounterIteration=CounterIteration+1;
        end
    end
end



%%%Create an output table that will contains the information of the tree
%C1: Index | C2: Number of nodes | C3: Number of communities
%C4-8: Percentage of pairs existing in each distance categories
%(1,2,3,4,5+) | C9:Total number of distance categories
if TreeCreation==1 && TreeSummary==1
    %Create a variable to store the summary of the trees
    TableSummaryTree=zeros(length(fieldnames(OutputSelectionNodes)),4);
    
    %Go through all the trees created and look at the % of pairs existing
    %for all the possible distance categories in the current tree.
    for WhichTree = 1:(length(fieldnames(OutputSelectionNodes)))
        %Create all combination between the output nodes for the current
        %tree
        AllCombin = nchoosek(OutputSelectionNodes.(['Iteration' num2str(WhichTree)]).AllNodes,2);
        
        %Start the loop that will go through all the pairs and add up the number of
        %steps in between, the community where the nodes belong and if it's the
        %same
        for ReplaceNbrWord = 1:length(AllCombin)
            %Store the number of step next to the pair
            AllCombin(ReplaceNbrWord,3)=D(AllCombin(ReplaceNbrWord,1),AllCombin(ReplaceNbrWord,2));
            %Store the community the nodes belongs
            AllCombin(ReplaceNbrWord,4)=ciu1(AllCombin(ReplaceNbrWord,1));
            AllCombin(ReplaceNbrWord,5)=ciu1(AllCombin(ReplaceNbrWord,2));
            %Check if the communities are the same between the two nodes
            if AllCombin(ReplaceNbrWord,4)==AllCombin(ReplaceNbrWord,5)
                %If same, put a 1
                AllCombin(ReplaceNbrWord,6)=1;
            else
                %If different, put a 0
                AllCombin(ReplaceNbrWord,6)=0;
            end
        end
        
        %Create a summary structure that will store different information of the
        %output selection
        Summary=struct;
        
        %For each distance categories, found the number of pairs in the selection
        %and store it in the structure
        DiffDistances=unique(AllCombin(:,3));
        for WhichDistCat=1:length(DiffDistances)
            Summary.(['NbrDistCat' num2str(WhichDistCat)])=sum(AllCombin(:,3) == WhichDistCat);
        end
        
        %Found all the unique communities in the selection and store it in the
        %structure
        DiffCommu=unique(AllCombin(:,4:5));
        Summary.Commu=DiffCommu;
        
        %Put in the first column the number of nodes for the current tree
        TableSummaryTree(WhichTree,1)=WhichTree;
        %Put in the first column the number of nodes for the current tree
        TableSummaryTree(WhichTree,2)=length(OutputSelectionNodes.(['Iteration' num2str(WhichTree)]).AllNodes);
        %Put in the second column the number of community for the current tree
        TableSummaryTree(WhichTree,3)=length(Summary.Commu);
        
        %Put in a variable the number of distance categories there is for
        %the current tree.
        HowManyCat=length(DiffDistances);
        %go through all the distance categories and put in the right
        %columns the value for the current tree.
        for DistCatTempSummary=1:HowManyCat
            %For distance category 1, store the % of pairs there is in the
            %combinations
            if DistCatTempSummary==1
                TableSummaryTree(WhichTree,4)=Summary.NbrDistCat1/length(AllCombin);
                %For distance category 2, store the % of pairs there is in the
                %combinations
            elseif DistCatTempSummary==2
                TableSummaryTree(WhichTree,5)=Summary.NbrDistCat2/length(AllCombin);
                %For distance category 3, store the % of pairs there is in the
                %combinations
            elseif DistCatTempSummary==3
                TableSummaryTree(WhichTree,6)=Summary.NbrDistCat3/length(AllCombin);
                %For distance category 4, store the % of pairs there is in the
                %combinations
            elseif DistCatTempSummary==4
                TableSummaryTree(WhichTree,7)=Summary.NbrDistCat4/length(AllCombin);
                %For distance category 5 and plus, store the % of pairs there
                %is in the combinations
            elseif DistCatTempSummary>=5
                TempValueCatPerc=zeros(HowManyCat-4,1);
                %Look for all the distance categories 5 and plus (if
                %exists)
                for DistCatAbove=5:HowManyCat
                    TempValueCatPerc(DistCatAbove-4,1)=Summary.(['NbrDistCat' num2str(DistCatAbove)])/length(AllCombin);
                end
                %Then sum all of them in the output variable
                TableSummaryTree(WhichTree,8)=sum(TempValueCatPerc);
            end
        end
        %Put in the last columns, the total number of distance categories
        TableSummaryTree(WhichTree,9)=HowManyCat;
        
    end
    
    %Reduce the output summary table by taking only where the number of
    %nodes is less than 50.
    %TableSummaryTreeLess50=TableSummaryTree(TableSummaryTree(:,2)<50,:);
    %Reduce the output summary table by taking only where there is less
    %than 5 distance categories.
    %TableSummaryTreeLess5Cat=TableSummaryTree(TableSummaryTree(:,8)==0,:);
    
elseif TreeCreation==0 && TreeSummary==1
    error('You need to create trees before')
end


%%%Create an new summary table with the number of nodes per communities
%C1: Index | C2: Number of nodes | C3: Number of communities
%C4-X: Percentage of similar communities per distance categories (i.e. C4
%for distance categorie 1, etc)
%CX+1-Y : Number of communities per distance categories
if TreeCreation==1 && TreeSummary==1 && TreeSummaryCommu==1
    %Create a variable to store the summary of the trees
    TableSummaryTreeCommu=zeros(length(fieldnames(OutputSelectionNodes)),4);
    
    %Go through all the trees created
    for WhichTreeCommu = 1:(length(fieldnames(OutputSelectionNodes)))
        %Create all combination between the output nodes
        AllCombinCommu = nchoosek(OutputSelectionNodes.(['Iteration' num2str(WhichTreeCommu)]).AllNodes,2);
        
        %Start the loop that will go through all the pairs and add up the number of
        %steps in between, the community where the nodes belong and if it's the
        %same
        for ReplaceNbrWord = 1:length(AllCombinCommu)
            %Store the number of step next to the pair
            AllCombinCommu(ReplaceNbrWord,3)=D(AllCombinCommu(ReplaceNbrWord,1),AllCombinCommu(ReplaceNbrWord,2));
            %Store the community the nodes belongs
            AllCombinCommu(ReplaceNbrWord,4)=ciu1(AllCombinCommu(ReplaceNbrWord,1));
            AllCombinCommu(ReplaceNbrWord,5)=ciu1(AllCombinCommu(ReplaceNbrWord,2));
            %Check if the communities are the same between the two nodes
            if AllCombinCommu(ReplaceNbrWord,4)==AllCombinCommu(ReplaceNbrWord,5)
                %If same, put a 1
                AllCombinCommu(ReplaceNbrWord,6)=1;
            else
                %If different, put a 0
                AllCombinCommu(ReplaceNbrWord,6)=0;
            end
        end
        
        %Create a summary structure that will store different information of the
        %output selection
        SummaryCommu=struct;
        
        %For each distance categories, found the number of pairs in the selection
        %and store it in the structure
        DiffDistances=unique(AllCombinCommu(:,3));
        for WhichDistCat=1:length(DiffDistances)
            SummaryCommu.(['NbrDistCat' num2str(WhichDistCat)])=sum(AllCombinCommu(:,3) == WhichDistCat);
        end
        
        %Found all the unique communities in the selection and store it in the
        %structure
        DiffCommu=unique(AllCombinCommu(:,4:5));
        SummaryCommu.Commu=DiffCommu;
        %For each communities, found the number of pairs in selection that are in
        %it, and store it in the structure.
        for CommuCount = 1:length(DiffCommu)
            SummaryCommu.(['NbrCommu' num2str(DiffCommu(CommuCount))])=sum(AllCombinCommu(:,4:5) == DiffCommu(CommuCount));
        end
        %Store in the structure the number pairs that have a similar and different
        %community.
        SummaryCommu.SameOrDiffCommu=[sum(AllCombinCommu(:,6) == 1); sum(AllCombinCommu(:,6) == 0)];
        %For each community, look how many pairs are in the same community
        for CommuCountPerStep = 1:length(DiffDistances)
            SummaryCommu.(['NbrCommuStepEq' num2str(CommuCountPerStep)])=sum(AllCombinCommu(AllCombinCommu(:,3)==CommuCountPerStep,6) == 1);
        end
        
        %Put in the first column the number of nodes for the current tree
        TableSummaryTreeCommu(WhichTreeCommu,1)=WhichTreeCommu;
        %Put in the first column the number of nodes for the current tree
        TableSummaryTreeCommu(WhichTreeCommu,2)=length(OutputSelectionNodes.(['Iteration' num2str(WhichTreeCommu)]).AllNodes);
        %Put in the second column the number of community for the current tree
        TableSummaryTreeCommu(WhichTreeCommu,3)=length(SummaryCommu.Commu);
        %Store in the output variable the % of pairs in the same community 
        %for each distance categories. 
        for CommuTempSummary=1:length(DiffDistances)
            TableSummaryTreeCommu(WhichTreeCommu,3+CommuTempSummary)=SummaryCommu.(['NbrCommuStepEq' num2str(CommuTempSummary)])/SummaryCommu.(['NbrDistCat' num2str(CommuTempSummary)]);
        end
    end
elseif TreeCreation==0 && TreeSummaryCommu==1
    error('You need to create trees before')
elseif TreeSummary==0 && TreeSummaryCommu==1
    error('You need to have a previous summary table')
end

%Reduce the output summary table by taking only where the number of
%nodes is less than 50.
%TableSummaryTreeCommuLess50=TableSummaryTreeCommu(TableSummaryTreeCommu(:,2)<50,:);
%Reduce the output summary table by taking only where there is less
%than 5 distance categories.
%TableSummaryTreeCommuLess5Cat=TableSummaryTreeCommu(TableSummaryTree(:,8)==0,:);

%%
%%%Create a box to enter the different parameters for the creation of the
%%%subset of trees

if isempty(TableSummaryTree)
    return
end

%%%Names ouput display
if OutputLabel==1 && TreeSummary==1
    %Create a variable that contains the summary table corresponding to the
    %criteria (for the general table)
    SubsetSelected=TableSummaryTree(TableSummaryTree(:,4)>=PercMinDistCat & TableSummaryTree(:,2)>=MinNodes & TableSummaryTree(:,2)<=MaxNodes & TableSummaryTree(:,8)<=PercMaxDistCat ,:);
    %Create a variable that contains the summary table corresponding to the
    %criteria (for the community table)
    SubsetSelectedCommu=TableSummaryTreeCommu(TableSummaryTree(:,4)>=PercMinDistCat & TableSummaryTree(:,2)>=MinNodes & TableSummaryTree(:,2)<=MaxNodes & TableSummaryTree(:,8)<=PercMaxDistCat ,:);
    %Create a variable where the different label of the nodes will be
    %stored
    LabelsOutput=cell(MaxNodes,size(SubsetSelected(:,1),1));
    %Check all the different nodes and fetch their label
    for SelectedTree=1:size(SubsetSelected,1)
        WhichIterationInterest=SubsetSelected(SelectedTree);
        LabelsOutput(1:length(OutputSelectionNodes.(['Iteration' num2str(WhichIterationInterest)]).AllNodes),SelectedTree)=Labels_Names(OutputSelectionNodes.(['Iteration' num2str(WhichIterationInterest)]).AllNodes);
    end
elseif TreeSummary==0
    error('You need to create tree summary table')
end




%If selected, save these subset and their tables
if Save==1
    save(['SelectionNodesOutput_Nbr' WhichSelection '.mat'],'OutputGUI','SubsetSelected','SubsetSelectedCommu','LabelsOutput')
end





