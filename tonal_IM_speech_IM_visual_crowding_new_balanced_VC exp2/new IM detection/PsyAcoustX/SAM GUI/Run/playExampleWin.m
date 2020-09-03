function varargout = playExampleWin(varargin)
% PLAYEXAMPLEWIN M-file for playExampleWin.fig
%      PLAYEXAMPLEWIN, by itself, creates a new PLAYEXAMPLEWIN or raises the existing
%      singleton*.
%
%      H = PLAYEXAMPLEWIN returns the handle to a new PLAYEXAMPLEWIN or the handle to
%      the existing singleton*.
%
%      PLAYEXAMPLEWIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYEXAMPLEWIN.M with the given input arguments.
%
%      PLAYEXAMPLEWIN('Property','Value',...) creates a new PLAYEXAMPLEWIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before playExampleWin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to playExampleWin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help playExampleWin

% Last Modified by GUIDE v2.5 27-Jun-2012 12:12:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @playExampleWin_OpeningFcn, ...
                   'gui_OutputFcn',  @playExampleWin_OutputFcn, ...
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


% --- Executes just before playExampleWin is made visible.
function playExampleWin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to playExampleWin (see VARARGIN)

% Choose default command line output for playExampleWin
% Choose default command line output for playExampleWindow
handles.output = hObject;
movegui(hObject,'center')
handles = varargin{1};

%--turn off buttons until experiment starts--
set(findall(0,'tag','obs1_button'),'enable','off');
set(findall(0,'tag','obs2_button'),'enable','off');
set(findall(0,'tag','obs3_button'),'enable','off');
set(findall(0,'tag','playExample_example'),'Visible','off');
set(findall(0,'tag','makeEasier'),'Visible','off');
set(findall(0,'tag','makeHarder'),'Visible','off');
%--------------------------------------------

handles.stimParams=handles.blocks{handles.run.currentBlockNum}; %update stim params to current block

%--turn OFF close and plot buttons while runnign --------
set(findall(0,'tag','plotRespButton_example'),'Visible','off'); %turn on track plotting button
set(findall(0,'tag','closeRespWinButton_example'),'Visible','on'); %turn on close button
%--------------------------------------------------------

%HP masker spectrum level is -50 dB re target
handles=setHPLevel(handles);
handles.stimParams.storeTargetLevel=handles.stimParams.targetLevel;
handles.stimParams.storeMaskerLevel=handles.stimParams.maskerLevel;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = playExampleWin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles;


% --- Executes on button press in obs1button.
function obs1button_Callback(hObject, eventdata, handles)
% hObject    handle to obs1button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in obs2button.
function obs2button_Callback(hObject, eventdata, handles)
% hObject    handle to obs2button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in obs3button.
function obs3button_Callback(hObject, eventdata, handles)
% hObject    handle to obs3button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--loop trials until threshold is found-------------------
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
ISI=handles.run.ISI;
gcf
set(gcf, 'KeyPressFcn', @exit_KeyPressFcn)
set(hObject,'String','press ENTER to stop','Enable','off');
set(findall(0,'tag','closeRespWinButton_example'),'Enable','off');
set(findall(0,'tag','makeEasier'),'Enable','off');
set(findall(0,'tag','makeHarder'),'Enable','off');

while ~KEY_IS_PRESSED
    drawnow;
    doTrial_Example(handles,ISI);
end

set(hObject,'String','START EXAMPLE','Enable','on');
set(findall(0,'tag','closeRespWinButton_example'),'Enable','on');
set(findall(0,'tag','makeEasier'),'Visible','on');
set(findall(0,'tag','makeHarder'),'Visible','on');
set(findall(0,'tag','makeEasier'),'Enable','on');
set(findall(0,'tag','makeHarder'),'Enable','on');
KEY_IS_PRESSED = 0;
%--------------------------------------------------------

% --- Executes on button press in plotRespButton_example.
function plotRespButton_example_Callback(hObject, eventdata, handles)
% hObject    handle to plotRespButton_example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in closeRespWinButton_example.
function closeRespWinButton_example_Callback(hObject, eventdata, handles)
% hObject    handle to closeRespWinButton_example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% -- if the button displays NEXT, run the next condition.
% -- if the buttons displays CLOSE, restart the GUI
close(gcf);
set(findall(0,'tag','responseWindow_FIG'),'Visible','on');

% --- Executes on key press with focus on playExample_FIG or any of its controls.
function playExample_FIG_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to playExample_FIG (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)z

% --- Executes on button press in playExample_example.
function playExample_example_Callback(hObject, eventdata, handles)
% hObject    handle to playExample_example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on obs1button and none of its controls.
function obs1button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to obs1button (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on exit and none of its controls.
function exit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

global KEY_IS_PRESSED
KEY_IS_PRESSED = 1;


% --- Executes on button press in makeEasier.
function makeEasier_Callback(hObject, eventdata, handles)
% hObject    handle to makeEasier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stpsz=10;
if handles.stimParams.trackTarget
    handles.stimParams.targetLevel=handles.stimParams.targetLevel+stpsz;
else
    handles.stimParams.maskerLevel=handles.stimParams.maskerLevel-stpsz;
end

set(hObject,'String','DONE'); pause(.25);
set(hObject,'String','Make Easier');

guidata(hObject,handles);

% --- Executes on button press in makeHarder.
function makeHarder_Callback(hObject, eventdata, handles)
% hObject    handle to makeHarder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stpsz=10;
if handles.stimParams.trackTarget
    handles.stimParams.targetLevel=handles.stimParams.targetLevel-stpsz;
else
    handles.stimParams.maskerLevel=handles.stimParams.maskerLevel+stpsz;
end

set(hObject,'String','DONE'); pause(.25);
set(hObject,'String','Make Harder');
guidata(hObject,handles);