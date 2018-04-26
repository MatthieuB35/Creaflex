function [ch, when]=WaitForInputKeyboard(getExtendedData, getRawCode,HowLong,t0)


%[timedout, Draw, TempCharacter] (HowLong,t0)
global OSX_JAVA_GETCHAR;

% If no command line argument was passed we'll assume that the user only
% wants to get character data and timing/modifier data.
if nargin == 0
    getExtendedData = 1;
    getRawCode = 0;
elseif nargin == 1
    getRawCode = 0;
end

% Is this Matlab? Is the JVM running? Isn't this Windows Vista or later?
if psychusejava('desktop') && ~IsWinVista
    % Java virtual machine and AWT and Desktop are running. Use our Java based
    % GetChar.

    % Make sure that the GetCharJava class is loaded and registered with
    % the java focus manager.
    if isempty(OSX_JAVA_GETCHAR)
        try
            OSX_JAVA_GETCHAR = AssignGetCharJava;
        catch %#ok<*CTCH>
            error('Could not load Java class GetCharJava! Read ''help PsychJavaTrouble'' for help.');
        end
        OSX_JAVA_GETCHAR.register;
    end

    % Make sure the Matlab window has keyboard focus:
    if exist('commandwindow') %#ok<EXIST>
        % Call builtin implementation:
        commandwindow;
    end

    %t0Fct=GetSecs;
    %CurrentTime=t0Fct-t0;
    
    % Loop until we receive character input.
    keepChecking = 1;
    while keepChecking
        % Check to see if a character is available, and stop looking if
        % we've found one.
        TimeStamp=GetSecs;
        charValue = OSX_JAVA_GETCHAR.getChar;
        keepChecking = charValue == 0;
        CurrentTime=TimeStamp-t0;
        if keepChecking
            drawnow;
        end
        if CurrentTime>=HowLong
            ch=13;
            return
        end
    end

    % Throw an error if we've exceeded the buffer size.
    if charValue == -1
        % Reenable keystroke dispatching to Matlab to leave us with a
        % functional Matlab console.
        OSX_JAVA_GETCHAR.setRedispatchFlag(0);
        error('GetChar buffer overflow. Use "FlushEvents" to clear error');
    end

    % Get the typed character.
    if getRawCode
        ch = charValue;
    else
        ch = char(charValue);
    end

    % Only fill up the 'when' data stucture if extended data was requested.
    if getExtendedData
        when.address=nan;
        when.mouseButton=nan;
        when.alphaLock=nan;
        modifiers = OSX_JAVA_GETCHAR.getModifiers;
        when.commandKey = modifiers(1);
        when.controlKey = modifiers(2);
        when.optionKey = modifiers(3);
        when.shiftKey = modifiers(4);
        rawEventTimeMs = OSX_JAVA_GETCHAR.getEventTime;  % result is in units of ms.
        when.ticks = nan;
        when.secs = JavaTimeToGetSecs(rawEventTimeMs, -1);
    else
        when = [];
    end

    return;
end

% Running either on Octave, or on Matlab in No JVM mode or on MS-Vista+:

% If we are on Linux and the keyboard queue is already in use by usercode,
% we can fall back to 'GetMouseHelper' low-level terminal tty magic. The
% only downside is that typed characters will spill into the console, ie.,
% ListenChar(2) suppression is unsupported:
if IsLinux && KbQueueReserve(3, 2, [])
    % Loop until we receive character input.
    keepChecking = 1;
    while keepChecking
        % Check to see if a character is available, and stop looking if
        % we've found one.
        
        % KeyboardHelper with command code 15 delivers
        % id of currently pending characters on stdin:
        charValue = PsychHID('KeyboardHelper', -15);
        keepChecking = charValue == 0;
        if keepChecking
            drawnow;
            if exist('fflush') %#ok<EXIST>
                builtin('fflush', 1);
            end
        end
    end
    
    % Throw an error if we've exceeded the buffer size.
    if charValue == -1
        % Reenable keystroke display to leave us with a
        % functional console.
        PsychHID('KeyboardHelper', -11);
        error('GetChar buffer overflow. Use "FlushEvents" to clear error');
    end

    % No extended data in this mode:
    when = [];
else
    % Use keyboard queue:
    
    % Only need to reserve/create/start queue if we don't have it
    % already:
    if ~KbQueueReserve(3, 1, [])
        % LoadPsychHID is needed on MS-Windows. It no-ops if called redundantly:
        LoadPsychHID;
        
        % Try to reserve default keyboard queue for our exclusive use:
        if ~KbQueueReserve(1, 1, [])
            % Ok, we have to abort here. While the same issue is only worth
            % a warning for CharAvail and FlushEvents, it is game over for
            % GetChar, as we must not touch a user managed kbqueue, and we
            % can't provide any sensible behaviour if we can't do that:
            error('Keyboard queue for default keyboard device already in use by KbQueue/KbEvent functions et al. Use of ListenChar/GetChar etc. and keyboard queues is mutually exclusive!');
        end
        
        % Got it. Allocate and start it:
        PsychHID('KbQueueCreate');
        PsychHID('KbQueueStart');

        if (IsOSX(1) || (IsOctave && IsGUI))
            % Enable keystroke redirection via kbyqueue and pty to bypass
            % blockade of onscreen windows:
            PsychHID('KeyboardHelper', -14);
        end        
    end
    
    % Queue is running: Poll it for new events we're interested in:
    % Loop until we receive character input.
    keepChecking = 1;
    while keepChecking
        % Check to see if a character is available, and stop looking if
        % we've found one.        
        event = PsychHID('KbQueueGetEvent', [], 0.1);
        if ~isempty(event) && event.Pressed && (event.CookedKey > 0)
            charValue = event.CookedKey;
            keepChecking = 0;
        else
            charValue = 0;
            keepChecking = 1;
        end
        
        if keepChecking
            drawnow;
            if exist('fflush') %#ok<EXIST>
                builtin('fflush', 1);
            end
        end
    end
    
    % Only fill up the 'when' data stucture if extended data was requested.
    if getExtendedData
        when.address=nan;
        when.mouseButton=nan;
        when.alphaLock=nan;
        modifiers = [nan, nan, nan, nan];
        when.commandKey = modifiers(1);
        when.controlKey = modifiers(2);
        when.optionKey = modifiers(3);
        when.shiftKey = modifiers(4);
        when.ticks = nan;
        when.secs = event.Time;
    else
        when = [];
    end
end

% Get the typed character.
if getRawCode
    ch = charValue;
else
    ch = char(charValue);
end


end