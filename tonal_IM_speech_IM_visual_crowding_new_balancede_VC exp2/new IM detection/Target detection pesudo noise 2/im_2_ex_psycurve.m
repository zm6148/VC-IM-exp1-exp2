function varargout = im_2_ex_psycurve(varargin)
% IM_2_EX_PSYCURVE MATLAB code for im_2_ex_psycurve.fig
%      IM_2_EX_PSYCURVE, by itself, creates a new IM_2_EX_PSYCURVE or raises the existing
%      singleton*.
%
%      H = IM_2_EX_PSYCURVE returns the handle to a new IM_2_EX_PSYCURVE or the handle to
%      the existing singleton*.
%
%      IM_2_EX_PSYCURVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IM_2_EX_PSYCURVE.M with the given input arguments.
%
%      IM_2_EX_PSYCURVE('Property','Value',...) creates a new IM_2_EX_PSYCURVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before im_2_ex_psycurve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to im_2_ex_psycurve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help im_2_ex_psycurve

% Last Modified by GUIDE v2.5 09-Mar-2017 19:21:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @im_2_ex_psycurve_OpeningFcn, ...
                   'gui_OutputFcn',  @im_2_ex_psycurve_OutputFcn, ...
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


% --- Executes just before im_2_ex_psycurve is made visible.
function im_2_ex_psycurve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to im_2_ex_psycurve (see VARARGIN)

% Choose default command line output for im_2_ex_psycurve
%Coloca una imagen en cada botón
% uiopen('matlab');
% Choose default command line output for tracking_plot
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%handles.step= 10;
handles.count=1;
handles.all_steps=[];%all step changesvarargin{1};

handles.tracking=tracking_plot();
handles_tracking=guidata(handles.tracking);
selected=get(handles_tracking.conditions,'value');
filename=handles_tracking.listofnames{selected};
load([pwd '\conditions\' filename]);

% find where to start
handles.para=psy_para_multi;
handles.current = find(handles.para(:,13)==0, 1, 'first');

% change gui
set(handles.filename, 'String', filename);
set(handles.current_num, 'String', handles.current);
set(handles.totaltrial, 'String', size(psy_para_multi,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes im_2_ex_psycurve wait for user response (see UIRESUME)
% uiwait(handles.experiment);


% --- Outputs from this function are returned to the command line.
function varargout = im_2_ex_psycurve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
size = get(0, 'MonitorPositions');
set(gcf, 'Position', size(1,:));
undecorate(handles.experiment);


% --- Executes on button press in yes.
function yes_Callback(hObject, eventdata, handles)
% hObject    handle to yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.yes,'Enable'),'on')
    
    %update results
    %[output_current, output_change_direction, finished] = where_to_start(handles.para);
    handles.para(handles.current-1,13)=1;
    guidata(hObject, handles);
    
    %flash red if response is wrong and green if right
    if handles.para(handles.current-1,7)==handles.para(handles.current-1,13)
        
        set(handles.yes,'Backgroundcolor','g');
        pause(0.2);
        set(handles.yes,'Backgroundcolor',[0.94 0.94 0.94]);
        
    else
        
        set(handles.no,'Backgroundcolor','r');
        pause(0.2);
        set(handles.no,'Backgroundcolor',[0.94 0.94 0.94]);
        
    end


    %save results
    handles_tracking=guidata(handles.tracking);
    selected=get(handles_tracking.conditions,'value');
    filename=handles_tracking.listofnames{selected};
    psy_para_multi=handles.para;
    save([pwd '\conditions\' filename],'psy_para_multi');

    set(handles.yes,'Enable','off');
    set(handles.no,'Enable','off');
	
	% plot psy curve
	plot_psycurve( handles_tracking.axes1, psy_para_multi );

    set(handles.current_num, 'String', handles.current+1);
    play_Callback(hObject, eventdata, handles); 

else 
    return;
end





% --- Executes on button press in no.
function no_Callback(hObject, eventdata, handles)
% hObject    handle to no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.no,'Enable'),'on')
    
    %update results
    handles.para(handles.current-1,13)=2;
    guidata(hObject, handles);
    
    %flash red if response is wrong and green if right
    if handles.para(handles.current-1,7)==handles.para(handles.current-1,13)
        set(handles.no,'Backgroundcolor','g');
        pause(0.2);
        set(handles.no,'Backgroundcolor',[0.94 0.94 0.94]);
    else
        
        set(handles.yes,'Backgroundcolor','r');
        pause(0.2);
        set(handles.yes,'Backgroundcolor',[0.94 0.94 0.94]);
        
    end

    %save results
    handles_tracking=guidata(handles.tracking);
    selected=get(handles_tracking.conditions,'value');
    filename=handles_tracking.listofnames{selected};
    psy_para_multi=handles.para;
    save([pwd '\conditions\' filename],'psy_para_multi');

    set(handles.yes,'Enable','off');
    set(handles.no,'Enable','off');
	
	% plot psy curve
	plot_psycurve( handles_tracking.axes1, psy_para_multi );

    set(handles.current_num, 'String', handles.current+1);
	% call play function
    play_Callback(hObject, eventdata, handles);     
else 
    return;
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp('hello');
%disp(handles.psy_para_multi);
%disp('bye');

% toggle buttons
set(handles.play,'Enable','off');
% set(handles.target_mask,'Enable','off');
% set(handles.target,'Enable','off');

% updata data and plot
handles_tracking=guidata(handles.tracking);
selected=get(handles_tracking.conditions,'value');
filename=handles_tracking.listofnames{selected};
load([pwd '\conditions\' filename]);
handles.para=psy_para_multi;
% disp(filename);

% find where to begin
handles.current = find(handles.para(:,13)==0, 1, 'first');

if isempty(handles.current)
    h = msgbox('All Finished Thank you ! ');  
    % use handles.threshold to generate new testing matrix for psycurve
    % and save that matrix
    psy_para_multi = handles.para;
    save([pwd '\conditions\' filename],'psy_para_multi');
    %close(im_2_ex_psycurve);
    
else
    
    % load and buid sound to play
    [Fs,sound] = build_sound_pesudonoise_mono( handles );
    
    % play the stimuli
    player = audioplayer(sound, Fs);
    playblocking(player);
        
    % update button
    set(handles.yes,'Enable','on');
    set(handles.no,'Enable','on');
    
%    set(handles.target_mask,'Enable','off');
%    set(handles.target,'Enable','off');
    
    % update para if any
    selected=get(handles_tracking.conditions,'value');
    filename=handles_tracking.listofnames{selected};
    psy_para_multi=handles.para;
    save([pwd '\conditions\' filename],'psy_para_multi');
    
    %updata handles
    handles.current = handles.current+1;
    guidata(hObject, handles);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    







% --- Executes on button press in abort.
function abort_Callback(hObject, eventdata, handles)
% hObject    handle to abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %save results
% handles_tracking=guidata(handles.tracking);
% selected=get(handles_tracking.conditions,'value');
% filename=handles_tracking.listofnames{selected};
% 
% psy_para_multi=handles.para;
% if isempty(psy_para_multi)
%     load([pwd '\conditions\' filename]);
% else
%     psy_para_multi=handles.para;
% end
% save([pwd '\conditions\' filename],'psy_para_multi');
% 
% guidata(hObject, handles);
close();



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
    


% --- Executes on key press with focus on experiment or any of its controls.
function experiment_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to experiment (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case '1' 
        up_Callback(hObject, eventdata, handles);
    case 'numpad1'
        up_Callback(hObject, eventdata, handles);
    case '2'
        down_Callback(hObject, eventdata, handles);
    case 'numpad2'
        down_Callback(hObject, eventdata, handles);
    case '3'
        flat_Callback(hObject, eventdata, handles);
    case 'numpad3'
        flat_Callback(hObject, eventdata, handles);
    case '4'
        up_down_Callback(hObject, eventdata, handles);
    case 'numpad4'
        up_down_Callback(hObject, eventdata, handles);
    case '5'
        down_up_Callback(hObject, eventdata, handles);
    case 'numpad5'
        down_up_Callback(hObject, eventdata, handles);
end



function p_d_Callback(hObject, eventdata, handles)
% hObject    handle to p_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p_d as text
%        str2double(get(hObject,'String')) returns contents of p_d as a double


% --- Executes during object creation, after setting all properties.
function p_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t_d_Callback(hObject, eventdata, handles)
% hObject    handle to t_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_d as text
%        str2double(get(hObject,'String')) returns contents of t_d as a double


% --- Executes during object creation, after setting all properties.
function t_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function yes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in target.
function target_Callback(hObject, eventdata, handles)
% hObject    handle to target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%fig = test_training(handles);
%fig.Position(1)=200;


% --- Executes on button press in target_mask.
function target_mask_Callback(hObject, eventdata, handles)
% hObject    handle to target_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fig=test_training_part_2(handles);
%fig.Position(1)=200;
