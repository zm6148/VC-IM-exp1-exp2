function varargout = tmodGUI(varargin)
% TMODGUI M-file for tmodGUI.fig
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
% Last Modified by GUIDE v2.5 08-Jun-2012 17:41:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tmodGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @tmodGUI_OutputFcn, ...
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


% --- Executes just before tmodGUI is made visible.
function tmodGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tmodGUI (see VARARGIN)

% Choose default command line output for tmodGUI
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
caldB=system.caldB;  %system calibration level for ER2 headphones routed through TDT SI Headphone Module
%Lynx sound card @ +4dBu and Ch. 3 fader set at -19 dB attenutation
%Lynx fader=-19; SPL=93.4; V=-4.69
handles.phones=system.phones;
%caldB=102.3; %max output of Sennheiser headphones [fader=-28; SPL=102.3]
setappdata(0,'caldB',caldB);       %save calibration level to GUI
calMsg=system.calStr;
set(handles.playCalTone,'Label',calMsg);
%---default values of editable parameters---------------------------------
handles.subID = 'subject';              %initial subject ID
handles.stimParams.carrierType='tone'; %carrier type 'noise', 'tone'
handles.stimParams.sigLevel=50;         %dB
handles.stimParams.dur=0.500;           %signal duration (s)
handles.stimParams.fc=1000;             %carrier frequency (Hz)
handles.stimParams.fm=40;               %modulator frequency (Hz)
handles.stimParams.M=1;                 %modulation depth (0-1)
handles.stimParams.ramp=0.01;          %sec
handles.stimParams.blockNum=0;          %total # of stored blocks

% features not fully developed... do not edit without enabling these
% features in selectStimParams_mod.m first
%%%%% all toggles are off %%%%%%%%%
handles.stimParams.carrierLNNToggle=0;
handles.stimParams.hpMaskerToggle=0;
handles.stimParams.preToggle=0;
handles.stimParams.pmToggle=0;

handles.stimParams.preLevel=40;
handles.stimParams.preDur=.200;
handles.stimParams.preDel=0.005;
handles.stimParams.preRamp=0.005;
handles.stimParams.preBW=[2000 8000];
handles.stimParams.preType='BBN/NBN';
handles.stimParams.precursorLNNToggle=0;
handles.stimParams.precursorCutoffs=[100 8000 0 0];
handles.stimParams.pmCF=4000;
handles.stimParams.pmBW=4000;
handles.stimParams.hpMaskerRamp=handles.stimParams.ramp;

handles.target=[];     %target signal

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
handles.run.nReversalConsider=10;  % # of reversals to consider for average

%handles.stimParams.noiseBW=[9.95/10 1.005].*handles.stimParams.fc;  %carrier cutoff frequencies
handles.stimParams.noiseBW=[100 8100];  %carrier cutoff frequencies
  
handles=getCarrierBW_SpecLvl(handles);

%High pass masker to minimize off-frequency listening [dbSPL = SL + 10log(BW)]
handles.stimParams.hpOffset=-50;%highpass masker level relative to the target
handles.stimParams.nrmlzCuttoff=[1/4 9/10 1.2 2];
handles.stimParams.hpCuttoff=handles.stimParams.nrmlzCuttoff*handles.stimParams.fc;

if length(handles.stimParams.hpCuttoff)==4
    handles.stimParams.hpBW=[handles.stimParams.hpCuttoff(2)-handles.stimParams.hpCuttoff(1)] + [handles.stimParams.hpCuttoff(4)-handles.stimParams.hpCuttoff(3)];
else
    handles.stimParams.hpBW=handles.stimParams.hpCuttoff(2)-handles.stimParams.hpCuttoff(1);
end

handles=setHPLevel(handles);

handles.run.ISI=0.400;            %sec
handles.run.stepSize.initial=8;   %initial step size (dB)
handles.run.stepSize.final=2;     %final step size (dB)
handles.stimParams.GUIpath=varargin{3};

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

% UIWAIT makes tmodGUI wait for user response (see UIRESUME)
% uiwait(handles.tmodGUI_FIG);


% --- Outputs from this function are returned to the command line.
function varargout = tmodGUI_OutputFcn(hObject, eventdata, handles) 
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
[output1 subID] = registerSubject_mod(handles.subID); %calls register subject window
handles.subID=[subID '_' date];                   %append data
tempstring = strcat('Subject: ', handles.subID);
set(handles.confirmSubID, 'String', tempstring);
guidata(hObject, handles);


function runGUI_Callback(hObject, eventdata, handles)
% hObject    handle to runGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.blocks)
    msgbox('please add at least one block of conditions before running.');
else
    [output handles] = responseWindow_mod(handles); %brings up repsonse window to run experiment
end


function defineParams_Callback(hObject, eventdata, handles)
% hObject    handle to defineParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[output1 handles.stimParams handles.blocks] = selectStimParams_mod(handles.stimParams,handles.blocks); %brings up stimulus select window
if getappdata(findall(0,'tag','tmodGUI_FIG'),'exitFlag')==1
    return;
elseif isempty(handles.stimParams)
    return;
end

[handles buffer]=makeStim_mod(handles); %creates stimulus from user defined parameters

plotStim_mod(handles,buffer);
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
% hObject    handle to playCalTone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear playsnd;
dur=30; %duration of test tone (sec)
calref=0.4; %need to adjust the amplitude of testTone depending on the value for "ref"
%in amp2db.m. (i.e. calref and ref should be equal) 
A=calref*sqrt(2);
testTone=A.*sin(2*pi*1000*linspace(0,dur,handles.Fs*dur)); 


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
sig=scale2db_mod(handles.stim,70,handles.phones,handles.Fs);
sound(sig,handles.Fs,handles.bits);  %present binaural

set(hObject,'Value',0);


% --- Executes when user attempts to close tmodGUI_FIG.
function tmodGUI_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to tmodGUI_FIG (see GCBO)
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
