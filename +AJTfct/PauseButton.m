function PauseButton(ScreenOutput)

MP = get(0, 'MonitorPositions');
pos= MP(ScreenOutput,:);
f = warndlg('You need to close the window to continue.','Pause program');
disp('User required break during fixation');
ShowCursor;
drawnow     % Necessary to print the message
set(f, 'Position', [pos(1:2) , pos(3:4)/5]);%+ Shift
waitfor(f);
disp('Continue the task');
HideCursor;

end
