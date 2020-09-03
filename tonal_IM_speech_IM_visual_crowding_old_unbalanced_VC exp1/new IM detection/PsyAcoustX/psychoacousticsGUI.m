function varargout = psychoacousticsGUI(varargin)
% PSYCHOACOUSTICSGUI MATLAB code for psychoacousticsGUI.fig
%   GUIs for Psychophyscoacoustic Research
%   %------------------------------------------
%   This GUI allows one to select from a number of typical psychoacoustic
%   paradigms:
%        -Masking (type help MaskingGUI)
%        -SAM (type help samGUI)         
%        -Pitch (type help pitchGUI)
%
%   Response are collected via mouse button press or the numpad buttons '1-3'.
%   The GUI uses adpative tracking rule (2-1) in a 3AFC task.
%           
% © Gavin Bidelman, PhD [gbidelman@rotman-baycrest.on.ca]; Rotman Research Institute, August 2011
%
% Last Modified by GUIDE v2.5 30-Jun-2011 15:21:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @psychoacousticsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @psychoacousticsGUI_OutputFcn, ...
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


% --- Executes just before psychoacousticsGUI is made visible.
function psychoacousticsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to psychoacousticsGUI (see VARARGIN)

% lines below test code without toolboxes
% rmpath(genpath([matlabroot '\toolbox\wavelet'])) ;
% rmpath(genpath([matlabroot '\toolbox\stats'])) ;
% rmpath(genpath([matlabroot '\toolbox\optim'])) ;
% rmpath(genpath([matlabroot '\toolbox\nnet'])); 
% rmpath(genpath([matlabroot '\toolbox\images']));

% find out if any GUIs are open from previous sessions and close them
c0=get(0,'Children');
for numChild=1:length(c0)
    currChild=c0(numChild);
    nameChild=get(currChild,'name');
    if strcmp(nameChild,get(hObject,'name'))
    else
        hFig=findall(0,'name',nameChild);
        delete(hFig);
    end
end

% load systemInfo.m
load('systemInfo.mat');
% Choose default command line output for psychoacousticsGUI
handles.output = hObject;
handles.GUIpath=cd;

GUIpathDir=dir(handles.GUIpath);
GUIpathName={GUIpathDir.name};
evalDir=strcmp('psychoacousticsGUI.m',GUIpathName);
if sum(evalDir)==0
    error('The root directory must contain the file ''psychoacousticsGUI.m''');
else
end

if system.calRemindYN
    hmsgbox=msgbox(system.calRemindStr,'Set-up reminder','warn');
    waitfor(hmsgbox);
else
end

% Update handles structure
guidata(hObject, handles);

movegui(hObject,'center'); %centers GUI on screen


% UIWAIT makes psychoacousticsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = psychoacousticsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in expSelect.
function expSelect_Callback(hObject, eventdata, handles)
% hObject    handle to expSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String')); %returns expSelect contents as cell array
choice=contents{get(hObject,'Value')};

if strcmp(choice,'Masking')
    restoredefaultpath;
    addpath(genpath(fullfile(cd, 'MaskingGUI')));
    MaskingGUI;    
elseif strcmp(choice,'Gap detection')
    restoredefaultpath;
    addpath(genpath(fullfile(cd, 'GapGUI')));
    gapGUI;
elseif strcmp(choice,'Temporal modulation')
    restoredefaultpath;
    addpath(genpath(fullfile(cd, 'SAM GUI')));
    tmodGUI(hObject,eventdata,handles.GUIpath);
elseif strcmp(choice,'Increment/Decrement')
    restoredefaultpath;
    addpath(genpath(fullfile(cd, 'IncDecGUI')));
    IncDecGUI;
end

guidata(hObject,handles);
close(gcbf);


% --- Executes during object creation, after setting all properties.
function expSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
