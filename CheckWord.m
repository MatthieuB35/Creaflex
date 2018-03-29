function [TempWord,Index,IndexOfInterest,ToBeDeleteCurrent,SimilarWordDelete]=CheckWord(WordItem,DictionnaryIndex,DictionnaryFreq,DictionnaryFreqType,Labels_Names,OnlyNoun,NodesArticles,AmbiguousRemove,Articles)

%Create a temp variable with the label of the current node/word
if nargin == 8 || isempty(Articles)
    TempWord=strtrim(Labels_Names(WordItem));
    NoArticles=1;
elseif nargin == 9
    TempWord=erase(Labels_Names(WordItem),Articles);
    NoArticles=0;
else
    error('You need to specify all the arguments')
end

%Found the row for the node and it's index
MatchingWords = ismember(DictionnaryIndex,TempWord);
Index=find(MatchingWords); %Return all the index in the dictionnary for this word

%Create output variables as empty.
IndexOfInterest=[];
ToBeDeleteCurrent=[];
SimilarWordDelete=[];

%%
if OnlyNoun==0 %KeepAll
    if NodesArticles==1 %KeepArticle
        if AmbiguousRemove==0 %KeepAmbiguous
            if NoArticles==0 %If current word with article
                if strcmp(Articles,'(vb),')==0 %If the current word is a noun
                    TypeWord= ismember(DictionnaryFreqType(Index),'NOM');
                    IndexOfInterest=find(TypeWord);
                else %If the current word is a noun
                    TypeWord= ismember(DictionnaryFreqType(Index),'VER');
                    IndexOfInterest=find(TypeWord);
                end
            else %If the current word is a noun
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
            end
        elseif AmbiguousRemove==0.5 %KeepSomeAmbiguous
            if NoArticles==0 %If current word with article
                if strcmp(Articles,'(vb),')==0 %If the current word is a noun
                    [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                    if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0 % If the max freq is not a noun
                        SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                        %If the max is not a noun, take the freq of the
                        %noun if the article of the word is correct
                        TypeWord= ismember(DictionnaryFreqType(Index),'NOM');
                        IndexOfInterest=find(TypeWord);
                    end
                else %If the current word is a noun
                    [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                    if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'VER')==0 % If the max freq is not a verb
                        SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                        %If the max is not a verb, take the freq of the
                        %verb if the 'article' of the word is correct (at
                        %the end)
                        TypeWord= ismember(DictionnaryFreqType(Index),'VER');
                        IndexOfInterest=find(TypeWord);
                    end
                end
            else %If the current word is a noun
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
            end
        else %NoAmbiguous
            if NoArticles==0 %If current word with article
                SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                if strcmp(Articles,'(vb),')==0 %If the current word is a noun
                    TypeWord= ismember(DictionnaryFreqType(Index),'NOM');
                    IndexOfInterest=find(TypeWord);
                else %If the current word is a noun
                    TypeWord= ismember(DictionnaryFreqType(Index),'VER');
                    IndexOfInterest=find(TypeWord);
                end
            else %If current word don't have an article
                if length(Index)~=1 %If there is more than 1 freq type
                    ToBeDeleteCurrent=1; %Delete current word
                else
                    [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                end
            end
        end
    else %NoArticle
        if AmbiguousRemove==0 %KeepAmbiguous
            if NoArticles==0 %If current word with article
                ToBeDeleteCurrent=1; %Delete current word
            else
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
            end
        elseif AmbiguousRemove==0.5 %KeepSomeAmbiguous
            if NoArticles==0 %If current word with article
                ToBeDeleteCurrent=1; %Delete current word
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                if strcmp(Articles,'(vb),')==0 %If the current word is a noun
                    if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0 %If the max freq is not a noun
                        SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                    end
                else %If the current word is a verb
                    if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'VER')==0 %If the max freq is not a verb
                        SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                    end
                end
            else %If current word don't have an article
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
            end
        else %NoAmbiguous
            if NoArticles==0 %If current word with article
                ToBeDeleteCurrent=1; %Delete current word
                SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
            else %If current word don't have an article
                if length(Index)~=1 %If there is more than 1 freq type
                    ToBeDeleteCurrent=1; %Delete current word
                else
                    [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                end
            end
        end
    end
else %OnlyNouns
    if NodesArticles==1 %KeepArticle
        if AmbiguousRemove==0 %KeepAmbiguous
            IndexOfInterest=find(ismember(DictionnaryFreqType(Index),'NOM'));
        elseif AmbiguousRemove==0.5 %KeepSomeAmbiguous
            if NoArticles==0 %If current word with article
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0   %If the max freq is not a noun
                    SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                end
            else %If current word don't have an article
                %IndexOfInterest=find(ismember(DictionnaryFreqType(Index),'NOM'));
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0 %If the max freq is not a noun
                    ToBeDeleteCurrent=1; %Delete current word
                end
            end
        else%NoAmbiguous
            if NoArticles==0 %If current word with article
                SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                IndexOfInterest=find(ismember(DictionnaryFreqType(Index),'NOM'));
            else %If current word don't have an article
                %IndexOfInterest=find(ismember(DictionnaryFreqType(Index),'NOM'));
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                if length(Index)~=1 %If there is more than 1 freq type
                    ToBeDeleteCurrent=1; %Delete current word
                elseif strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0 %If the max freq is not a noun
                    ToBeDeleteCurrent=1; %Delete current word
                end
            end
        end
    else %NoArticle
        if AmbiguousRemove==0 %KeepAmbiguous
            if NoArticles==0 %If current word with article
                ToBeDeleteCurrent=1; %Delete current word
            else
                IndexOfInterest=find(ismember(DictionnaryFreqType(Index),'NOM'));
            end
        elseif AmbiguousRemove==0.5 %KeepSomeAmbiguous
            if NoArticles==0 %If current word with article
                ToBeDeleteCurrent=1; %Delete current word
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0 %If the max freq is not a noun
                    SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
                end
            else %If current word don't have an article
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                if strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0 %If the max freq is not a noun
                    ToBeDeleteCurrent=1; %Delete current word
                end
            end
        else %NoAmbiguous
            if NoArticles==0 %If current word with article
                ToBeDeleteCurrent=1; %Delete current word
                SimilarWordDelete=find(ismember(Labels_Names,TempWord)); %Delete any word similar
            else %If current word don't have an article
                [~,IndexOfInterest]=max(mean(table2array(DictionnaryFreq(Index,4:7)),2));
                if length(Index)~=1 %If there is more than 1 freq type
                    ToBeDeleteCurrent=1; %Delete current word
                elseif strcmp(DictionnaryFreqType(Index(IndexOfInterest)),'NOM')==0 %If the max freq is not a noun
                    ToBeDeleteCurrent=1; %Delete current word
                end
            end
        end
    end
end

