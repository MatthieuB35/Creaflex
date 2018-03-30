function Break(window,ColorText)

%When the counter reach the threshold pause the task
%Display a text on the screen
PauseText='Vous pouvez maintenant prendre une pause. \n Appuyez sur la barre "Espace" pour continuer le test.';

%Ask the question to the participant if he gets a sudden response
DrawFormattedText(window, PauseText, 'center', 'center',ColorText);

%Flip to the screen
Screen('Flip', window);

%Wait for 1 seconds
WaitSecs(1)

%Wait for input of the participant
KbWait

end