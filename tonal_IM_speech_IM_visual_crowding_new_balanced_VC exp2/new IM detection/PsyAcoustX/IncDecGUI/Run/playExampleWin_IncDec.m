function varargout = playExampleWin_IncDec(varargin)
% PLAYEXAMPLEWIN_INCDEC M-file for playExampleWin_IncDec.fig
%      PLAYEXAMPLEWIN_INCDEC, by itself, creates a new PLAYEXAMPLEWIN_INCDEC or raises the existing
%      singleton*.
%
%      H = PLAYEXAMPLEWIN_INCDEC returns the handle to a new PLAYEXAMPLEWIN_INCDEC or the handle to
%      the existing singleton*.
%
%      PLAYEXAMPLEWIN_INCDEC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYEXAMPLEWIN_INCDEC.M with the given input arguments.
%
%      PLAYEXAMPLEWIN_INCDEC('Property','Value',...) creates a new PLAYEXAMPLEWIN_INCDEC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before playExampleWin_IncDec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to playExampleWin_IncDec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help playExampleWin_IncDec

% Last Modified by GUIDE v2.5 07-Jan-2015 11:05:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @playExampleWin_IncDec_OpeningFcn, ...
                   'gui_OutputFcn',  @playExampleWin_IncDec_OutputFcn, ...
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


% --- Executes just before playExampleWin_IncDec is made visible.
function playExampleWin_IncDec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to playExampleWin_IncDec (see VARARGIN)

% Choose default command line output for playExampleWin_IncDec
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

% adjust the window according to the screen size
set(0,'Units','characters');
monSz=get(0,'ScreenSize');
xcorner=0.05*monSz(3);
xwidth=0.90*monSz(3);
ycorner=0.10*monSz(4);
ywidth=0.80*monSz(4);
newWinPos=[xcorner ycorner xwidth ywidth];

%%% original code for scaling the figure 
% currWinPos=get(findall(0,'tag','responseWindow_FIG'),'Position');
% newWinPos=currWinPos;
% newWinPos(2)=monSz(4)-currWinPos(4);

set(findall(0,'tag','playExample_FIG'),'Position',newWinPos);

handles.stimParams=handles.blocks{handles.run.currentBlockNum}; %update stim params to current block

%--turn OFF close and plot buttons while running --------
set(findall(0,'tag','plotRespButton_example'),'Visible','off'); %turn on track plotting button
set(findall(0,'tag','closeRespWinButton_example'),'Visible','on'); %turn on close button
%--------------------------------------------------------

handles.stimParams.storeIncDec=handles.stimParams.initialIncDec;

% Update handles structure
guidata(hObject, handles);

uiwait(gcf);

% --- Outputs from this function are returned to the command line.
function varargout = playExampleWin_IncDec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.stimParams;
uiresume(gcf);
% The figure can be deleted now
delete(gcf);
set(findall(0,'tag','responseWindow_FIG'),'Visible','on');

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
set(hObject,'String','touch/click HERE to stop','Enable','off');
set(findall(0,'tag','closeRespWinButton_example'),'Enable','off');
set(findall(0,'tag','makeEasier'),'Enable','off');
set(findall(0,'tag','makeHarder'),'Enable','off');
set(findall(0,'tag','exit_ButtonDownFcn'),'Enable','on');

while ~KEY_IS_PRESSED
    drawnow;
    doTrial_IncDec_Example(handles,ISI);
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

set(gcf,'Visible','off');
playExample_FIG_CloseRequestFcn(gcf, eventdata, handles);

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
stpsz=3;

decSz=handles.stimParams.initialIncDec+stpsz;
maxDec=handles.stimParams.markerLevel;

if decSz>maxDec
    set(hObject,'String','MAX REACHED!'); pause(.25);
    set(hObject,'String','Make Easier');
else
    handles.stimParams.initialIncDec=decSz;
    set(hObject,'String','DONE'); pause(.25);
    set(hObject,'String','Make Easier');
end



guidata(hObject,handles);

% --- Executes on button press in makeHarder.
function makeHarder_Callback(hObject, eventdata, handles)
% hObject    handle to makeHarder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stpsz=3;
if handles.stimParams.initialIncDec-stpsz<=0
    set(hObject,'String','MAX REACHED!'); pause(.25);
    handles.stimParams.initialIncDec=0;
else
    handles.stimParams.initialIncDec=handles.stimParams.initialIncDec-stpsz;
end
handles.stimParams.initialIncDec
set(hObject,'String','DONE'); pause(.25);
set(hObject,'String','Make Harder');
guidata(hObject,handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over exit.
function exit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global KEY_IS_PRESSED
KEY_IS_PRESSED = 1;
set(hObject,'Enable','off');


% --- Executes when user attempts to close playExample_FIG.
function playExample_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to playExample_FIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(gcf);
else
    % The GUI is no longer waiting, just close it
    delete(gcf);
end
