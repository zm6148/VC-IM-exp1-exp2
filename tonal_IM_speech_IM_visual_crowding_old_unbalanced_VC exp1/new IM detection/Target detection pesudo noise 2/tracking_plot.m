function varargout = tracking_plot(varargin)
% TRACKING_PLOT MATLAB code for tracking_plot.fig
%      TRACKING_PLOT, by itself, creates a new TRACKING_PLOT or raises the existing
%      singleton*.
%
%      H = TRACKING_PLOT returns the handle to a new TRACKING_PLOT or the handle to
%      the existing singleton*.
%
%      TRACKING_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKING_PLOT.M with the given input arguments.
%
%      TRACKING_PLOT('Property','Value',...) creates a new TRACKING_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tracking_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tracking_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tracking_plot

% Last Modified by GUIDE v2.5 10-May-2017 16:46:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tracking_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @tracking_plot_OutputFcn, ...
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


% --- Executes just before tracking_plot is made visible.
function tracking_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tracking_plot (see VARARGIN)

% Choose default command line output for tracking_plot
handles.output = hObject;

%load from conditions folder
path=[pwd '\conditions'];
filePattern = fullfile(path, '/*.*');
files = dir(filePattern);
% Get a list of all files in the folder.
% Filter the list to pick out only files of
% file types that we want (image and video files).
handles.listofnames = {}; % Initialize

for Index = 1:length(files)
    base_name = files(Index).name;
    [folder, name, extension] = fileparts(base_name);
    switch extension
        case '.mat'
            handles.listofnames = [handles.listofnames base_name];
    end
end
% Now we have a list of validated filenames that we want.
% Send the list of validated filenames to the listbox.
set(handles.conditions, 'String', handles.listofnames);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.para= [];
handles.step=0;
handles.count=1;
handles.all_steps=[];%all step changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tracking_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tracking_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in conditions.
function conditions_Callback(hObject, eventdata, handles)
% hObject    handle to conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns conditions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from conditions

% load data
cla(handles.axes1)
selected=get(handles.conditions,'value');
filename=handles.listofnames{selected};
disp(filename);
name_break = strsplit(filename, '_');
first = name_break{1};

%treshold of that subject
subject_name = [];
for ii = 3:length(name_break)-1
	subject_name = [subject_name, name_break{ii}, '_'];
end
subject_name = [subject_name, name_break{length(name_break)}];

% disp(first);
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes5);
cla(handles.axes6);
cla(handles.axes7);

% if name starts with psy 
if strcmp(first,'psy')
    % h = msgbox('load psycurve test data');
    % if name starts not with psy
    load([pwd '\conditions\' filename]);
    %save([pwd '\conditions\' filename],'psy_para_multi');
    
    current=find(psy_para_multi(:,13)==0, 1, 'first'); %all trial finished
    set(handles.total_condition, 'String', size(psy_para_multi,1));
    set(handles.last_num, 'String', current-1);
	
	% load treshold data of that subject
	load([pwd '\conditions\' subject_name]);
	
    set(handles.t_03, 'String', '');
    set(handles.t_05, 'String', '');
    set(handles.t_1, 'String', '');
    set(handles.t_2, 'String', '');
    
    % plot threshold
	%where to start
    [current, output_change_direction, finished, output_plot_start, threshold, all_results] = where_to_start( para_multi );
    plot_threshold(handles, para_multi, all_results);
	
	
	% plot psy curve
	plot_psycurve( handles.axes1, psy_para_multi );
	
	
else
    
    % if name starts not with psy
	set(handles.whichtest, 'Title', 'Sensation Threshold dB SPL');
    load([pwd '\conditions\' filename]);
    %save([pwd '\conditions\' filename],'para_multi');
    
    % where to start
    [current, output_change_direction, finished, output_plot_start, threshold, all_results] = where_to_start( para_multi );
    
	% plot threshold
    plot_threshold(handles, para_multi, all_results);
	plot_threshold_training(para_multi, handles.axes1);
%     plot_threshold(para_multi, handles.axes2, all_results);
%     plot_threshold(para_multi, handles.axes5, all_results);
%     plot_threshold(para_multi, handles.axes6, all_results);
%     plot_threshold(para_multi, handles.axes7, all_results);
    
 
    % updata gui
    if finished ~= 1
        set(handles.total_condition, 'String', size(para_multi,1));
        set(handles.last_num, 'String', current-1);
    else
        
        set(handles.total_condition, 'String', size(para_multi,1));
        set(handles.last_num, 'String', 'Threshold Finished, Load Psy_curve experiment');
        h = msgbox('threshold finished, load psycurve test data instead');
    end
end


% --- Executes during object creation, after setting all properties.
function conditions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load selected
selected=get(handles.conditions,'value');
filename=handles.listofnames{selected};
name_break = strsplit(filename, '_');
first = name_break(1);
% disp(first);

% if name starts with psy 
if strcmp(first,'psy')
    % h = msgbox('load psycurve test data');
    
    % if name starts not with psy
    load([pwd '\conditions\' filename]);
    save([pwd '\conditions\' filename],'psy_para_multi');
    
    % first zero at user response
    current=find(psy_para_multi(:,13)==0, 1, 'first'); %all trial finished
    % disp(current);
    % all answered
    if isempty(current)
        
        set(handles.total_condition, 'String', size(psy_para_multi,1));
        set(handles.last_num, 'String', 'Finished');
        
    else
        set(handles.total_condition, 'String', size(psy_para_multi,1));
        set(handles.last_num, 'String', current-1);
        handles.para= psy_para_multi;
        handles.im_2_ex_psycurve_=im_2_ex_psycurve();
        %handles.im_2_ex.Position(1)=100;
    end
    
else
    % if name starts not with psy
    load([pwd '\conditions\' filename]);
    %save([pwd '\conditions\' filename],'para_multi');
    
    % where to start or not start
    [handles.current, handles.change_direction, handles.finished, handles.plot_start, handles.threshold] = where_to_start( para_multi );
    
    if handles.finished == 1
        h = msgbox('threshold finished, load psycurve test data instead');
    else
        handles.para= para_multi;
        handles.im_2_ex=im_2_ex();
        % handles.im_2_ex.Position(1)=-10;
    end
end

guidata(hObject, handles);


% --- Executes on button press in Refresh.
function Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%load from conditions folder
path=[pwd '\conditions'];
filePattern = fullfile(path, '/*.*');
files = dir(filePattern);
% Get a list of all files in the folder.
% Filter the list to pick out only files of
% file types that we want (image and video files).
handles.listofnames = {}; % Initialize

for Index = 1:length(files)
    base_name = files(Index).name;
    [folder, name, extension] = fileparts(base_name);
    switch extension
        case '.mat'
            handles.listofnames = [handles.listofnames base_name];
    end
end
% Now we have a list of validated filenames that we want.
% Send the list of validated filenames to the listbox.
set(handles.conditions, 'String', handles.listofnames);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.para= [];
handles.step=0;
handles.count=1;
handles.all_steps=[];%all step changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
