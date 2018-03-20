%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     CONSECUTIVE PAIRED FUNCTION
% Version: 1
% Last Edited: 13/10/2017
% Author: Matthieu Bernard
% Description; Take a matrix n*2 and heck if there is no consecutive
% number.
%
% Requires: - a matrix n*2
%           - the number of attempts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Start the function ConsecutivePaired
function CheckMatrix=ConsecutivePaired(GivenMatrix,attemps)
%The input attemps is the number of attempts that the function makes.
%After the first attempt fails and if at>1 it will do a permutation of
%the rows of the data and try again, it will do permutations until all the
%data restrictions are satisfied or number attemps = at

%Create a variable with the number total of items.
SizeMatrix=numel(GivenMatrix(:,1));

for WhichAttemps=1:attemps
    [CheckMatrix, code]=consecpairfind(GivenMatrix,SizeMatrix);
    if (code==1)
        break
    else
        GivenMatrix=GivenMatrix(randperm(SizeMatrix),:); %randomize the rows
    end
end

%Start the function that will check.
    function [CheckMatrix, code]=consecpairfind(GivenMatrix,SizeMatrix)
        
        %Set up the line with pair that will be compared
        WhichLine=0;
        
        %Set up the output matrix with NaN values that will be filled up
        %during the loop.
        CheckMatrix=NaN(length(GivenMatrix),2);
        
        %Start the loop that will go through all the different pairs
        for WhichPair=1:SizeMatrix
            
            %For the specific pair,place the 
            CheckMatrix(WhichPair,:)=GivenMatrix(1+WhichLine,:);
            
            GivenMatrix(1+WhichLine,:)=[];
            
            %Set up the line with pair that will be compared with the
            %current pair
            WhichLine=0;
            
            %Detect if there is two time the same number, either in the 
            %same columns, or in the opposite columns between the line of 
            %reference and the next one.
            while((isempty(GivenMatrix)) || ((CheckMatrix(WhichPair,1)==GivenMatrix(1+WhichLine,1))||(CheckMatrix(WhichPair,2)==GivenMatrix(1+WhichLine,2)) ||(CheckMatrix(WhichPair,1)==GivenMatrix(1+WhichLine,2))|(CheckMatrix(WhichPair,2)==GivenMatrix(1+WhichLine,1))))
                
                %Choose the next pair to be compared with the current pair.
                WhichLine=WhichLine+1;
                
                %Check if the line is above the maximum number of lines in
                %the GivenMatrix or if the number of items in the
                %GivenMatrix is inferior to 2. (i.e., no more element to
                %compared)
                if ((WhichLine>=(numel(GivenMatrix(:,1))-1)) || (numel(GivenMatrix(:,1))<2))
                    %Check if the array is empty
                    if (isempty(GivenMatrix))
                        code=1;
                    else
                        code=0;
                    end
                    %Return and go to the next iteration of the for loop
                    return
                end
            end
        end
    end

end