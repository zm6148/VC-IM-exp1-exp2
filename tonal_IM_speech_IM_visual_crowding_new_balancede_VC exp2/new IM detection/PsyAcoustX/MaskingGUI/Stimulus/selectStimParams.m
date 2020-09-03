function varargout = selectStimParams(varargin)
% SELECTSTIMPARAMS M-file for selectStimParams.fig
%      SELECTSTIMPARAMS, by itself, creates a new SELECTSTIMPARAMS or raises the existing
%      singleton*.
%
%      H = SELECTSTIMPARAMS returns the handle to a new SELECTSTIMPARAMS or the handle to
%      the existing singleton*.
%
%      SELECTSTIMPARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTSTIMPARAMS.M with the given input arguments.
%
%      SELECTSTIMPARAMS('Property','Value',...) creates a new SELECTSTIMPARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectStimParams_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectStimParams_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectStimParams

% Last Modified by GUIDE v2.5 20-Jul-2015 14:55:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @selectStimParams_OpeningFcn, ...
    'gui_OutputFcn',  @selectStimParams_OutputFcn, ...
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


% --- Executes just before selectStimParams is made visible.
function selectStimParams_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectStimParams (see VARARGIN)

% Choose default command line output for selectStimParams
handles.output = hObject;
handles.stimParams = varargin{1};
handles.blocks = varargin{2};

% disable features that have not yet been fully developed
hAdd2Expt=findall(0,'tag','add2Expt');
set(hAdd2Expt,'Visible','off');

% if running from an experimental file, automatically load the next
% condition.  if not, let the user select the stimulus parameters
if isfield(handles.stimParams,'RunExpt')
    if handles.stimParams.RunExpt.YN
        handles.blocks=[]; % reinitialize handles.blocks
        handles.stimParams.blockNum=0; % reinitialize block number
        loadParams_Callback(handles.loadParams, eventdata, handles);  % load the next condition
        if getappdata(findall(0,'tag','MaskingGUI_FIG'),'exitFlag')==1
            return;
        else
        end
        
        h_runGUI=findall(0,'tag','runGUI');
        hCBrunGUI=get(h_runGUI,'Callback');
        feval(hCBrunGUI,h_runGUI,handles); % reopen the response window
    else
    end
else
    handles.stimParams.RunExpt.YN=0;
    initialize_params(handles); %intialize/update parameters in window
    movegui(hObject,'center')
    
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes selectStimParams wait for user response (see UIRESUME)
    uiwait(handles.selectStimParams_FIG);
end



% --- Outputs from this function are returned to the command line.
function varargout = selectStimParams_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if getappdata(findall(0,'tag','MaskingGUI_FIG'),'exitFlag')==1
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


function maskerLevelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maskerLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskerLevelEdit as text
%        str2double(get(hObject,'String')) returns contents of maskerLevelEdit as a double
handles.stimParams.maskerLevel = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maskerLevelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetLevelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to targetLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of targetLevelEdit as text
%        str2double(get(hObject,'String')) returns contents of targetLevelEdit as a double
handles.stimParams.targetLevel = str2num(get(hObject, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function targetLevelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function delayEdit_Callback(hObject, eventdata, handles)
% hObject    handle to delayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delayEdit as text
%        str2double(get(hObject,'String')) returns contents of delayEdit as a double
handles.stimParams.delay = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function delayEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskerRampEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maskerRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskerRampEdit as text
%        str2double(get(hObject,'String')) returns contents of maskerRampEdit as a double
handles.stimParams.maskerRamp = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function maskerRampEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maskerDurEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maskerDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskerDurEdit as text
%        str2double(get(hObject,'String')) returns contents of maskerDurEdit as a double
handles.stimParams.maskerDur = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maskerDurEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetDurEdit_Callback(hObject, eventdata, handles)
% hObject    handle to targetDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of targetDurEdit as text
%        str2double(get(hObject,'String')) returns contents of targetDurEdit as a double
handles.stimParams.targetDur = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function targetDurEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function targetFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to targetFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of targetFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of targetFreqEdit as a double
handles.stimParams.targetFreq = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function targetFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in confirmParams_button.
function confirmParams_button_Callback(hObject, eventdata, handles)
% hObject    handle to confirmParams_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=setHPMaskerBWLvl(handles); % update hp masker bw and level   
guidata(hObject, handles);
uiresume;


% --- Executes on button press in simMask.
function simMask_Callback(hObject, eventdata, handles)
% hObject    handle to simMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of simMask

maskerType='simultaneous';
set(handles.simMask, 'Value', 1);
set(handles.forMask, 'Value', 0);
handles.stimParams.maskerType=maskerType;
guidata(hObject, handles);


% --- Executes on button press in forMask.
function forMask_Callback(hObject, eventdata, handles)
% hObject    handle to forMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of forMask

maskerType='forward';
set(handles.simMask, 'Value', 0);
set(handles.forMask, 'Value', 1);
handles.stimParams.maskerType=maskerType;
guidata(hObject, handles);



function maskerFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maskerFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of maskerFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of maskerFreqEdit as a double

if get(handles.toneMask,'Value') == 1 %tone masker
    set(handles.maskerFreqEdit, 'Enable', 'On');%enable radio button
end

handles.stimParams.maskerFreq = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function preFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function maskerFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskerFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in noiseMask.
function noiseMask_Callback(hObject, eventdata, handles)
% hObject    handle to noiseMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of noiseMask

set(handles.maskerFreqEdit, 'Enable', 'off'); %disable radio button
maskerSig='noise';
set(handles.toneMask, 'Value', 0);
%alpha(0.1);
%turn on notched noise option
set(handles.notchToggle, 'Enable', 'on');

handles.stimParams.maskerSig=maskerSig;
guidata(hObject, handles);


% --- Executes on button press in toneMask.
function toneMask_Callback(hObject, eventdata, handles)
% hObject    handle to toneMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of toneMask

set(handles.maskerFreqEdit, 'Enable', 'On');%enable radio button
maskerSig='tone';
set(handles.noiseMask, 'Value', 0);

%tone masker so turn off notched noise features
%alpha(0.1); %transparent
set(handles.cutoffFreqs, 'Enable', 'off');
set(handles.notchToggle, 'Enable', 'off','Value',0);

handles.stimParams.maskerSig=maskerSig;
guidata(hObject, handles);


% --- Executes on button press in notchToggle.
function notchToggle_Callback(hObject, eventdata, handles)
% hObject    handle to notchToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of notchToggle

if get(hObject,'Value') == 1 %checked
    %alpha(1);%show masking schematic
    set(handles.cutoffFreqs, 'Enable', 'On'); %turn on feature
    handles.stimParams.notchToggle=1;
else %unchecked
    set(handles.cutoffFreqs, 'Enable', 'off'); %turn off feature
    %alpha(0.1); %transparent
    handles.stimParams.notchToggle=0;
end

guidata(hObject, handles);



function cutoffFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to cutoffFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of cutoffFreqs as text
%        str2double(get(hObject,'String')) returns contents of cutoffFreqs as a double

handles.stimParams.maskerCutoffs = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function cutoffFreqs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cutoffFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in precursorToggle.
function precursorToggle_Callback(hObject, eventdata, handles)
% hObject    handle to precursorToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint  get(hObject,'Value') returns toggle state of precursorToggle

if get(hObject,'Value') == 1 %checked
    set(handles.tonePreOn, 'Enable', 'On');  %turn on features
    set(handles.noisePreOn, 'Enable', 'On');
    set(handles.preDurEdit, 'Enable', 'On');
    set(handles.preRampEdit, 'Enable', 'On');
    set(handles.preDelayEdit, 'Enable', 'On');
    set(handles.preLevelEdit, 'Enable', 'On');
    
    if handles.noisePreOn==1
        set(handles.preFreqEdit,'Enable','off');
    else
        set(handles.preFreqEdit,'Enable','On');
    end
    
    handles.stimParams.preToggle=1;
else %unchecked
    set(handles.tonePreOn, 'Enable', 'off');  %turn off features
    set(handles.noisePreOn, 'Enable', 'off');
    set(handles.preFreqEdit, 'Enable', 'off');
    set(handles.preDurEdit, 'Enable', 'off');
    set(handles.preRampEdit, 'Enable', 'off');
    set(handles.preDelayEdit, 'Enable', 'off');
    set(handles.preLevelEdit, 'Enable', 'off');
    
    handles.stimParams.preToggle=0;
end

guidata(hObject, handles);



% --- Executes on button press in noisePreOn.
function noisePreOn_Callback(hObject, eventdata, handles)
% hObject    handle to noisePreOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of noisePreOn
set(handles.preFreqEdit,'Enable','off');
preSig='noise';
set(handles.tonePreOn, 'Value', 0);
handles.stimParams.preType=preSig;
guidata(hObject, handles);


% --- Executes on button press in tonePreOn.
function tonePreOn_Callback(hObject, eventdata, handles)
% hObject    handle to tonePreOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of tonePreOn

preSig='tone';
set(handles.preFreqEdit,'Enable','on');
set(handles.noisePreOn, 'Value', 0);
handles.stimParams.preType=preSig;
guidata(hObject, handles);



function preFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to preFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of preFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of preFreqEdit as a double

handles.stimParams.preFreq = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes on button press in targetAloneCheck.
function targetAloneCheck_Callback(hObject, eventdata, handles)
% hObject    handle to targetAloneCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of targetAloneCheck

if get(hObject,'Value')==1 %checked
    handles.stimParams.targetAlone=1;
    handles.stimParams.trackTarget=1; %tracking target only
    set(findall(0,'tag','trackTargetCheck'),'value',1); %check box automatically
    set(handles.trackTargetCheck,'enable','off');
    set(handles.simMask,'enable','off');
    handles.stimParams.maskerType='forward';
    set(handles.simMask, 'Value', 0);
    set(handles.forMask, 'Value', 1);
    
else
    handles.stimParams.targetAlone=0;
    set(handles.trackTargetCheck,'enable','on');
    set(handles.simMask,'enable','on');
end

guidata(hObject, handles);


% --- Executes on button press in trackTargetCheck.
function trackTargetCheck_Callback(hObject, eventdata, handles)
% hObject    handle to trackTargetCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of trackTargetCheck


if get(hObject,'Value')==1 %checked
    handles.stimParams.trackTarget=1; %track target only
    set(findall(0,'tag','trackTargetCheck'),'value',1); %check box
else %unchecked
    handles.stimParams.trackTarget=0; %track masker
end

guidata(hObject, handles);



function preDurEdit_Callback(hObject, eventdata, handles)
% hObject    handle to preDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of preDurEdit as text
%        str2double(get(hObject,'String')) returns contents of preDurEdit as a double

handles.stimParams.preDur = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function preDurEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function targetRampEdit_Callback(hObject, eventdata, handles)
% hObject    handle to targetRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of targetRampEdit as text
%        str2double(get(hObject,'String')) returns contents of targetRampEdit as a double
handles.stimParams.targetRamp = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function targetRampEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preRampEdit_Callback(hObject, eventdata, handles)
% hObject    handle to preRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of preRampEdit as text
%        str2double(get(hObject,'String')) returns contents of preRampEdit as a double
handles.stimParams.preRamp = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function preRampEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preDelayEdit_Callback(hObject, eventdata, handles)
% hObject    handle to preDelayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of preDelayEdit as text
%        str2double(get(hObject,'String')) returns contents of preDelayEdit as a double
handles.stimParams.preDelay = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function preDelayEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preDelayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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

ListOpts={'Continue with a selected experiment' 'Run a ''''warm-up'''' condition for a selected experiment' 'Run a single user-defined condition'};
if handles.stimParams.RunExpt.YN % experiment already in progress
    ListSelect=1;
else
    % prompt the user
    [ListSelect,OKstatus]=listdlg('PromptString','Select a load option...','ListString',ListOpts,'SelectionMode','single','ListSize',[300 300]);
end

if ListSelect==1 || ListSelect==2 % continue with experiment or do warm-up
    % load the selected experiment or the experiment already in progress
    DataDir=[cd '\Data\'];
    if handles.stimParams.RunExpt.YN % experiment already in progress
        ExptInfoDir=handles.stimParams.RunExpt.SubjDir;
        ExptInfoFile=handles.stimParams.RunExpt.MatFile;
        hExpt=load([ExptInfoDir ExptInfoFile]); % load the subject's .mat file containing the info. about the conditions to run
    else % select the experiment
        [ExptInfoFile, ExptInfoDir] = uigetfile([DataDir '*.mat'], 'Load ExptInfo file'); %promt for file name and desired directory
        hExpt=load([ExptInfoDir ExptInfoFile]);
    end
    
    % determine the next condition to run
    nfinished=sum(hExpt.ExptInfo.fcompleteYN);
    
    if nfinished==length(hExpt.ExptInfo.forder) % the subject has completed all conditions
        setappdata(findall(0,'tag','MaskingGUI_FIG'),'exitFlag',1);
        mbexit=msgbox('You have completed all conditions!');
        waitfor(mbexit);
        return;
    else
    end
    
    nextCond=hExpt.ExptInfo.forder(nfinished+1); % the index number of the next condition
    handles.paramsFile=[ hExpt.ExptInfo.subID '_' num2str(nextCond) '.txt']; % the file name of the next condition
    %handles.paramsFile=char(hExpt.ExptInfo.fnames(nextCond));
    params_pathname=[ExptInfoDir 'TestFiles\']; % the directory where the conditions are stored
    fclose('all');
    
    %save some information about the experimental directories for later use.
    handles.stimParams.RunExpt.SaveFile=strtok(handles.paramsFile,'.');
    handles.stimParams.RunExpt.SaveDir=[ExptInfoDir 'DataFiles'];
    handles.stimParams.RunExpt.SubjDir=ExptInfoDir;
    handles.stimParams.RunExpt.MatFile=ExptInfoFile;
    handles.stimParams.RunExpt.CondNum=nextCond;
    handles.stimParams.RunExpt.nFinished=nfinished+1;
    
    if ListSelect==1
        handles.stimParams.RunExpt.YN=1;
    else % run a warm-up condition with one repetition.  The data will not be saved
        handles.stimParams.RunExpt.YN=0;
        hExpt.ExptInfo.nStoreBlocks=1;
    end
    
    % load the parameters contained in the test file
    handles=load_parameters(handles,params_pathname);
    initialize_params(handles);
    for nblks=1:hExpt.ExptInfo.nStoreBlocks % store the number of blocks specified by the .mat file
        storeBlock_Callback(handles.storeBlock, eventdata, handles); % store blocks
        handles=guidata(hObject);
    end
    confirmParams_button_Callback(handles.confirmParams_button, eventdata, handles); % press the confirm button to exit the selectStimParams GUI
elseif ListSelect==3
    [handles.paramsFile, params_pathname] = uigetfile(fullfile(cd,'Data','*.txt'), 'Load parameter file'); %promt for file name and desired directory
    fclose('all');
    
    prompt = 'Enter the number of repetitions...';
    dlg_title = 'Define the number of repetitions';
    num_lines = 1;
    def = {'1'};
    numblks = inputdlg(prompt,dlg_title,num_lines,def);
    numblks=str2double(numblks{1});
    
    handles=load_parameters(handles,params_pathname);
    handles.stimParams.RunExpt.singleFile=params_pathname;
    handles.stimParams.RunExpt.SaveFile=['complete_' handles.paramsFile];
    initialize_params(handles);
    
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
write_parameters(handles,params_pathname);
fclose('all');


% --- Executes on button press in hpMaskerToggle.
function hpMaskerToggle_Callback(hObject, eventdata, handles)
% hObject    handle to hpMaskerToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of hpMaskerToggle

if get(hObject,'Value')==1 %checked
    handles.stimParams.hpMaskerToggle=1; %turn on HP masker to mimize off-frequency listening
    set(findall(0,'tag','hpMaskerToggle'),'value',1); %check box
else %unchecked
    handles.stimParams.hpMaskerToggle=0; %uncheck box
end

guidata(hObject, handles);



% --- Executes on button press in storeBlock.
function storeBlock_Callback(hObject, eventdata, handles)
% hObject    handle to storeBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stimParams.blockNum=handles.stimParams.blockNum+1;
handles=setHPMaskerBWLvl(handles); % update hp masker bw and level   
handles.blocks{handles.stimParams.blockNum}=handles.stimParams; %store all stim params in each block
set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));

handles.stimParams=handles.blocks{handles.stimParams.blockNum}; %visible stim params are current block
initialize_params(handles); %update window

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
initialize_params(handles); %update window


guidata(hObject, handles);



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



function preLevelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to preLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of preLevelEdit as text
%        str2double(get(hObject,'String')) returns contents of preLevelEdit as a double
handles.stimParams.preLevel = str2num(get(hObject, 'String'));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function preLevelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function supLevelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to supLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of supLevelEdit as text
%        str2double(get(hObject,'String')) returns contents of supLevelEdit as a double
handles.stimParams.supLevel = str2num(get(hObject, 'String'));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function supLevelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to supLevelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function supRampEdit_Callback(hObject, eventdata, handles)
% hObject    handle to supRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of supRampEdit as text
%        str2double(get(hObject,'String')) returns contents of supRampEdit as a double
handles.stimParams.supRamp = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function supRampEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to supRampEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function supDurEdit_Callback(hObject, eventdata, handles)
% hObject    handle to supDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of supDurEdit as text
%        str2double(get(hObject,'String')) returns contents of supDurEdit as a double
handles.stimParams.supDur = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function supDurEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to supDurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function supFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to supFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of supFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of supFreqEdit as a double
handles.stimParams.supFreq = str2num(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function supFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to supFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in supToggle.
function supToggle_Callback(hObject, eventdata, handles)
% hObject    handle to supToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of supToggle

if get(hObject,'Value')==1 %checked
    handles.stimParams.supToggle=1; %turn supressor On
    set(handles.supRampEdit, 'Enable', 'on');
    set(handles.supFreqEdit, 'Enable', 'on');
    set(handles.supLevelEdit, 'Enable', 'on');
    set(handles.supDurEdit, 'Enable', 'on');
    set(handles.supDelayEdit, 'Enable', 'on');
else %unchecked
    handles.stimParams.supToggle=0; %turn supressor On
    set(handles.supRampEdit, 'Enable', 'off');
    set(handles.supFreqEdit, 'Enable', 'off');
    set(handles.supLevelEdit, 'Enable', 'off');
    set(handles.supDurEdit, 'Enable', 'off');
    set(handles.supDelayEdit, 'Enable', 'off');
end

guidata(hObject, handles);


function supDelayEdit_Callback(hObject, eventdata, handles)
% hObject    handle to supDelayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of supDelayEdit as text
%        str2double(get(hObject,'String')) returns contents of supDelayEdit as a double
handles.stimParams.supDelay = str2num(get(hObject, 'String'))/1000;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function supDelayEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to supDelayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function add2Expt_Callback(hObject, eventdata, handles)
% hObject    handle to add2Expt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newStim=handles.stimParams;
setappdata(hObject,'stim2Add',newStim);
updateType='add';
updateExptInfo(hObject,eventdata,updateType);
mb1=msgbox('The condition was saved');
waitfor(mb1);

% --------------------------------------------------------------------
function delFromExpt_Callback(hObject, eventdata, handles)
% hObject    handle to delFromExpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\

%%% get the experiment information from the ExptInfo.mat file and prepare
%%% to display this information in a table
DataPath=[cd '\Data\'];
[ExptInfoFile, ExptInfoDir]=uigetfile([DataPath '*.mat'], 'Open subject folder and select ExptInfo.mat file...');
cExpt=load([ExptInfoDir '\' ExptInfoFile]);
tblbody=cExpt.ExptInfo.Table(:, ~logical(cExpt.ExptInfo.fcompleteYN));
tblheader=cExpt.ExptInfo.tblheader;
tblcolnames=cExpt.ExptInfo.tblcolnames(~logical(cExpt.ExptInfo.fcompleteYN),:);
tblindx=cellstr(num2str([1:1:size(tblbody,2)]'))';

for numcells=1:numel(tblbody) % reformat cells that are not scalars or strings (uitable will not display a vector in one cell)
    tblbody{numcells}=num2str([tblbody{numcells}]);
end

tblbody=[cellstr(tblcolnames)'; tblbody];
tblheader=['Column Number' tblheader];

%%% display the table and set up callback
f1=figure;
updateType='delete';
set(f1,'Name','Experimental Conditions');
set(f1,'Units','Normalized','Position',[0.0063    0.3086    0.9789    0.5498]);
t1=uitable(f1,'Data',tblbody,'RowName',tblheader,'Units','Normalized','Position',[.05 .01 .9 .99]);

%%% ask the user if a condition will be deleted.
deleteYN=questdlg('Would you like to delete a condition(s)?','delete conditions?','Yes','No','No');

switch deleteYN
    case 'No' % not deleting a condition
        msgbox('please close the table when finished...','CreateMode','modal');
    otherwise % deleting conditions
        % display instructions for deleting conditions
        msgbox({'To delete a condition:  '; '1)  left-click any cell corresponding to that condition THEN,'; '2)  right-click anywhere in the window.';...
            '3)  repeat steps 1 and 2 until all desired conditions have been deleted.'; '4)  When finished, close the table to continue.'} ,'delete conditions.','modal');
        
        % set callback functions for when a table cell is selected and when
        % the figure is closed
        set(f1,'CloseRequestFcn',{@updateExptInfo,updateType},'UserData',cExpt);
        set(t1,'CellEditCallback','deleteCell','tag','exptTable');
        
        %%% initialize application data and update as the user deletes
        %%% items
        modLog.deleteNames={};
        setappdata(t1,'modLog',modLog);
        
        %%% return the cell number [row column] when a table cell is
        %%% selected and save this cell number in the UserData field of the
        %%% table
        set(t1,'CellSelectionCallback',@(src,evnt,handles)set(src,'UserData',evnt.Indices),'ButtonDownFcn',@deleteRow);
        waitfor(f1); %halt execution until the table is closed.
end




% --------------------------------------------------------------------
function SkipCond_Callback(hObject, eventdata, handles)
% hObject    handle to SkipCond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataPath=[cd '\Data\'];
[ExptInfoFile, ExptInfoDir]=uigetfile([DataPath '*.mat'], 'Open subject folder and select ExptInfo.mat file...');
cExpt=load([ExptInfoDir '\' ExptInfoFile]);
nfinished=sum(cExpt.ExptInfo.fcompleteYN);
nextCond=cExpt.ExptInfo.forder(nfinished+1);
cExpt.ExptInfo.fcompleteYN(nextCond)=1;
optSelect = questdlg(['This will delete the next condition (#'...
    num2str(nextCond) '). Continue?'], ...
    'Delete Next Condition', ...
    'Yes','No','No');

switch optSelect
    case 'Yes'
        ExptInfo=cExpt.ExptInfo;
        save([ExptInfoDir ExptInfoFile],'ExptInfo');
        clear ExptInfo;
        msgbox('This condition will now be skipped.');
    otherwise
        msgbox('Action canceled');
end


% --- Executes when user attempts to close selectStimParams_FIG.
function selectStimParams_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to selectStimParams_FIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
% close all; clear all; clc;
% MaskingGUI;
