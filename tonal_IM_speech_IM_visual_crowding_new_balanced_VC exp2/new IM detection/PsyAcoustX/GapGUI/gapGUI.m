function varargout = gapGUI(varargin)
% GAPGUI M-file for gapGUI.fig
%
%   TEMPORAL MODULATION GUI for Psychophyscoacoustic Research
%   %------------------------------------------
%   This GUI is capable of implementing a typical SAM detection paradigm
%   which may be used, for example, to construct a subject's TMTF.
%
%   Response are collected via mouse button press or the numpad buttons '1-3'.
%   The GUI uses adpative tracking rule (2-1) in a 3AFC task.
%           
% © Gavin Bidelman, PhD [gbidelma@purdue.edu]; Purdue University, June 2011
% Last Modified by GUIDE v2.5 19-Dec-2013 13:28:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gapGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @gapGUI_OutputFcn, ...
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


% --- Executes just before gapGUI is made visible.
function gapGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gapGUI (see VARARGIN)

% Choose default command line output for gapGUI
handles.output = hObject;

set(0,'ShowHiddenHandles','on','defaultlinelinewidth',1'); %allow clearing of GUI figure and set default linewidth

%--intialize main window appearance------------------------------
set(handles.stimPlot, 'Visible', 'off'); 
set(handles.playTestSound, 'Enable', 'Off');   %disable playing of test sound until params are set/confirmed
set(handles.plotSpectrogram, 'Enable', 'Off'); %disable plotting...
movegui(hObject,'center'); %centers GUI on screen
%axes(findall(0,'tag','logo'));imshow('purdueTrainLogo.tif'); %logo
%axes(findall(0,'tag','seal'));imshow('purdueSeal.bmp');      %logo
%-----------------------------------------------------------------

% load the systemInfo.mat file
load('systemInfo.mat');

set(handles.runGUI,'Enable','off');

% Initialize GUI variables (most parameters can be changed during stimulus selection)------------------
caldB=system.caldB;  %system calibration level for ER2 headphones routed through TDT SI Headphone Module
phones=system.phones; % currently only EAR5A and ER2 are supported...
%Lynx sound card @ +4dBu and Ch. 3 fader set at -19 dB attenutation
%Lynx fader=-19; SPL=93.4; V=-4.69
handles.caldB=caldB;
handles.phones=phones;
%caldB=102.3; %max output of Sennheiser headphones [fader=-28; SPL=102.3]
setappdata(0,'caldB',caldB);       %save calibration level to GUI
calMsg=system.calStr;
set(handles.playCalTone,'Label',calMsg);
%---default values of editable parameters---------------------------------
handles.subID = 'subject';              %initial subject ID

% marker defaults
handles.stimParams.markerLevel=50;      %marker level
handles.stimParams.dur=0.500;           %marker duration (s)
handles.stimParams.ramp=0.01;
handles.stimParams.markerGapRamp=0.002;
handles.stimParams.markerLNNToggle=0;
handles.stimParams.markerType='BBN';
handles.stimParams.markerCutoffs= [100 8100];

% Gap defaults
handles.stimParams.gapCenterLoc=0.5; % default is center of the marker (50%)
handles.stimParams.initialGapDur=0.01; % default gap duration (sec)
handles.stimParams.TrackOffsetYN=0; % default to track on gap duration, not SNR

% Background noise defaults
handles.stimParams.bnoiseToggle=0;      %present background noise?
handles.stimParams.bnoiseType='BBN';  %background noise type
handles.stimParams.bnoiseDur=handles.stimParams.dur; % background noise is gated with the marker
handles.stimParams.bnoiseRamp=handles.stimParams.ramp;
handles.stimParams.bnoiseLNNToggle=0;
handles.stimParams.bnoiseOffset=-25;     %offset (in dB) between marker and background noise
handles.stimParams.bnoiseCutoffs= [100 8100];
handles.stimParams.bnoiseBW=gapCalcBW(handles.stimParams.bnoiseCutoffs);
handles.stimParams.bnoiseLevel=...
    handles.stimParams.markerLevel+handles.stimParams.bnoiseOffset+10*log10(handles.stimParams.bnoiseBW); % in spectrum level

% Precursor defaults
handles.stimParams.precursorToggle=0;   %present a precursor?
handles.stimParams.precursorLevel=50;
handles.stimParams.precursorDur=0.500;    %precursor duration
handles.stimParams.precursorType='BBN';
handles.stimParams.precursorLNNToggle=0;
handles.stimParams.precursorGap=0;      %length of silent interval between precursor and marker
handles.stimParams.precursorRamp=handles.stimParams.ramp;
handles.stimParams.precursorCutoffs= [100 8100];

handles.stimParams.blockNum=0;          %total # of stored blocks

% handles.target=[];                      %target signal

handles.blocks=[];                %stored blocks w/ all parameters
handles.run.currentBlockNum=1;    %current block #

handles.run.resp=[];              %0=incorrect response; 1=correct response
handles.run.levels=[];            %vector of levels tested

handles.resultsFile='test.txt';
handles.paramsFile='params.txt';
%------------------------------------------------------------------------

%--Hard coded parameters-----------------------------------------
handles.Fs=system.Fs;                 %sample rate
handles.bits=system.bits;                  %bit depth (card also has 24 or 32, but only max 16 bits work with MATLAB's sound command)
handles.earPres='R';              %mode of presenation (RE alone = 'R'; LE alone = 'L'; binaural  = 'B')
handles.run.nReversals=12;        % # of reversals to track
handles.run.nReversalConsider=8;  % # of reversals to consider for average

handles.stimParams.noiseBW=[80 20000];  %masker cutoff frequencies for broadband masker

handles.run.ISI=0.400;            %sec
handles.run.stepSize.initial=50;   %initial step size (sec)
handles.run.stepSize.final=50;
handles.run.stepSize.factor=1.4;     %the change in gap size from the previous trial (1.4 was used by Shailer and Moore, 1983) 

if length(varargin)>=3
    handles.stimParams.GUIpath=varargin{3};
else
    handles.stimParams.GUIpath=cd;
end

% Hide the command window and offer option to run a testing mode in which
% the number of reversals is reduced for quick assessement.
handles.Mode=system.mode;
CWHideYN=system.hide;

if handles.Mode
    handles.run.nReversals=2;
    handles.run.nReversalConsider=2;
    CWHideYN=0;
else
end

cw = com.mathworks.mlservices.MatlabDesktopServices.getDesktop.getMainFrame;

if CWHideYN
    cw.setVisible(0);
else
    cw.setState(cw.ICONIFIED);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gapGUI wait for user response (see UIRESUME)
% uiwait(handles.gapGUI_FIG);


% --- Outputs from this function are returned to the command line.
function varargout = gapGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function enroll_Callback(hObject, eventdata, handles)
% hObject    handle to enroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[output1 subID] = registerSubject_IncDec(handles.subID); %calls register subject window
handles.subID=[subID '_' date];                   %append data
tempstring = strcat('Subject: ', handles.subID);
set(handles.confirmSubID, 'String', tempstring);
guidata(hObject, handles);


function runGUI_Callback(hObject, eventdata, handles)
% hObject    handle to runGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[output handles] = responseWindow_gap(handles); %brings up repsonse window to run experiment


function defineParams_Callback(hObject, eventdata, handles)
% hObject    handle to defineParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[action, handles.stimParams, handles.blocks] = selectStimParams_gap(handles.stimParams,handles.blocks); %brings up stimulus select window

switch(action)
    case 'continue'  
        
        [handles, buffer]=makeStim_gap(handles,1); %creates stimulus from user defined parameters.  Second argument tells program to make the example with a gap (as opposed to without the gap)        
        plotStim_gap(handles,buffer);
        set(handles.playTestSound, 'Enable', 'On');set(handles.plotSpectrogram, 'Enable', 'On'); %enable test playback & plotting
        set(handles.runGUI,'enable','on');
        guidata(hObject, handles);
        
    case 'deleteFIG'
    otherwise
end


% --- Executes on button press in plotSpectrogram.
function plotSpectrogram_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of plotSpectrogram

plotStimSpectrogam(handles); %uncomment to check plot of stimlus spectrogram 
set(hObject,'Value',0);
    

function playCalTone_Callback(hObject, eventdata, handles)
% hObject    handle to playCalTone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear playsnd;
dur=30; %duration of test tone (sec)

testTone=sin(2*pi*1000*linspace(0,dur,handles.Fs*dur)); %1kHz test tone at 0.707 RMS
testTone=scale2db_gap(testTone,handles.caldB,handles.phones.handles.Fs);

%---choose which ear to present to------------------
if strcmp(handles.earPres,'L')
    sound([zeros(1,length(testTone));testTone]',handles.Fs,handles.bits); %present monaural RE alone
elseif strcmp(handles.earPres,'R')
    sound([testTone;zeros(1,length(testTone))]',handles.Fs,handles.bits); %present monaural LE alone
else %default is both
    sound([testTone;testTone]',handles.Fs,handles.bits);  %present binaural
end
%--------------------------------------------------


% --------------------------------------------------------------------
function saveData_Callback(hObject, eventdata, handles)
% hObject    handle to saveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%save data menu will be largely unused; data is automatically saved after each block
results_pathname=fullfile(pwd,'Data',[handles.subID '.txt']); %results file is subject's name/date
write_header(handles,results_pathname);                %header of results file w/ stimulus info
write_results(handles,results_pathname);               %write results
fclose('all'); 
disp(['Data file location: ' results_pathname]);       


% --- Executes on button press in playTestSound.
function playTestSound_Callback(hObject, eventdata, handles)
% hObject    handle to playTestSound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of playTestSound

clear playsnd
sig=scale2db_gap(handles.stim,70,handles.phones,handles.Fs);
sound(sig,handles.Fs,handles.bits);  %present binaural
set(hObject,'Value',0);


% --- Executes when user attempts to close gapGUI_FIG.
function gapGUI_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to gapGUI_FIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure

%clear all app data---------
app=getappdata(0); 
appdatas = fieldnames(app);
for k = 1:length(appdatas)
  rmappdata(0,appdatas{k});
end
%-------------------------
delete(get(0,'Children')); 
h = com.mathworks.mlservices.MatlabDesktopServices.getDesktop.getMainFrame;
h.setVisible(1);



%---These functions are used by the GUI but we dont need to touch them----------------
function confirmSubID_Callback(hObject, eventdata, handles)
% hObject    handle to confirmSubID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of confirmSubID as text
%        str2double(get(hObject,'String')) returns contents of confirmSubID as a double

function stimulusMenu_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function runMenu_Callback(hObject, eventdata, handles)
% hObject    handle to runMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function subjectMenu_Callback(hObject, eventdata, handles)
% hObject    handle to subjectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function confirmSubID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to confirmSubID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function calMenu_Callback(hObject, eventdata, handles)
% hObject    handle to calMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%----------------------------------------------------------------------------
