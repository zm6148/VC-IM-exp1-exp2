function varargout = selectStimParams_mod(varargin)
%SELECTSTIMPARAMS_MOD M-file for selectStimParams_mod.fig
%      SELECTSTIMPARAMS_MOD, by itself, creates a new SELECTSTIMPARAMS_MOD or raises the existing
%      singleton*.
%
%      H = SELECTSTIMPARAMS_MOD returns the handle to a new SELECTSTIMPARAMS_MOD or the handle to
%      the existing singleton*.
%
%      SELECTSTIMPARAMS_MOD('Property','Value',...) creates a new SELECTSTIMPARAMS_MOD using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to selectStimParams_mod_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SELECTSTIMPARAMS_MOD('CALLBACK') and SELECTSTIMPARAMS_MOD('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SELECTSTIMPARAMS_MOD.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectStimParams_mod

% Last Modified by GUIDE v2.5 20-Jul-2015 15:54:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @selectStimParams_mod_OpeningFcn, ...
    'gui_OutputFcn',  @selectStimParams_mod_OutputFcn, ...
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


% --- Executes just before selectStimParams_mod is made visible.
function selectStimParams_mod_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for selectStimParams_mod
handles.output = hObject;
handles.stimParams = varargin{1};
handles.blocks = varargin{2};

% -- if running and experiment from a .mat file , set the stimulus
% parameters based on the next condition in the .mat file.

% turn off features not fully developed.
set(handles.precursor_panel,'Visible','off');
set(handles.pm_panel,'Visible','off');
set(handles.preToggle,'Visible','off');
set(handles.pmToggle,'Visible','off');
set(handles.carrierLNNToggle,'Visible','off');

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
    initialize_params_mod(handles); %intialize/update parameters in window
    movegui(hObject,'center');
    set(handles.f3precursorStr,'visible','off');
    set(handles.f3precursorEdit,'visible','off');
    set(handles.f4precursorStr,'visible','off');
    set(handles.f4precursorEdit,'visible','off');
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes selectStimParams_mod wait for user response (see UIRESUME)
    uiwait(handles.selectStimParams_FIG);
end

% --- Outputs from this function are returned to the command line.
function varargout = selectStimParams_mod_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% Get default command line output from handles structure
if getappdata(findall(0,'tag','tmodGUI_FIG'),'exitFlag')==1
    varargout{1} = [];
    varargout{2} = [];
    varargout{3} = [];
elseif ~isfield(handles,'stimParams')
    varargout{1} = [];
    varargout{2} = [];
    varargout{3} = [];
else
    varargout{1} = handles.output;
    varargout{2} = handles.stimParams; %last set of stimulus parameters
    varargout{3} = handles.blocks;     %stored stimulus parameters for all blocks
    delete(handles.selectStimParams_FIG);
end



% --- Executes on button press in confirmParams_button.
function confirmParams_button_Callback(hObject, eventdata, handles)
% hObject    handle to confirmParams_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if isempty(handles.blocks) % if the user has not saved a block, initialize the first block to the current parameters
    % set level of hpmasker here
    handles=setHPLevel(handles);
    handles.blocks{1}=handles.stimParams;
else
    handles.stimParams=handles.blocks{1}; %update stim params to current block
end

guidata(hObject, handles);
uiresume;


function blockEdit_Callback(hObject, eventdata, handles)
% hObject    handle to blockEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of blockEdit as text
%        str2double(get(hObject,'String')) returns contents of blockEdit as a double


% --- Executes during object creation, after setting all properties.
function blockEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blockEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in storeBlock.
function storeBlock_Callback(hObject, eventdata, handles)
% hObject    handle to storeBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set level of hpmasker here...
handles=setHPLevel(handles);

handles.stimParams.blockNum=handles.stimParams.blockNum+1;
handles.blocks{handles.stimParams.blockNum}=handles.stimParams; %store all stim params in each block
set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));

handles.stimParams=handles.blocks{handles.stimParams.blockNum}; %visible stim params are current block
initialize_params_mod(handles); %update window

guidata(hObject, handles);



% --- Executes on button press in removeBlock.
function removeBlock_Callback(hObject, eventdata, handles)
% hObject    handle to removeBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.stimParams.blockNum > 1
    handles.blocks(handles.stimParams.blockNum)=[]; %delete all stim params in block (unless only 1 left)
end

handles.stimParams.blockNum=handles.stimParams.blockNum-1;
if handles.stimParams.blockNum <1
    handles.stimParams.blockNum=0;
end
set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));

handles.stimParams=handles.blocks{handles.stimParams.blockNum}; %visible stim params are current block
initialize_params_mod(handles); %update window

guidata(hObject, handles);


function carrierFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to carrierFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of carrierFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of carrierFreqEdit as a double

handles.stimParams.fc = str2num(get(hObject, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function carrierFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carrierFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigDurEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sigDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of sigDurEdit as text
%        str2double(get(hObject,'String')) returns contents of sigDurEdit as a double

handles.stimParams.dur = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sigDurEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigLevelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sigLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of sigLevelEdit as text
%        str2double(get(hObject,'String')) returns contents of sigLevelEdit as a double
newSigLevel=str2num(get(hObject, 'String'));
newSigDiff=newSigLevel-handles.stimParams.sigLevel;
handles.stimParams.sigLevel = newSigLevel;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function sigLevelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rampEdit_Callback(hObject, eventdata, handles)
% hObject    handle to rampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of rampEdit as text
%        str2double(get(hObject,'String')) returns contents of rampEdit as a double

handles.stimParams.ramp = str2num(get(hObject, 'String')/1000);
guidata(hObject, handles);



function modFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to modFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of modFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of modFreqEdit as a double
handles.stimParams.fm = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rampEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in noiseMod.
function noiseMod_Callback(hObject, eventdata, handles)
% hObject    handle to noiseMod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of noiseMod

set(handles.toneMod,'Value',0);
set(handles.noiseMod,'Value',1);
set(handles.carrierFreqEdit,'Enable','off');
set(handles.carrierLNNToggle,'Enable','on');
set(handles.pmToggle,'Enable','on');
set(handles.pm_panel,'Visible','on');

if get(handles.pmToggle,'Value')
    set(handles.pm_panel,'Visible','on');
    handles.stimParams.pmToggle=1;
else
    set(handles.pm_panel,'Visible','off');
    handles.stimParams.pmToggle=0;
end

handles.stimParams.carrierType='noise';
guidata(hObject, handles);

% --- Executes on button press in toneMod.
function toneMod_Callback(hObject, eventdata, handles)
% hObject    handle to toneMod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of toneMod

set(handles.toneMod,'Value',1);
set(handles.noiseMod,'Value',0);
set(handles.carrierFreqEdit,'Enable','on');
set(handles.pmToggle,'Value',0,'Enable','off');
set(handles.pm_panel,'Visible','off');
set(handles.carrierLNNToggle,'Enable','off','Value',0);
handles.stimParams.pmToggle=0;
handles.stimParams.carrierType='tone';
guidata(hObject, handles);

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

%-- prompt the user to choose whether to run an experiment .mat file or to
%load a single .txt file.  If an experiment is currently in progress, load
%the next condition in the .mat file.

if handles.stimParams.RunExpt.YN % experiment already in progress
    ListSelect=1;
else
    % prompt the user
    ListOpts={'Run a single user-defined condition'};
    [ListSelect,OKstatus]=listdlg('PromptString','Select a load option...','ListString',ListOpts,'SelectionMode','single','ListSize',[300 300]);
end

if ListSelect==0
    % load the selected experiment or the experiment already in progress
    DataDir=[cd '\Data\'];
    if handles.stimParams.RunExpt.YN
        ExptInfoDir=handles.stimParams.RunExpt.SubjDir;
        ExptInfoFile=handles.stimParams.RunExpt.MatFile;
        hExpt=load([ExptInfoDir ExptInfoFile]);
    else
        [ExptInfoFile, ExptInfoDir] = uigetfile([DataDir '*.mat'], 'Load ExptInfo file'); %promt for file name and desired directory
        hExpt=load([ExptInfoDir ExptInfoFile]);
    end
    
    
    % determine the next condition to run
    nfinished=sum(hExpt.ExptInfo.fcompleteYN);
    
    if nfinished==length(hExpt.ExptInfo.forder)
        close all; clear all; clc;
        msgbox('You have completed all conditions!');
        return;
    else
    end
    nextCond=hExpt.ExptInfo.forder(nfinished+1); % the index number of the next condition
    handles.paramsFile=char(hExpt.ExptInfo.fnames(nextCond)); % the file name of the next condition
    params_pathname=[ExptInfoDir 'TestFiles\']; % the directory where the conditions are stored
    fclose('all');
    
    %save some information about the experimental directories for later use.
    handles.stimParams.RunExpt.SaveFile=strtok(handles.paramsFile,'.');
    handles.stimParams.RunExpt.SaveDir=[ExptInfoDir 'DataFiles'];
    handles.stimParams.RunExpt.SubjDir=ExptInfoDir;
    handles.stimParams.RunExpt.MatFile=ExptInfoFile;
    handles.stimParams.RunExpt.CondNum=nextCond;
    handles.stimParams.RunExpt.nFinished=nfinished+1;
    handles.stimParams.RunExpt.YN=1;
    
    % load the parameters contained in the test file
    handles=load_parameters_mod(handles,params_pathname);
    initialize_params_mod(handles);
    for nblks=1:hExpt.ExptInfo.nStoreBlocks
        storeBlock_Callback(handles.storeBlock, eventdata, handles); % store blocks
        handles=guidata(hObject);
    end
    confirmParams_button_Callback(handles.confirmParams_button, eventdata, handles); % press the confirm button to exit the selectStimParams GUI
else
    [handles.paramsFile, params_pathname] = uigetfile(fullfile(cd,'Data','*.txt'), 'Load parameter file'); %promt for file name and desired directory
    fclose('all');
    
    prompt = 'Enter the number of repetitions...';
    dlg_title = 'Define the number of repetitions';
    num_lines = 1;
    def = {'1'};
    numblks = inputdlg(prompt,dlg_title,num_lines,def);
    numblks=str2double(numblks{1});
    
    handles=load_parameters_mod(handles,params_pathname);
    handles.stimParams.RunExpt.singleFile=params_pathname;
    handles.stimParams.RunExpt.SaveFile=['complete_' handles.paramsFile];
    initialize_params_mod(handles);
    
    for nblks=1:numblks % store the number of blocks specified by the .mat file
        storeBlock_Callback(handles.storeBlock, eventdata, handles); % store blocks
        handles=guidata(hObject);
    end
end

% --------------------------------------------------------------------
function saveParams_Callback(hObject, eventdata, handles)
% hObject    handle to saveParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.paramsFile, params_pathname] = uiputfile(fullfile(cd,'Data','*.txt'), 'Save parameter file'); %promt for file name and desired directory
write_parameters_mod(handles,params_pathname);
fclose('all');


% --- Executes during object creation, after setting all properties.
function modFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preToggle.
function preToggle_Callback(hObject, eventdata, handles)
% hObject    handle to preToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.preToggle,'Value',get(hObject,'Value'));
handles.stimParams.preToggle=get(hObject,'Value');
if get(handles.preToggle,'Value')
    set(handles.precursor_panel,'Visible','on');
else
    set(handles.precursor_panel,'Visible','off');
end

guidata(hObject, handles);



function preLevel_Callback(hObject, eventdata, handles)
% hObject    handle to preLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.preLevel = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function preLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preDur_Callback(hObject, eventdata, handles)
% hObject    handle to preDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.preDur = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function preDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pmToggle.
function pmToggle_Callback(hObject, eventdata, handles)
% hObject    handle to pmToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pmToggle

set(handles.pmToggle,'Value',get(hObject,'Value'));
handles.stimParams.pmToggle=get(hObject,'Value');

if get(handles.pmToggle,'Value')
    set(handles.pm_panel,'Visible','on');
else
    set(handles.pm_panel,'Visible','off');
end

guidata(hObject, handles);


function pmCF_Callback(hObject, eventdata, handles)
% hObject    handle to pmCF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pmCF as text
%        str2double(get(hObject,'String')) returns contents of pmCF as a double

handles.stimParams.pmCF = str2num(get(hObject, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pmCF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmCF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pmBW_Callback(hObject, eventdata, handles)
% hObject    handle to pmBW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pmBW as text
%        str2double(get(hObject,'String')) returns contents of pmBW as a double
handles.stimParams.pmBW = str2num(get(hObject, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pmBW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmBW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in preType.
function preType_Callback(hObject, eventdata, handles)
% hObject    handle to preType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

preType=get(hObject,'String');
preType=preType{get(hObject,'Value')};
switch preType
    case 'BBN/NBN'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f2precursorStr,'visible','on');
        set(handles.f2precursorEdit,'visible','on');
        set(handles.f3precursorStr,'visible','off');
        set(handles.f3precursorEdit,'visible','off');
        set(handles.f4precursorStr,'visible','off');
        set(handles.f4precursorEdit,'visible','off');
        set(handles.f1precursorEdit,'String','0');
        set(handles.f2precursorEdit,'String','0');
        set(handles.precursorLNNToggle,'Visible','on');
        handles.stimParams.precursorCutoffs=[0 0 0 0];
    case 'Notched Noise'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f2precursorStr,'visible','on');
        set(handles.f2precursorEdit,'visible','on');
        set(handles.f3precursorStr,'visible','on');
        set(handles.f3precursorEdit,'visible','on');
        set(handles.f4precursorStr,'visible','on');
        set(handles.f4precursorEdit,'visible','on');
        set(handles.precursorLNNToggle,'Visible','on');
    case 'Tone at Probe Hz'
        set(handles.precursorSpectrumPanel,'visible','on');
        set(handles.f2precursorStr,'visible','off');
        set(handles.f2precursorEdit,'visible','off');
        set(handles.f3precursorStr,'visible','off');
        set(handles.f3precursorEdit,'visible','off');
        set(handles.f4precursorStr,'visible','off');
        set(handles.f4precursorEdit,'visible','off');
        set(handles.precursorLNNToggle,'Visible','off');
        handles.stimParams.precursorCutoffs=handles.stimParams.precursorCutoffs(1:1);
    otherwise
        set(handles.precursorSpectrumPanel,'visible','off');
end
handles.stimParams.preType=preType;
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns preType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from preType


% --- Executes during object creation, after setting all properties.
function preType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preDel_Callback(hObject, eventdata, handles)
% hObject    handle to preDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.stimParams.preDel = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of preDel as text
%        str2double(get(hObject,'String')) returns contents of preDel as a double


% --- Executes during object creation, after setting all properties.
function preDel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
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

% --- Executes on button press in precursorLNNToggle.
function precursorLNNToggle_Callback(hObject, eventdata, handles)
% hObject    handle to precursorLNNToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.precursorLNNToggle=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in carrierLNNToggle.
function carrierLNNToggle_Callback(hObject, eventdata, handles)
% hObject    handle to carrierLNNToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stimParams.carrierLNNToggle=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes when user attempts to close selectStimParams_FIG.
function selectStimParams_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to selectStimParams_FIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
