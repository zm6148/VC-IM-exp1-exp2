function varargout = MaskingGUI(varargin)
% MASKINGGUI M-file for MaskingGUI.fig
%
%   Masking GUI for Psychophyscoacoustic Research
%   %------------------------------------------
%   This GUI is capable of implementing typical masking paradigms
%   and includes the following features:
%        -forward masking (tone or noise masker)
%        -simultaneous masking           
%        -notched noise masking
%        -high pass noise masker to minimize off-frequency listening
%        -precursor
%        -supression
%        -threshold signal measurment in quiet
%        -storage & loading of multiple stimulus blocks
%
%   The GUI uses adpative tracking rule (2-1) in a 3AFC task.
%           
% © Gavin Bidelman, PhD [gbidelma@purdue.edu]; Purdue University, June 2011
% Last Modified by GUIDE v2.5 27-Jun-2012 09:22:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MaskingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MaskingGUI_OutputFcn, ...
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


% --- Executes just before MaskingGUI is made visible.
function MaskingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MaskingGUI (see VARARGIN)

% Choose default command line output for MaskingGUI
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

% Initialize GUI variables (most parameters can be changed during stimulus selection)------------------
caldB=system.caldB;
handles.caldB=system.caldB; 
handles.phones=system.phones;
%caldB=102.3; %max output of Sennheiser headphones [fader=-28; SPL=102.3]
setappdata(0,'caldB',caldB);       %save calibration level to GUI
calMsg=system.calStr;
set(handles.playCalTone,'Label',calMsg);

%---default values of editable parameters---------------------------------
handles.subID = 'subject';         %initial subject ID
handles.stimParams.delay=0;        %sec (simult.=delay btw onset of masker & target; forward=delay btw masker offset & target onset)
handles.stimParams.preToggle=0;    %precursor toggle (default is off)
handles.stimParams.preType='tone'; %precursor type ('tone' or 'noise')
handles.stimParams.preFreq=1000;   %frequency for tonal precursor
handles.stimParams.preDur=0.200;   %precursor duration (s)
handles.stimParams.preLevel=50;    %dB
handles.stimParams.preRamp=0.005;   %sec
handles.stimParams.preDelay=0;     %sec; delay between end of precursor and masker

handles.stimParams.maskerType='forward'; %masker type 'simultaneous' or 'forward'
handles.stimParams.maskerSig='tone';    %masker signal: 'tone'=pure tone; 'noise'=broadband noise

handles.stimParams.hpMaskerToggle=0;     %highpass masker to minimize off-frequency listening (0=off, 1=on)
handles.stimParams.hpMaskerRamp=0.005;   %highpass masker ramp (sec)

handles.stimParams.maskerFreq=1000;      %Hz; only used when masker is tone, not noise
handles.stimParams.maskerDur=0.500;      %sec
handles.stimParams.notchToggle=0;        %notched noise toggle (0=off, 1=on)
handles.stimParams.maskerCutoffs=[100 2500 5500 8000]; %masker cutoffs for notched noise
handles.stimParams.maskerLevel=50;       %dB
handles.stimParams.maskerRamp=0.005;      %sec

handles.stimParams.supToggle=0;     %suppressor toggle (default is off)
handles.stimParams.supFreq=1200;    %frequency of suppressor
handles.stimParams.supDur=handles.stimParams.maskerDur;   %supressor duration (sec)
handles.stimParams.supDelay=0;      %(sec) delay from stim onset (after buffer) to start of suppressor
handles.stimParams.supLevel=60;     %dB
handles.stimParams.supRamp=0.005;   %sec

handles.stimParams.targetLevel=50;  %dB
handles.stimParams.targetFreq=1000; %Hz
handles.stimParams.targetDur=0.01;  %sec
handles.stimParams.targetAlone=0;   %1=masker off, search target threshold
handles.stimParams.trackTarget=0;   %0=track masker (default); 1=track target
handles.stimParams.targetRamp=0.005; %sec

handles.stimParams.blockNum=0;      %total # of stored blocks

handles.precursor=[];  %precursor signal
handles.suppressor=[]; %suppressor signal
handles.noise=[];      %masker signal
handles.target=[];     %target signal

handles.blocks=[];                %stored blocks w/ all parameters
handles.run.currentBlockNum=1;    %current block #

handles.run.resp=[];              %0=incorrect response; 1=correct response
handles.run.levels=[];            %vector of levels tested

handles.resultsFile='test.txt';
handles.paramsFile='params.txt';
%------------------------------------------------------------------------

%--Hard coded parameters-----------------------------------------
handles.Fs=system.Fs;                %sample rate
handles.bits=system.bits;               %bit depth (card also has 24 or 32, but only max 16 bits work with MATLAB's sound command)
handles.earPres='R';              %mode of presenation (RE alone = 'R'; LE alone = 'L'; binaural  = 'B')
handles.run.nReversals=12;         % # of reversals to track
handles.run.nReversalConsider=8;  % # of reversals to consider for average
handles.stimParams.hpMaskerCutoffNrmlz=1.2;
handles.stimParams.hpCutUpper=10000;


handles.stimParams.maskerBW=[100 8000];  %masker cutoff frequencies for broadband masker

handles.run.ISI=0.500;            %sec
handles.run.stepSize.initial=5;   %initial step size (dB)
handles.run.stepSize.final=2;     %final step size (dB)
setappdata(hObject,'exitFlag',0); %used to exit program when all conditions are completed in an experiment  

%High pass masker to minimize off-frequency listening [dbSPL = SL + 10log(BW)]
handles.stimParams.hpMaskerOffset=-50; % set to level desired relative to probe.
handles=setHPMaskerBWLvl(handles); % update hp masker bw and level   
%---------------------------------------------------------------

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

% UIWAIT makes MaskingGUI wait for user response (see UIRESUME)
% uiwait(handles.MaskingGUI_FIG);


% --- Outputs from this function are returned to the command line.
function varargout = MaskingGUI_OutputFcn(hObject, eventdata, handles) 
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
defaultSettings.subID=handles.subID;
defaultSettings.stimParams=handles.stimParams;
[output1 subID] = registerSubject(defaultSettings); %calls register subject window

if isempty(subID)
else    
    handles.subID=[subID '_' date];                   %append data
    tempstring = strcat('Subject: ', handles.subID);
    set(handles.confirmSubID, 'String', tempstring);
    guidata(hObject, handles);
end


function runGUI_Callback(hObject, eventdata, handles)
% hObject    handle to runGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.blocks)
    msgbox('please add at least one block of conditions before running.');
else
    [output handles] = responseWindow(handles); %brings up repsonse window to run experiment
end

function defineParams_Callback(hObject, eventdata, handles)
% hObject    handle to defineParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[output1 handles.stimParams handles.blocks] = selectStimParams(handles.stimParams,handles.blocks); %brings up stimulus select window
if getappdata(findall(0,'tag','MaskingGUI_FIG'),'exitFlag')==1
    return;
elseif isempty(handles.stimParams)
    return;
end

[handles maskerTargetDelay buffer]=makeStim(handles); %creates stimulus from user defined parameters

if isempty(handles.blocks) %always store at least one block
    handles.blocks{1}=handles.stimParams;
end

plotStim(handles,buffer,maskerTargetDelay);
set(handles.playTestSound, 'Enable', 'On');set(handles.plotSpectrogram, 'Enable', 'On'); %enable test playback & plotting
guidata(hObject, handles);


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
calref=0.4; %need to adjust the amplitude of testTone depending on the value for "ref"
%in amp2db.m. (i.e. calref and ref should be equal) 
A=calref*sqrt(2);
testTone=A.*sin(2*pi*1000*linspace(0,dur,handles.Fs*dur)); 
testTone=scale2db(testTone,handles.caldB,handles.phones,handles.Fs);

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
sig=scale2db(handles.stim,70,handles.phones,handles.Fs);
sound(sig,handles.Fs,handles.bits);  %present binaural

set(hObject,'Value',0);


% --- Executes when user attempts to close MaskingGUI_FIG.
function MaskingGUI_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MaskingGUI_FIG (see GCBO)
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
% clear all; close all; clc;
% psychoacousticsGUI;


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
