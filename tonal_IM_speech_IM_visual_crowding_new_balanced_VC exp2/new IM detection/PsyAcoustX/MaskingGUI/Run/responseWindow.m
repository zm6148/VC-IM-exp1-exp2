function varargout = responseWindow(varargin)
% RESPONSEWINDOW M-file for responseWindow.fig
%      RESPONSEWINDOW, by itself, creates a new RESPONSEWINDOW or raises the existing
%      singleton*.
%
%      H = RESPONSEWINDOW returns the handle to a new RESPONSEWINDOW or the handle to
%      the existing singleton*.
%
%      RESPONSEWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPONSEWINDOW.M with the given input arguments.
%
%      RESPONSEWINDOW('Property','Value',...) creates a new RESPONSEWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before responseWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to responseWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help responseWindow

% Last Modified by GUIDE v2.5 23-Jul-2013 09:32:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @responseWindow_OpeningFcn, ...
    'gui_OutputFcn',  @responseWindow_OutputFcn, ...
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


% --- Executes just before responseWindow is made visible.
function responseWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to responseWindow (see VARARGIN)

% Choose default command line output for responseWindow
handles.output = hObject;
movegui(hObject,'center')
handles = varargin{1};

%--turn off response buttons until experiment starts--
set(findall(0,'tag','button1'),'enable','off');
set(findall(0,'tag','button2'),'enable','off');
set(findall(0,'tag','button3'),'enable','off');
%--------------------------------------------

% turn on the button that allows the subject to play an example stimulus
set(findall(0,'tag','playExample'),'Visible','on');

% open the status window and position the response window  ---------------%
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

set(findall(0,'tag','responseWindow_FIG'),'Position',newWinPos);

% minimize the maskingGUI figure to prevent the subject from altering
% settings of maskingGUI
set(handles.MaskingGUI_FIG,'Visible','off');

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = responseWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles;


% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('button #1 pressed');
setappdata(0,'buttonPressed',1);
uiresume




% --- Executes on button press in button2.
function button2_Callback(hObject, eventdata, handles)
% hObject    handle to button2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('button #2 pressed');
setappdata(0,'buttonPressed',2);
uiresume


% --- Executes on button press in button3.
function button3_Callback(hObject, eventdata, handles)
% hObject    handle to button3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('button #3 pressed');
setappdata(0,'buttonPressed',3);
uiresume


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(' ');
disp('+++++++++++++++++++++++++++++++++++++++++++++++ ');
disp(['Running block ' num2str(handles.run.currentBlockNum) ' of ' num2str(handles.stimParams.blockNum)]); %print what block is running
disp('+++++++++++++++++++++++++++++++++++++++++++++++ ');
set(findall(0,'tag','playExample'),'Visible','off'); % disable the playExample button when the run starts

[levels, trial, resps,reversalLevels,reversalBool,thresh, stdThresh, exitFlagLvl, handles] = runExperiment(handles);

setappdata(0,'levels',levels);
setappdata(0,'trial',trial);
setappdata(0,'resps',resps);
setappdata(0,'reversalLevels',reversalLevels);
setappdata(0,'reversalBool',reversalBool);
setappdata(0,'thresh',thresh);
setappdata(0,'stdThresh',stdThresh);

%-----------------------------------------------
handles.levels=levels;
handles.trial=trial;
handles.resps=resps;
handles.thresh=thresh;
handles.stdThresh=stdThresh;
handles.run.currentBlockNum=handles.run.currentBlockNum+1; %update block #

if exitFlagLvl==1 % exit if level is at the limits of equipment
    close(gcbf);
    
    thresh=Inf;
    stdThresh=0;
    if handles.stimParams.RunExpt.YN
        %%% get the pathname for the current condition
        results_pathname=fullfile(handles.stimParams.RunExpt.SaveDir,[handles.stimParams.RunExpt.SaveFile '.txt']);
        MatFilePath=[handles.stimParams.RunExpt.SubjDir handles.stimParams.RunExpt.MatFile];
        load(MatFilePath);
        saveIndx=find(strcmp(ExptInfo.fnames,[handles.stimParams.RunExpt.SaveFile '.txt'])==1);
        ExptInfo.Thresholds(handles.run.currentBlockNum-1,saveIndx)=thresh;
        ExptInfo.StdDev(handles.run.currentBlockNum-1,saveIndx)=stdThresh;
        ExptInfo.fcompleteYN(saveIndx)=1; % update the .mat file
        save(MatFilePath,'ExptInfo'); % save the updated file
    else
        if  isfield(handles.stimParams.RunExpt,'singleFile')
            results_pathname=fullfile(handles.stimParams.RunExpt.singleFile,[handles.stimParams.RunExpt.SaveFile]);
        else
            results_pathname=fullfile(pwd,'Data',[handles.subID '.txt']); %results file is subject's name/date
        end
    end
    
    write_header(handles,results_pathname);  %header of results file with stimulus info
    write_results(handles,results_pathname); %write results
    mb1=msgbox({'Threshold exceeds maximum output.  Skipping this condition...'; 'Please restart the program to proceed to the next condition...'}...
        ,'Threshold exceeds maximum output.  Skipping this condition...');
    %set(mb1,'Units','normalized','Position',[0.1 0.1 .80 .80]);
    
    waitfor(mb1);
    clear all; close all; clc;
    
    return;
else
end

%-------save data automatically--------------------
% if running and experiment, save in the subject's data directory and
% update the .mat file that tracks what conditions have been completed

if handles.stimParams.RunExpt.YN
    %%% get the pathname for the current condition
    results_pathname=fullfile(handles.stimParams.RunExpt.SaveDir,[handles.stimParams.RunExpt.SaveFile '.txt']);
    MatFilePath=[handles.stimParams.RunExpt.SubjDir handles.stimParams.RunExpt.MatFile];
    load(MatFilePath);
    saveIndx=find(strcmp(ExptInfo.fnames,[handles.stimParams.RunExpt.SaveFile '.txt'])==1);
    ExptInfo.fcompleteYN(saveIndx)=1; % update the .mat file
    ExptInfo.Thresholds(handles.run.currentBlockNum-1,saveIndx)=thresh;
    ExptInfo.StdDev(handles.run.currentBlockNum-1,saveIndx)=stdThresh;
    save(MatFilePath,'ExptInfo'); % save the updated file
else
    if  isfield(handles.stimParams.RunExpt,'singleFile')
        results_pathname=fullfile(handles.stimParams.RunExpt.singleFile,[handles.stimParams.RunExpt.SaveFile]);
    else
        results_pathname=fullfile(pwd,'Data',[handles.subID '.txt']); %results file is subject's name/date
    end
end

write_header(handles,results_pathname);  %header of results file with stimulus info
write_results(handles,results_pathname); %write results
fclose('all');
disp(['Data written to : ' results_pathname]);
%------------------------------------------------

% -------- prompt the user to run the next condition if running expt
% if not running an experiment, this button would normally display "close"

if handles.stimParams.RunExpt.YN
    set(findall(0,'tag','closeRespWinButton'),'String','NEXT','ForegroundColor','b'); %turn on "NEXT" button
else
end
guidata(hObject, handles);



% --- Executes on button press in plotRespButton.
function plotRespButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotRespButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotRespTrack(handles.trial,handles.levels,handles.resps,handles.thresh,handles.stdThresh); %plot response track


% --- Executes on button press in closeRespWinButton.
function closeRespWinButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeRespWinButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% -- if the button displays NEXT, run the next condition.
% -- if the buttons displays CLOSE, restart the GUI
if handles.stimParams.RunExpt.YN
    h_RWFIG=findall(0,'Tag','responseWindow_FIG');
    set(findall(0,'tag','closeRespWinButton'),'Visible','off');
    close(h_RWFIG); % close the responseWindow GUI
    
    %-- update .xls file
    writeData2xls(handles.stimParams.RunExpt);
    
    %-- run the next condition my calling the "defineParams" callback in
    %-- tmodGUI.m
    
    h_defineParams=findall(0,'tag','defineParams'); % get the defineParams object handle
    hCBdefineParams=get(h_defineParams,'Callback'); % get the defineParams callback handle
    feval(hCBdefineParams,h_defineParams,handles);  % execute the defineParams callback function
    
    if getappdata(findall(0,'tag','MaskingGUI_FIG'),'exitFlag')==1;
        close all; clear all; clc;
        MaskingGUI;
    else
        [output1 handles.stimParams handles.blocks]=selectStimParams(handles.stimParams,handles.blocks); % call selectStimParams to update stimParams and blocks
        h_tmodFIG=findall(0,'Tag','MaskingGUI_FIG');
        set(h_tmodFIG,'Visible','off');
        set(findall(0,'tag','playExample'),'Visible','on');
    end
    
    
else
    close all; clear all; clc;% close the window and restart the GUI to ensure that stimParamas and blocks are reset
    MaskingGUI;
end


% --- Executes on key press with focus on responseWindow_FIG or any of its controls.
function responseWindow_FIG_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to responseWindow_FIG (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)z

%allow user to push keyboard keys
%instead of mouse clicking buttons
switch eventdata.Key
    %top row numbers--------
    %     case '1'
    %         button1_Callback;
    %     case '2'
    %         button2_Callback;
    %     case '3'
    %         button3_Callback;
    
    % number pad numbers-----
    case 'numpad1'
        button1_Callback;
    case 'numpad2'
        button2_Callback;
    case 'numpad3'
        button3_Callback;
        
        
end


% --- Executes on button press in playExample.
function playExample_Callback(hObject, eventdata, handles)
% hObject    handle to playExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findall(0,'tag','responseWindow_FIG'),'Visible','off');
dummyhandles=handles;
playExampleWin(dummyhandles);


% --- Executes during object deletion, before destroying properties.
function responseWindow_FIG_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to responseWindow_FIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes when user attempts to close responseWindow_FIG.
function responseWindow_FIG_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to responseWindow_FIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
respWINSTATE=get(findall(0,'tag','closeRespWinButton'),'Visible'); %turn on "NEXT" button

switch respWINSTATE
    case 'on'
%         reminder1=msgbox('please click ''NEXT'' before closing the window');
%         waitfor(reminder1);
    otherwise
        % Hint: delete(hObject) closes the figure
        delete(hObject);
%         close all; clear all; clc;
%         MaskingGUI;
end

