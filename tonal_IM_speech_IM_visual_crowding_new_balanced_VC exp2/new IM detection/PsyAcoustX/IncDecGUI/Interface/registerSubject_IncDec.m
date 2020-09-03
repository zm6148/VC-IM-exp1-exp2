function varargout = registerSubject_IncDec(varargin)
% REGISTERSUBJECT_MOD M-file for registerSubject_mod.fig
%      REGISTERSUBJECT_MOD, by itself, creates a new REGISTERSUBJECT_MOD or raises the existing
%      singleton*.
%
%      H = REGISTERSUBJECT_MOD returns the handle to a new REGISTERSUBJECT_MOD or the handle to
%      the existing singleton*.
%
%      REGISTERSUBJECT_MOD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTERSUBJECT_MOD.M with the given input arguments.
%
%      REGISTERSUBJECT_MOD('Property','Value',...) creates a new REGISTERSUBJECT_MOD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before registerSubject_mod_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to registerSubject_mod_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help registerSubject_mod

% Last Modified by GUIDE v2.5 22-Jun-2012 12:13:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @registerSubject_mod_OpeningFcn, ...
    'gui_OutputFcn',  @registerSubject_mod_OutputFcn, ...
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


% --- Executes just before registerSubject_mod is made visible.
function registerSubject_mod_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to registerSubject_mod (see VARARGIN)

% Choose default command line output for registerSubject_mod
handles.output = hObject;

handles.subID = varargin{1};
set(handles.subjectEdit, 'String', handles.subID);

movegui(hObject,'center')

%%% initialize parameters
fullSpectrumBox=1;
partialSpectrumBox=1;
noPrecurrsorBox=1;
noisePrecursorBox=1;
carrierLevel='40,60,80';
carrierDur='50';
carrierModRate='20';
carrierRampDur='0';
carrierFreq='2000';
preLevel='40';
preDur='200';
pmCF='4000';
pmBW='4000';

set(handles.setupExptBox,'Value',0);  % assume the experimenter wants to define expt parameters
set(handles.setupExptPanel,'Visible','off');
set(handles.setupExptBox,'Enable','off');
set(handles.carrierSettingsPanel,'Visible','on');
set(handles.preSettingsPanel,'Visible','on');
set(handles.pmPanel,'Visible','on');
handles.setupExptYN=0;

% Carrier Type panel
set(handles.CarrierTypeButtonPanel,'SelectedObject',handles.noiseRadioButton);
handles.stimParams.carrierType='noise';

% Spectral range of modulation panel
set(handles.fullSpectrumBox,'Value',fullSpectrumBox);
set(handles.partialSpectrumBox,'Value',partialSpectrumBox);
handles.stimParams.fullSpectrumToggle=0;
handles.stimParams.partialSpectrumToggle=partialSpectrumBox;

% precursor select panel
set(handles.noPrecursorBox,'Value',noPrecurrsorBox);
set(handles.noisePrecursorBox,'Value',noisePrecursorBox);
handles.stimParams.noPrecursorToggle=0;
handles.stimParams.noisePrecursorToggle=noisePrecursorBox;

% Carrier settings panel
set(handles.carrierLevel,'String',carrierLevel);
set(handles.carrierDur,'String',carrierDur);
set(handles.carrierModRate,'String',carrierModRate);
set(handles.carrierRampDur,'String',carrierRampDur);
set(handles.carrierFreq,'Enable','off');
handles.stimParams.carrierLevel=setStimParam_mod(carrierLevel);
handles.stimParams.carrierDur=setStimParam_mod(carrierDur);
handles.stimParams.carrierModRate=setStimParam_mod(carrierModRate);
handles.stimParams.carrierRampDur=setStimParam_mod(carrierRampDur);
handles.stimParams.carrierFreq=setStimParam_mod(carrierFreq);

% precursor settings panel
set(handles.preLevel,'String',preLevel);
set(handles.preDuration,'String',preDur);
handles.stimParams.preLevel=setStimParam_mod(preLevel);
handles.stimParams.preDur=setStimParam_mod(preDur);

% partial modulation settings
set(handles.pmCF,'String',pmCF);
set(handles.pmBW,'String',pmBW);
handles.stimParams.pmCF=setStimParam_mod(pmCF);
handles.stimParams.pmBW=setStimParam_mod(pmBW);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes registerSubject_mod wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = registerSubject_mod_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.subID;

delete(handles.figure1);


function subjectEdit_Callback(hObject, eventdata, handles)
% hObject    handle to subjectEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjectEdit as text
%        str2double(get(hObject,'String')) returns contents of subjectEdit as a double

handles.subID = get(hObject, 'String');
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function subjectEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in subject_pushbutton1.
function subject_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to subject_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.setupExptYN
    % column labels for a table that will show all conditions in experiment
    tblheader={'CarrierType' 'CarrierLevel(dB SPL)' 'CarrierDuration (sec)'...
        'CarrierFrequency (Hz)' 'CarrierModRate (Hz)' 'CarrierRampDur (sec)' 'preToggle'...
        'PreLevel (dB SPL)' 'preDuration (sec)' 'partialSpecModToggle'...
        'partialModCF' 'partialModBW'};
    
    % set up toggle conditions.  Toggle combinations are as follows
    % noPrecursorToggle noisePrecursorToggle
    %       0                   1    % runs both conditions
    %       0                   0    % runs only the no precursor condition
    %       1                   1    % runs only the precursor condition
    
    handles.stimParams.preToggle=unique([handles.stimParams.noPrecursorToggle;...
        handles.stimParams.noisePrecursorToggle]);
    handles.stimParams.pmToggle=unique([handles.stimParams.fullSpectrumToggle;...
        handles.stimParams.partialSpectrumToggle]);
    
    % set field names to be consistent with write_parameters_mod.m
    handles.stimParams.sigLevel=handles.stimParams.carrierLevel;
    handles.stimParams.dur=handles.stimParams.carrierDur;
    handles.stimParams.fc=handles.stimParams.carrierFreq;
    handles.stimParams.fm=handles.stimParams.carrierModRate;
    handles.stimParams.ramp=handles.stimParams.carrierRampDur;
    
    % vectors to be inputted in to combvec
    v01=handles.stimParams.sigLevel;
    v02=handles.stimParams.dur;
    v03=handles.stimParams.fc;
    v04=handles.stimParams.fm;
    v05=handles.stimParams.ramp;
    v06=handles.stimParams.preToggle;
    v07=handles.stimParams.preLevel;
    v08=handles.stimParams.preDur;
    v09=handles.stimParams.pmToggle;
    v10=handles.stimParams.pmCF;
    v11=handles.stimParams.pmBW;
    tblbody=CombVec(v01',v02',v03',v04',v05',v06',v07',v08',v09',v10',v11');
    tbl1strow=repmat(handles.stimParams.carrierType,size(tblbody,2),1);
    
    %allow the user to review the conditions before saving
    f1=figure;
    set(f1,'Name','Close this figure to continue...');
    set(f1,'Units','Inches','Position',[.1 3 12 5]);
    t1=uitable(f1,'Data',tblbody,'ColumnName',tbl1strow,'RowName',tblheader(2:end),'Units','Normalized','Position',[.05 .01 .9 .99]);
    msgbox('Close the table to continue...');
    % - close the figure...
    waitfor(f1);
    
    % make a directory and write the condition files
    DataPath=[cd '\Data\'];
    SubjPath=[DataPath handles.subID '\'];
    mkdir(DataPath,handles.subID);
    mkdir(SubjPath,'TestFiles');
    mkdir(SubjPath,'DataFiles');
    
    % make a structure to hold information about the experiment
    ExptInfo.fnames=cell(size(tblbody,2),1);
    ExptInfo.fcompleteYN=zeros(size(tblbody,2),1);
    rand('seed', sum(100*clock));
    %ExptInfo.forder=randsample(size(tblbody,2),size(tblbody,2));
    %code above replace with randperm on 7-20-15
    ExptInfo.forder=randperm(size(tblbody,2));
    ExptInfo.Name=[handles.subID 'ExptInfo'];
    ExptInfo.Table={tblheader tbl1strow tblbody};
    
    
    % hard coded parameters
    ExptInfo.nStoreBlocks=2;
    ExptInfo.Thresholds=zeros(ExptInfo.nStoreBlocks,size(tblbody,2));
    ExptInfo.StdDev=zeros(ExptInfo.nStoreBlocks,size(tblbody,2));
    
    % write each file and place in TestFile directory
    for ncond=1:size(tblbody,2)
        % make the file name
        p01=handles.subID;
        p02=num2str(ncond);
        p03=tbl1strow(ncond,:);
        
        str_params=num2str(tblbody(:,ncond));
        delim=repmat('_',size(tblbody,1),1);
        params_delim=cellstr([[delim str_params]]);
        params_delim=[params_delim{:}];
        wspace_params=logical(isspace(params_delim));
        prem=params_delim(~wspace_params);
        
        handles.paramsFile=[p01 '_' p02 '_' p03 prem '.txt'];
        ExptInfo.fnames{ncond}=handles.paramsFile;
        
        % redefine handles.stimParams to reflect the current parameter set
        handles.stimParams.carrierType=tbl1strow(ncond,:);
        handles.stimParams.sigLevel=tblbody(1,ncond);
        handles.stimParams.dur=tblbody(2,ncond)/1000;
        handles.stimParams.fc=tblbody(3,ncond);
        handles.stimParams.fm=tblbody(4,ncond);
        handles.stimParams.ramp=tblbody(5,ncond);
        handles.stimParams.preToggle=tblbody(6,ncond);
        handles.stimParams.preLevel=tblbody(7,ncond);
        handles.stimParams.preDur=tblbody(8,ncond)/1000;
        handles.stimParams.pmToggle=tblbody(9,ncond);
        handles.stimParams.pmCF=tblbody(10,ncond);
        handles.stimParams.pmBW=tblbody(11,ncond);
        
        % write the file
        write_parameters_mod(handles,[SubjPath 'TestFiles']);
    end
    
    % save the structure containing experiment info.
    save([SubjPath ExptInfo.Name],'ExptInfo');   
    
else
end

guidata(hObject, handles);
uiresume;


% --- Executes on button press in noPrecursorBox.
function noPrecursorBox_Callback(hObject, eventdata, handles)
% hObject    handle to noPrecursorBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.noPrecursorBox,'Value',get(hObject,'Value'));
handles.stimParams.noPrecursorToggle=~get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in noisePrecursorBox.
function noisePrecursorBox_Callback(hObject, eventdata, handles)
% hObject    handle to noisePrecursorBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.noisePrecursorBox,'Value',get(hObject,'Value'));
handles.stimParams.noisePrecursorToggle=get(hObject,'Value');

if get(hObject,'Value')
    set(handles.preSettingsPanel,'Visible','on');
else
    set(handles.preSettingsPanel,'Visible','off');
end

guidata(hObject, handles);


% --- Executes on button press in fullSpectrumBox.
function fullSpectrumBox_Callback(hObject, eventdata, handles)
% hObject    handle to fullSpectrumBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.fullSpectrumBox,'Value',get(hObject,'Value'));
handles.stimParams.fullSpectrumToggle=~get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in partialSpectrumBox.
function partialSpectrumBox_Callback(hObject, eventdata, handles)
% hObject    handle to partialSpectrumBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.partialSpectrumBox,'Value',get(hObject,'Value'));
handles.stimParams.partialSpectrumToggle=get(hObject,'Value');

if get(hObject,'Value')
    set(handles.pmPanel,'Visible','on');
else
    set(handles.pmPanel,'Visible','off');
end

guidata(hObject, handles);



function pmCF_Callback(hObject, eventdata, handles)
% hObject    handle to pmCF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pmCFInput=get(hObject,'String');
handles.stimParams.pmCF=setStimParam_mod(pmCFInput);
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

pmBWInput=get(hObject,'String');
handles.stimParams.pmBW=setStimParam_mod(pmBWInput);
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



function preLevel_Callback(hObject, eventdata, handles)
% hObject    handle to preLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pLevelInput=get(hObject,'String');
handles.stimParams.preLevel=setStimParam_mod(pLevelInput);
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



function preDuration_Callback(hObject, eventdata, handles)
% hObject    handle to preDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pDurInput=get(hObject,'String');
handles.stimParams.preDur=setStimParam_mod(pDurInput);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function preDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function carrierLevel_Callback(hObject, eventdata, handles)
% hObject    handle to carrierLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cLevelInput=get(hObject,'String');
handles.stimParams.carrierLevel=setStimParam_mod(cLevelInput);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function carrierLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carrierLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function carrierDur_Callback(hObject, eventdata, handles)
% hObject    handle to carrierDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


cDurInput=get(hObject,'String');
handles.stimParams.carrierDur=setStimParam_mod(cDurInput);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function carrierDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carrierDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function carrierModRate_Callback(hObject, eventdata, handles)
% hObject    handle to carrierModRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cModRateInput=get(hObject,'String');
handles.stimParams.carrierModRate=setStimParam_mod(cModRateInput);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function carrierModRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carrierModRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function carrierRampDur_Callback(hObject, eventdata, handles)
% hObject    handle to carrierRampDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cRampInput=get(hObject,'String');
handles.stimParams.carrierRampDur=setStimParam_mod(cRampInput);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function carrierRampDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carrierRampDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function carrierFreq_Callback(hObject, eventdata, handles)
% hObject    handle to carrierFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cFreqInput=get(hObject,'String');
handles.stimParams.carrierFreq=setStimParam_mod(cFreqInput);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function carrierFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carrierFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setupExptBox.
function setupExptBox_Callback(hObject, eventdata, handles)
% hObject    handle to setupExptBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    set(handles.setupExptPanel,'Visible','on');
else
    set(handles.setupExptPanel,'Visible','off');
end

handles.setupExptYN=get(hObject,'Value');

guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of setupExptBox


% --- Executes when selected object is changed in CarrierTypeButtonPanel.
function CarrierTypeButtonPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in CarrierTypeButtonPanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

h_noiseButton=handles.noiseRadioButton;
h_pmPanel=handles.partialSpectrumBox;
h_selected=get(handles.CarrierTypeButtonPanel,'SelectedObject');

if h_noiseButton==h_selected
    set(handles.carrierFreq,'Enable','off');
    set(handles.modSpecturmPanel,'Visible','on');
    handles.stimParams.carrierType='noise';
    handles.stimParams.fullSpectrumToggle=get(handles.fullSpectrumBox,'Value');
    handles.stimParams.partialSpectrumToggle=get(handles.partialSpectrumBox,'Value');
    if get(h_pmPanel,'Value')
        set(handles.pmPanel,'Visible','on');
    else
        set(handles.pmPanel,'Visible','off');
    end
else
    set(handles.carrierFreq,'Enable','on');
    set(handles.pmPanel,'Visible','off');
    set(handles.modSpecturmPanel,'Visible','off');
    handles.stimParams.fullSpectrumToggle=0;
    handles.stimParams.partialSpectrumToggle=0;
    handles.stimParams.carrierType='tone';
    set(handles.carrierFreq,'String',num2str(handles.stimParams.carrierFreq));
end

guidata(hObject, handles);
