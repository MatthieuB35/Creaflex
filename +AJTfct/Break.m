function Break(window,ColorText,HowLongWaitSec)

%When the counter reach the threshold pause the task
%Display a text on the screen
TranfoMin=HowLongWaitSec/60;
PauseText=['Vous allez maintenant prendre une pause. Vous pourrez \n reprendre la tâche dans ' num2str(TranfoMin) ' minute.'];

%Ask the question to the participant if he gets a sudden response
DrawFormattedText(window, PauseText, 'center', 'center',ColorText);

%Flip to the screen
Screen('Flip', window);

%Wait for 1 seconds
WaitSecs(HowLongWaitSec);

PauseText2='Appuyez sur la barre "Espace" quand vous souhaitez continuer le test.';

%Ask the question to the participant if he gets a sudden response
DrawFormattedText(window, PauseText2, 'center', 'center',ColorText);

%Flip to the screen
Screen('Flip', window);

%Wait for 0.2 seconds
WaitSecs(0.2);

%Wait for input of the participant
KbWait;

end