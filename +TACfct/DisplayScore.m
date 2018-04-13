function DisplayScore(TAC_ResList,window)

TACpar.Parameters

% Setup the text type for the final message
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, FontSizeInstruct);

%Calculated the score and create the sentence to be place on the screen
Calc_score=round(sum([TAC_ResList{:,WhereScore}])/NumberItems*100);
Score_text=['Vous avez obtenu un score de ', num2str(Calc_score),'% !'];

%Draw the instructions on the screen
DrawFormattedText(window,Score_text, 'center', 'center',NormalColor);

%Flip to the screen
Screen('Flip', window);

%Wait 0.5 seconds to ensure the slide don't skip.
WaitSecs(0.5);

%Wait for the participant to press a button to continue
KbWait;

%Calculated the score of eureka and create the sentence to be place on the screen
Eureka_WhenCorrect=TAC_ResList([TAC_ResList{:,WhereScore}]==1,WhereEureka);
%Calc_EurekaCorrect_score=;
Calc_EurekaCorrect_score=round(sum(strcmp(Eureka_WhenCorrect,'v'))/size(Eureka_WhenCorrect,1)*100);
Score_EurekaCorrect_text=['Vous aviez ', num2str(Calc_EurekaCorrect_score),'% d''Eureka lorsque vous aviez \n eu la bonne reponse !'];

%Draw the instructions on the screen
DrawFormattedText(window,Score_EurekaCorrect_text, 'center', 'center',NormalColor);

%Flip to the screen
Screen('Flip', window);

%Wait 0.5 seconds to ensure the slide don't skip.
WaitSecs(0.5);

%Wait for the participant to press a button to continue
KbWait;

end