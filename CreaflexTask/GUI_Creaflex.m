function varargout = GUI_Creaflex(varargin)
% GUI_CREAFLEX MATLAB code for GUI_Creaflex.fig
%      GUI_CREAFLEX, by itself, creates a new GUI_CREAFLEX or raises the existing
%      singleton*.
%
%      H = GUI_CREAFLEX returns the handle to a new GUI_CREAFLEX or the handle to
%      the existing singleton*.
%
%      GUI_CREAFLEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CREAFLEX.M with the given input arguments.
%
%      GUI_CREAFLEX('Property','Value',...) creates a new GUI_CREAFLEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Creaflex_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Creaflex_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Creaflex

% Last Modified by GUIDE v2.5 30-May-2018 15:34:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Creaflex_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Creaflex_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_Creaflex is made visible.
function GUI_Creaflex_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Creaflex (see VARARGIN)

% Choose default command line output for GUI_Creaflex
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Creaflex wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Creaflex_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OutputGUI=struct;

OutputGUI.ParticipantNumber=get(handles.edit1, 'String');
OutputGUI.Initials=get(handles.edit2, 'String');

handles.OutputData=OutputGUI;

save('TempOutputGUI.mat','OutputGUI')

evalin('base', 'MainTaskFct.FGAT_Main')



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputGUI=struct;

OutputGUI.ParticipantNumber=get(handles.edit1, 'String');
OutputGUI.Initials=get(handles.edit2, 'String');

handles.OutputData=OutputGUI;

save('TempOutputGUI.mat','OutputGUI')

evalin('base', 'MainTaskFct.TAC_Main')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OutputGUI=struct;

OutputGUI.ParticipantNumber=get(handles.edit1, 'String');
OutputGUI.Initials=get(handles.edit2, 'String');

handles.OutputData=OutputGUI;

save('TempOutputGUI.mat','OutputGUI')

evalin('base', 'MainTaskFct.Stroop_Main')





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputGUI=struct;

OutputGUI.ParticipantNumber=get(handles.edit1, 'String');
OutputGUI.Initials=get(handles.edit2, 'String');

handles.OutputData=OutputGUI;

save('TempOutputGUI.mat','OutputGUI')

evalin('base', 'MainTaskFct.Similarity_Main')




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputGUI=struct;

OutputGUI.ParticipantNumber=get(handles.edit1, 'String');
OutputGUI.Initials=get(handles.edit2, 'String');

handles.OutputData=OutputGUI;

save('TempOutputGUI.mat','OutputGUI')

evalin('base', 'MainTaskFct.PPTT_Main')




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputGUI=struct;

OutputGUI.ParticipantNumber=get(handles.edit1, 'String');
OutputGUI.Initials=get(handles.edit2, 'String');

handles.OutputData=OutputGUI;

save('TempOutputGUI.mat','OutputGUI')

evalin('base', 'MainTaskFct.Naming_Main')


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
