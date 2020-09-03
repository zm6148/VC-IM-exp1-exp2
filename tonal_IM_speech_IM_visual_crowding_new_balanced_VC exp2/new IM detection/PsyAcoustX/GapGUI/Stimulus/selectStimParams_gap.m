function varargout = selectStimParams_gap(varargin)
%SELECTSTIMPARAMS_GAP M-file for selectStimParams_gap.fig
%      SELECTSTIMPARAMS_GAP, by itself, creates a new SELECTSTIMPARAMS_GAP or raises the existing
%      singleton*.
%
%      H = SELECTSTIMPARAMS_GAP returns the handle to a new SELECTSTIMPARAMS_GAP or the handle to
%      the existing singleton*.
%
%      SELECTSTIMPARAMS_GAP('Property','Value',...) creates a new SELECTSTIMPARAMS_GAP using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to selectStimParams_gap_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SELECTSTIMPARAMS_GAP('CALLBACK') and SELECTSTIMPARAMS_GAP('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SELECTSTIMPARAMS_GAP.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectStimParams_gap

% Last Modified by GUIDE v2.5 28-Jul-2015 10:59:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @selectStimParams_gap_OpeningFcn, ...
    'gui_OutputFcn',  @selectStimParams_gap_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before selectStimParams_gap is made visible.
function selectStimParams_gap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for selectStimParams_mod
handles.output = 'continue';
handles.stimParams = varargin{1};
handles.blocks = varargin{2};
set(handles.bnoiseDurEdit,'Enable','off');
set(handles.bnoiseRampEdit,'Enable','off');
initialize_params_gap(handles);

% disable features not fully tested
set(handles.TrackOffsetYN,'Visible','Off');

if isfield(handles.stimParams,'RunExpt')
    if handles.stimParams.RunExpt.YN
        handles.blocks=[]; % reinitialized handles.blocks
        handles.stimParams.blockNum=0; % reinitialize block number
        loadParams_Callback(handles.loadParams, eventdata, handles);  % load the next condition
        h_runGUI=findall(0,'tag','runGUI');
        hCBrunGUI=get(h_runGUI,'Callback');
        feval(hCBrunGUI,h_runGUI,handles); % reopen the response window
    else
    end
else
    handles.stimParams.RunExpt.YN=0;
    initialize_params_gap(handles); %intialize/update parameters in window
    movegui(hObject,'center');
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes selectStimParams_mod wait for user response (see UIRESUME)
    uiwait(handles.selectStimParams_FIG);
end


% --- Outputs from this function are returned to the command line.
function varargout = selectStimParams_gap_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.stimParams; %last set of stimulus parameters
varargout{3} = handles.blocks;     %stored stimulus parameters for all blocks
delete(handles.selectStimParams_FIG);


% --- Executes on button press in confirmParams_button.
function confirmParams_button_Callback(hObject, eventdata, handles)

if isempty(handles.blocks) % if the user has not saved a block, initialize the first block to the current parameters
    handles.stimParams.bnoiseBW=gapCalcBW(handles.stimParams.bnoiseCutoffs);
    handles.stimParams.bnoiseLevel=...
        handles.stimParams.markerLevel+handles.stimParams.bnoiseOffset+10*log10(handles.stimParams.bnoiseBW); % in spectrum level
    handles.blocks{1}=handles.stimParams;
else
end

guidata(hObject, handles);
uiresume;


% --- Executes on button press in preToggle.
function preToggle_Callback(hObject, eventdata, handles)

prePanelYN=get(hObject,'Value');

if prePanelYN
    set(handles.precursorMainPanel,'visible','on');
else
    set(handles.precursorMainPanel,'visible','off');
end
handles.stimParams.precursorToggle=prePanelYN;
guidata(hObject,handles);

% --- Executes on button press in bnoiseToggle.
function bnoiseToggle_Callback(hObject, eventdata, handles)

bnoisePanelYN=get(hObject,'Value');

if bnoisePanelYN
    set(handles.bnoiseMainPanel,'visible','on');
else
    set(handles.bnoiseMainPanel,'visible','off');
end
handles.stimParams.bnoiseToggle=bnoisePanelYN;
guidata(hObject,handles);

function blockEdit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function blockEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in storeBlock.
function storeBlock_Callback(hObject, eventdata, handles)
[exitYN,exitMsg]=check_params_gap(handles);
if exitYN
    uiwait(msgbox(exitMsg));
    return;
else
end
handles.stimParams.bnoiseBW=gapCalcBW(handles.stimParams.bnoiseCutoffs);
handles.stimParams.bnoiseLevel=...
    handles.stimParams.markerLevel+handles.stimParams.bnoiseOffset+10*log10(handles.stimParams.bnoiseBW); % in spectrum level
handles.stimParams.blockNum=handles.stimParams.blockNum+1;
handles.blocks{handles.stimParams.blockNum}=handles.stimParams; %store all stim params in each block
set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));
handles.stimParams=handles.blocks{handles.stimParams.blockNum}; %visible stim params are current block
initialize_params_gap(handles); %update window
guidata(hObject, handles);
handles.stimParams
handles.blocks

% --- Executes on button press in removeBlock.
function removeBlock_Callback(hObject, eventdata, handles)
if handles.stimParams.blockNum > 1
    handles.blocks(handles.stimParams.blockNum)=[]; %delete all stim params in block (unless only 1 left)
else
end

handles.stimParams.blockNum=handles.stimParams.blockNum-1;

if handles.stimParams.blockNum <1
    handles.stimParams.blockNum=0;
else
end

set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));

handles.stimParams=handles.blocks{handles.stimParams.blockNum}; %visible stim params are current block
initialize_params_gap(handles); %update window
guidata(hObject, handles);

function markerDurEdit_Callback(hObject, eventdata, handles)
handles.stimParams.dur=str2num(get(hObject,'String'))/1000;
handles.stimParams.bnoiseDur=handles.stimParams.dur;
set(handles.bnoiseDurEdit,'String',get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function markerDurEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function markerLevelEdit_Callback(hObject, eventdata, handles)
handles.stimParams.markerLevel=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function markerLevelEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function markerRampEdit_Callback(hObject, eventdata, handles)
handles.stimParams.ramp=str2num(get(hObject,'String'))/1000;
handles.stimParams.bnoiseRamp=handles.stimParams.ramp;
set(handles.bnoiseRampEdit,'String',get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function markerRampEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f1MarkerEdit_Callback(hObject, eventdata, handles)
handles.stimParams.markerCutoffs(1)=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f1MarkerEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f2MarkerEdit_Callback(hObject, eventdata, handles)
handles.stimParams.markerCutoffs(2)=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f2MarkerEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f3MarkerEdit_Callback(hObject, eventdata, handles)
if length(handles.stimParams.markerCutoffs)>2
    tempf3=str2num(get(hObject,'String'));
    if isempty(tempf3)
        tempf3=0;
    else
    end
    handles.stimParams.markerCutoffs(3)=tempf3;
    set(handles.f3MarkerEdit,'String',num2str(tempf3));
else
    f3f4=zeros(1,2);
    handles.stimParams.markerCutoffs=[handles.stimParams.markerCutoffs f3f4];
    handles.stimParams.markerCutoffs(3)=str2num(get(hObject,'String'));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f3MarkerEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f4MarkerEdit_Callback(hObject, eventdata, handles)
if length(handles.stimParams.markerCutoffs)>2
    tempf4=str2num(get(hObject,'String'));
    if isempty(tempf4)
        tempf4=0;
    else
    end
    handles.stimParams.markerCutoffs(4)=tempf4;
    set(handles.f4MarkerEdit,'String',num2str(tempf4));
else
    f3f4=zeros(1,2);
    handles.stimParams.markerCutoffs=[handles.stimParams.markerCutoffs f3f4];
    handles.stimParams.markerCutoffs(3)=str2num(get(hObject,'String'));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f4MarkerEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in markerNBNSelect.
function markerNBNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.markerType='NBN';
guidata(hObject,handles);

% --- Executes on button press in markerBBNSelect.
function markerBBNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.markerType='BBN';
guidata(hObject,handles);

% --- Executes on button press in markerNtchNSelect.
function markerNtchNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.markerType='NtchN';
guidata(hObject,handles);

% --- Executes on button press in markerToneSelect.
function markerToneSelect_Callback(hObject, eventdata, handles)
handles.stimParams.markerType='Tone';
guidata(hObject,handles);

% --- Executes on button press in LNNToggle.
function LNNToggle_Callback(hObject, eventdata, handles)
handles.stimParams.markerLNNToggle=get(hObject,'Value');
guidata(hObject,handles);

function precursorDurEdit_Callback(hObject, eventdata, handles)
handles.stimParams.precursorDur=str2num(get(hObject,'String'))/1000;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function precursorDurEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function precursorLevelEdit_Callback(hObject, eventdata, handles)
handles.stimParams.precursorLevel=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function precursorLevelEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function precursorRampEdit_Callback(hObject, eventdata, handles)
handles.stimParams.precursorRamp=str2num(get(hObject,'String'))/1000;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function precursorRampEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bnoiseRampEdit_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseRamp=str2num(get(hObject,'String'))/1000;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function bnoiseRampEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bnoiseLevelEdit_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseOffset=str2num(get(hObject,'String'));
handles.stimParams.bnoiseLevel=handles.stimParams.markerLevel+handles.stimParams.bnoiseOffset+10*log10(handles.stimParams.bnoiseBW);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function bnoiseLevelEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bnoiseDurEdit_Callback(hObject, eventdata, handles)
% handles.stimParams.bnoiseDur=str2num(get(hObject,'String'))/1000;
% guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function bnoiseDurEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in bnoiseNBNSelect.
function bnoiseNBNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseType='NBN';
guidata(hObject,handles);

% --- Executes on button press in bnoiseBBNSelect.
function bnoiseBBNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseType='BBN';
guidata(hObject,handles);

% --- Executes on button press in bnoiseNtchNSelect.
function bnoiseNtchNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseType='NtchN';
guidata(hObject,handles);

% --- Executes on button press in bnoiseToneSelect.
function bnoiseToneSelect_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseType='Tone';
guidata(hObject,handles);

function f1bnoiseEdit_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseCutoffs(1)=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f1bnoiseEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f2bnoiseEdit_Callback(hObject, eventdata, handles)
handles.stimParams.bnoiseCutoffs(2)=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f2bnoiseEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f3bnoiseEdit_Callback(hObject, eventdata, handles)
if length(handles.stimParams.bnoiseCutoffs)>2
    tempf3=str2num(get(hObject,'String'));
    if isempty(tempf3)
        tempf3=0;
    else
    end
    handles.stimParams.bnoiseCutoffs(3)=tempf3;
    set(handles.f3bnoiseEdit,'String',num2str(tempf3));
else
    f3f4=zeros(1,2);
    handles.stimParams.bnoiseCutoffs=[handles.stimParams.bnoiseCutoffs f3f4];
    handles.stimParams.bnoiseCutoffs(3)=str2num(get(hObject,'String'));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f3bnoiseEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f4bnoiseEdit_Callback(hObject, eventdata, handles)
if length(handles.stimParams.bnoiseCutoffs)>2
    tempf4=str2num(get(hObject,'String'));
    if isempty(tempf4)
        tempf4=0;
    else
    end
    handles.stimParams.bnoiseCutoffs(4)=tempf4;
    set(handles.f4bnoiseEdit,'String',num2str(tempf4));
else
    f3f4=zeros(1,2);
    handles.stimParams.bnoiseCutoffs=[handles.stimParams.bnoiseCutoffs f3f4];
    handles.stimParams.bnoiseCutoffs(3)=str2num(get(hObject,'String'));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f4bnoiseEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f1precursorEdit_Callback(hObject, eventdata, handles)
handles.stimParams.precursorCutoffs(1)=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f1precursorEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f2precursorEdit_Callback(hObject, eventdata, handles)
handles.stimParams.precursorCutoffs(2)=str2num(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f2precursorEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f3precursorEdit_Callback(hObject, eventdata, handles)
if length(handles.stimParams.precursorCutoffs)>2
    tempf3=str2num(get(hObject,'String'));
    if isempty(tempf3)
        tempf3=0;
    else
    end
    handles.stimParams.precursorCutoffs(3)=tempf3;
    set(handles.f3precursorEdit,'String',num2str(tempf3));
else
    f3f4=zeros(1,2);
    handles.stimParams.precursorCutoffs=[handles.stimParams.precursorCutoffs f3f4];
    handles.stimParams.precursorCutoffs(3)=str2num(get(hObject,'String'));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f3precursorEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f4precursorEdit_Callback(hObject, eventdata, handles)
if length(handles.stimParams.precursorCutoffs)>2
    tempf4=str2num(get(hObject,'String'));
    if isempty(tempf4)
        tempf4=0;
    else
    end
    handles.stimParams.precursorCutoffs(4)=tempf4;
    set(handles.f4precursorEdit,'String',num2str(tempf4));
else
    f3f4=zeros(1,2);
    handles.stimParams.precursorCutoffs=[handles.stimParams.precursorCutoffs f3f4];
    handles.stimParams.precursorCutoffs(3)=str2num(get(hObject,'String'));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function f4precursorEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in precursorNBNSelect.
function precursorNBNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.precursorType='NBN';
guidata(hObject,handles);

% --- Executes on button press in precursorBBNSelect.
function precursorBBNSelect_Callback(hObject, eventdata, handles)
handles.stimParams.precursorType='BBN';
guidata(hObject,handles);

% --- Executes on button press in precursorNtchSelect.
function precursorNtchSelect_Callback(hObject, eventdata, handles)
handles.stimParams.precursorType='NtchN';
guidata(hObject,handles);

% --- Executes on button press in precursorToneSelect.
function precursorToneSelect_Callback(hObject, eventdata, handles)
handles.stimParams.precursorType='Tone';
guidata(hObject,handles);

% --- Executes when selected object is changed in markerTypePanel.
function markerTypePanel_SelectionChangeFcn(hObject, eventdata, handles)
markerType=get(hObject,'String');
switch markerType
    case 'NBN'
        set(handles.markerSpectrumPanel,'visible','on');
        set(handles.f2MarkerStr,'visible','on');
        set(handles.f2MarkerEdit,'visible','on');
        set(handles.f3MarkerStr,'visible','off');
        set(handles.f3MarkerEdit,'visible','off');
        set(handles.f4MarkerStr,'visible','off');
        set(handles.f4MarkerEdit,'visible','off');
        set(handles.f1MarkerEdit,'String','0');
        set(handles.f2MarkerEdit,'String','0');
        handles.stimParams.markerCutoffs=[0 0];
    case 'NtchN'
        set(handles.markerSpectrumPanel,'visible','on');
        set(handles.f3MarkerStr,'visible','on');
        set(handles.f3MarkerEdit,'visible','on');
        set(handles.f4MarkerStr,'visible','on');
        set(handles.f4MarkerEdit,'visible','on');
    case 'Tone'
        set(handles.markerSpectrumPanel,'visible','on');
        set(handles.f2MarkerStr,'visible','off');
        set(handles.f2MarkerEdit,'visible','off');
        set(handles.f3MarkerStr,'visible','off');
        set(handles.f3MarkerEdit,'visible','off');
        set(handles.f4MarkerStr,'visible','off');
        set(handles.f4MarkerEdit,'visible','off');
        handles.stimParams.markerCutoffs=handles.stimParams.markerCutoffs(1:1);
    otherwise
        set(handles.markerSpectrumPanel,'visible','off');
        handles.stimParams.markerCutoffs=[20 8000]; % marker is BBN
        set(handles.f1MarkerEdit,'String','20');
        set(handles.f2MarkerEdit,'String','8000');
        
end
handles.stimParams.markerType=markerType;
guidata(hObject, handles);

% --- Executes when selected object is changed in bnoiseTypePanel.
function bnoiseTypePanel_SelectionChangeFcn(hObject, eventdata, handles)
bnoiseType=get(hObject,'String');
switch bnoiseType
    case 'NBN'
        set(handles.bnoiseSpectrumPanel,'visible','on');
        set(handles.f2bnoiseStr,'visible','on');
        set(handles.f2bnoiseEdit,'visible','on');
        set(handles.f3bnoiseStr,'visible','off');
        set(handles.f3bnoiseEdit,'visible','off');
        set(handles.f4bnoiseStr,'visible','off');
        set(handles.f4bnoiseEdit,'visible','off');
        set(handles.f1bnoiseEdit,'String','0');
        set(handles.f2bnoiseEdit,'String','0');
        handles.stimParams.bnoiseCutoffs=[0 0];
    case 'NtchN'
        set(handles.bnoiseSpectrumPanel,'visible','on');
        set(handles.f3bnoiseStr,'visible','on');
        set(handles.f3bnoiseEdit,'visible','on');
        set(handles.f4bnoiseStr,'visible','on');
        set(handles.f4bnoiseEdit,'visible','on');
    case 'Tone'
        set(handles.bnoiseSpectrumPanel,'visible','on');
        set(handles.f2bnoiseStr,'visible','off');
        set(handles.f2bnoiseEdit,'visible','off');
        set(handles.f3bnoiseStr,'visible','off');
        set(handles.f3bnoiseEdit,'visible','off');
        set(handles.f4bnoiseStr,'visible','off');
        set(handles.f4bnoiseEdit,'visible','off');
        handles.stimParams.bnoiseCutoffs=handles.stimParams.bnoiseCutoffs(1:1);
    otherwise
        set(handles.bnoiseSpectrumPanel,'visible','off');
end
handles.stimParams.bnoiseType=bnoiseType;
guidata(hObject, handles);

% --- Executes when selected object is changed in precursorTypePanel.
function precursorTypePanel_SelectionChangeFcn(hObject, eventdata, handles)
preType=get(hObject,'String');
switch preType
    case 'NBN'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f2precursorStr,'visible','on');
        set(handles.f2precursorEdit,'visible','on');
        set(handles.f3precursorStr,'visible','off');
        set(handles.f3precursorEdit,'visible','off');
        set(handles.f4precursorStr,'visible','off');
        set(handles.f4precursorEdit,'visible','off');
        set(handles.f1precursorEdit,'String','0');
        set(handles.f2precursorEdit,'String','0');
        handles.stimParams.precursorCutoffs=[0 0];
    case 'NtchN'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f3precursorStr,'visible','on');
        set(handles.f3precursorEdit,'visible','on');
        set(handles.f4precursorStr,'visible','on');
        set(handles.f4precursorEdit,'visible','on');
    case 'Tone'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f2precursorStr,'visible','off');
        set(handles.f2precursorEdit,'visible','off');
        set(handles.f3precursorStr,'visible','off');
        set(handles.f3precursorEdit,'visible','off');
        set(handles.f4precursorStr,'visible','off');
        set(handles.f4precursorEdit,'visible','off');
        handles.stimParams.precursorCutoffs=handles.stimParams.precursorCutoffs(1:1);
    otherwise
        set(handles.precursorSpectrumPanel,'visible','off');
end
handles.stimParams.precursorType=preType;
guidata(hObject, handles);

function preGapEdit_Callback(hObject, eventdata, handles)
handles.stimParams.precursorGap=str2num(get(hObject,'String'))/1000;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function preGapEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gapRampEdit_Callback(hObject, eventdata, handles)
handles.stimParams.markerGapRamp=str2num(get(hObject,'String'))/1000;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function gapRampEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gapLocEdit_Callback(hObject, eventdata, handles)
handles.stimParams.gapCenterLoc=str2num(get(hObject,'String'))/100;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function gapLocEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialGapDurEdit_Callback(hObject, eventdata, handles)
handles.stimParams.initialGapDur=str2num(get(hObject,'String'))/1000;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function initialGapDurEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close selectStimParams_FIG.
function selectStimParams_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to selectStimParams_FIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output='deleteFIG';
guidata(hObject,handles);
confirmParams_button_Callback(hObject, eventdata, handles);


% --- Executes on button press in TrackOffsetYN.
function TrackOffsetYN_Callback(hObject, eventdata, handles)
% hObject    handle to TrackOffsetYN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

boxVal=get(hObject,'Value');

if boxVal
    handles.stimParams.TrackOffsetYN=1; % track on SNR
    set(handles.initialGapDurStr,'String',{'Fixed Gap' ;'Duration'});
    set(handles.bnoiseLevelStr,'String',{'Initial' ;'Offset'});
else
    handles.stimParams.TrackOffsetYN=0; % track on gap dur
    set(handles.initialGapDurStr,'String',{'Initial Gap' ;'Duration'});
    set(handles.bnoiseLevelStr,'String',{'Level' ;'Offset'});
end
guidata(hObject,handles);


% --- Executes on button press in bnoiseLNNToggle.
function bnoiseLNNToggle_Callback(hObject, eventdata, handles)
% hObject    handle to bnoiseLNNToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.bnoiseLNNToggle=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in precursorLNNToggle.
function precursorLNNToggle_Callback(hObject, eventdata, handles)
% hObject    handle to precursorLNNToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.precursorLNNToggle=get(hObject,'Value');
guidata(hObject,handles);


% --------------------------------------------------------------------
function fileParams_Callback(hObject, eventdata, handles)
% hObject    handle to fileParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadParams_Callback(hObject, eventdata, handles)
% hObject    handle to loadParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.paramsFile, params_pathname] = uigetfile(fullfile(cd,'Data','*.fig') ,'Load parameter file'); %promt for file name and desired directory
fclose('all');

prompt = 'Enter the number of repetitions';
dlg_title = 'Select the number of repetitions';
num_lines = 1;
def = {'1'};
numblks = inputdlg(prompt,dlg_title,num_lines,def);
numblks=str2double(numblks{1});

handles=load_parameters_gap(handles,params_pathname);
handles.stimParams.RunExpt.singleFile=params_pathname;
handles.stimParams.RunExpt.SaveFile=['complete_' handles.paramsFile];
initialize_params_gap(handles);

for nblks=1:numblks % store the number of blocks specified by the .mat file
    storeBlock_Callback(handles.storeBlock, eventdata, handles); % store blocks
    handles=guidata(hObject);
end

% --------------------------------------------------------------------
function saveParams_Callback(hObject, eventdata, handles)
% hObject    handle to saveParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[handles.paramsFile, params_pathname] = uiputfile(fullfile(cd,'Data','*.fig'), 'Save parameter file'); %promt for file name and desired directory
write_parameters_gap(handles,params_pathname);
fclose('all');