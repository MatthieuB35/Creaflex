function varargout = GUI_SelectionNode(varargin)
% GUI_SELECTIONNODE MATLAB code for GUI_SelectionNode.fig
%      GUI_SELECTIONNODE, by itself, creates a new GUI_SELECTIONNODE or raises the existing
%      singleton*.
%
%      H = GUI_SELECTIONNODE returns the handle to a new GUI_SELECTIONNODE or the handle to
%      the existing singleton*.
%
%      GUI_SELECTIONNODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SELECTIONNODE.M with the given input arguments.
%
%      GUI_SELECTIONNODE('Property','Value',...) creates a new GUI_SELECTIONNODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SelectionNode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SelectionNode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SelectionNode

% Last Modified by GUIDE v2.5 29-Mar-2018 15:49:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_SelectionNode_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_SelectionNode_OutputFcn, ...
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


% --- Executes just before GUI_SelectionNode is made visible.
function GUI_SelectionNode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SelectionNode (see VARARGIN)

% Choose default command line output for GUI_SelectionNode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SelectionNode wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SelectionNode_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OutputGUI=struct;

%Loading
OutputGUI.LoadData=get(handles.radiobutton10, 'Value');

%WhichSelection
OutputGUI.WhichSelection=get(handles.edit5, 'String');

%Creation Index
OutputGUI.DoCreationIndex=get(handles.checkbox1, 'Value');
OutputGUI.NumberNodes=str2double(get(handles.edit1, 'String'));
OutputGUI.DistCat=str2num(get(handles.edit3, 'String'));
OutputGUI.NbrNodesSelect=str2double(get(handles.text7, 'String'));
OutputGUI.MinFreq=str2double(get(handles.text8, 'String'));
OutputGUI.MaxSyl=str2double(get(handles.text11, 'String'));
OutputGUI.OnlyNouns=get(handles.radiobutton1, 'Value');
OutputGUI.Articles=get(handles.radiobutton3, 'Value');
OutputGUI.WordsOtherTask=get(handles.radiobutton8, 'Value');
if get(handles.radiobutton5, 'Value')==1
    TempAmbiguous=0;
elseif get(handles.radiobutton7, 'Value')==1
    TempAmbiguous=0.5;
elseif get(handles.radiobutton6, 'Value')==1
    TempAmbiguous=1;
end
OutputGUI.Ambiguous=TempAmbiguous;

%Creation Trees
OutputGUI.DoCreationTree=get(handles.checkbox2, 'Value');
OutputGUI.KeepOrigin=get(handles.radiobutton12, 'Value');
OutputGUI.CreateSummaryTable=get(handles.radiobutton14, 'Value');
OutputGUI.CreateCommuTable=get(handles.radiobutton19, 'Value');

%Selection Trees
OutputGUI.DoSelectionTree=get(handles.checkbox2, 'Value');
OutputGUI.MinStep1=str2double(get(handles.text12, 'String'))/100;
OutputGUI.MaxStep5=str2double(get(handles.text14, 'String'))/100;
OutputGUI.MinNbrNodes=str2double(get(handles.text16, 'String'));
OutputGUI.MaxNbrNodes=str2double(get(handles.text18, 'String'));
OutputGUI.SaveSelection=get(handles.radiobutton24, 'Value');

%Put structure in output GUI
handles.OutputData=OutputGUI;

% Get default command line output from handles structure
varargout{1} = handles.OutputData;



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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
if get(hObject,'Value') ==1
    
    set(handles.slider2, 'Enable', 'on');
    set(handles.slider4, 'Enable', 'on');
    
    
    set(handles.text4, 'Enable', 'on');
    set(handles.text2, 'Enable', 'on');
    set(handles.text9, 'Enable', 'on');
    set(handles.text8, 'Enable', 'on');
    set(handles.text10, 'Enable', 'on');
    set(handles.text11, 'Enable', 'on');
    
    set(handles.edit1, 'Enable', 'on');
    set(handles.edit3, 'Enable', 'on');
    
    set(handles.radiobutton1, 'Enable', 'on');
    set(handles.radiobutton2, 'Enable', 'on');
    set(handles.radiobutton3, 'Enable', 'on');
    set(handles.radiobutton4, 'Enable', 'on');
    set(handles.radiobutton5, 'Enable', 'on');
    set(handles.radiobutton6, 'Enable', 'on');
    set(handles.radiobutton7, 'Enable', 'on');
    set(handles.radiobutton8, 'Enable', 'on');
    set(handles.radiobutton9, 'Enable', 'on');
    
else
    set(handles.slider2, 'Enable', 'off');
    set(handles.slider4, 'Enable', 'off');
    
    set(handles.text4, 'Enable', 'off');
    set(handles.text2, 'Enable', 'off');
    set(handles.text9, 'Enable', 'off');
    set(handles.text8, 'Enable', 'off');
    set(handles.text10, 'Enable', 'off');
    set(handles.text11, 'Enable', 'off');
    
    set(handles.edit1, 'Enable', 'off');
    set(handles.edit3, 'Enable', 'off');
    
    set(handles.radiobutton1, 'Enable', 'off');
    set(handles.radiobutton2, 'Enable', 'off');
    set(handles.radiobutton3, 'Enable', 'off');
    set(handles.radiobutton4, 'Enable', 'off');
    set(handles.radiobutton5, 'Enable', 'off');
    set(handles.radiobutton6, 'Enable', 'off');
    set(handles.radiobutton7, 'Enable', 'off');
    set(handles.radiobutton8, 'Enable', 'off');
    set(handles.radiobutton9, 'Enable', 'off');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Output= round(get(hObject,'value'));

set(handles.text7, 'String', num2str(Output));
%Change min & value slider selection tree
set(handles.slider7, 'Min', Output);
set(handles.slider7, 'value', Output);
set(handles.text16, 'String', num2str(Output));
set(handles.slider8, 'Min', Output);
set(handles.slider8, 'value', Output);
set(handles.text18, 'String', num2str(Output));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Output= get(hObject,'value');

set(handles.text8, 'String', num2str(round(Output)));


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Output= get(hObject,'value');

set(handles.text11, 'String', num2str(round(Output)));

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
if get(hObject,'Value') ==1
    set(handles.slider5, 'Enable', 'on');
    set(handles.slider6, 'Enable', 'on');
    set(handles.slider7, 'Enable', 'on');
    set(handles.slider8, 'Enable', 'on');
    
    set(handles.text12, 'Enable', 'on');
    set(handles.text13, 'Enable', 'on');
    set(handles.text14, 'Enable', 'on');
    set(handles.text15, 'Enable', 'on');
    set(handles.text16, 'Enable', 'on');
    set(handles.text17, 'Enable', 'on');
    set(handles.text18, 'Enable', 'on');
    set(handles.text19, 'Enable', 'on');
    
    set(handles.radiobutton24, 'Enable', 'on');
    set(handles.radiobutton25, 'Enable', 'on');
    
    
else
    set(handles.slider5, 'Enable', 'off');
    set(handles.slider6, 'Enable', 'off');
    set(handles.slider7, 'Enable', 'off');
    set(handles.slider8, 'Enable', 'off');
    
    set(handles.text12, 'Enable', 'off');
    set(handles.text13, 'Enable', 'off');
    set(handles.text14, 'Enable', 'off');
    set(handles.text15, 'Enable', 'off');
    set(handles.text16, 'Enable', 'off');
    set(handles.text17, 'Enable', 'off');
    set(handles.text18, 'Enable', 'off');
    set(handles.text19, 'Enable', 'off');
    
    set(handles.radiobutton24, 'Enable', 'off');
    set(handles.radiobutton25, 'Enable', 'off');
    
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Output= get(hObject,'value');

set(handles.text12, 'String', num2str(round(Output)));

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Output= get(hObject,'value');

set(handles.text14, 'String', num2str(round(Output)));

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Output= get(hObject,'value');

set(handles.text16, 'String', num2str(round(Output)));

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Output= get(hObject,'value');

set(handles.text18, 'String', num2str(round(Output)));

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if get(hObject,'Value') ==1
    
    set(handles.text6, 'Enable', 'on');
    set(handles.slider1, 'Enable', 'on');
    set(handles.text7, 'Enable', 'on');
    
    set(handles.radiobutton12, 'Enable', 'on');
    set(handles.radiobutton13, 'Enable', 'on');
    set(handles.radiobutton14, 'Enable', 'on');
    set(handles.radiobutton15, 'Enable', 'on');
    set(handles.radiobutton18, 'Enable', 'on');
    set(handles.radiobutton19, 'Enable', 'on');
    
else
    
    set(handles.slider1, 'Enable', 'off');
    set(handles.text7, 'Enable', 'off');
    set(handles.text6, 'Enable', 'off');
    
    set(handles.radiobutton12, 'Enable', 'off');
    set(handles.radiobutton13, 'Enable', 'off');
    set(handles.radiobutton14, 'Enable', 'off');
    set(handles.radiobutton15, 'Enable', 'off');
    set(handles.radiobutton18, 'Enable', 'off');
    set(handles.radiobutton19, 'Enable', 'off');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'This option will only delete ambiguous words if their maximum lexical frequency does not refer to the current word.', 'For example, take a word where its article show that it is a noun (e.g. le rire). Therefore, if the maximum lexical frequency is not for the noun, the ambiguous word (e.g. rire) will be deleted.', 'In the case where the word does not have an article, either you are interest only by nouns and it will search for lexical frequency maximal for nouns. Or it will not delete the word if there is no specification.'})
