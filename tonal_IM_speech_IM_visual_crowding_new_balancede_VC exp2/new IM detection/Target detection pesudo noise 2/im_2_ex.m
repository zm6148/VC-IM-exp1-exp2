function varargout = im_2_ex(varargin)
% IM_2_EX MATLAB code for im_2_ex.fig
%      IM_2_EX, by itself, creates a new IM_2_EX or raises the existing
%      singleton*.
%
%      H = IM_2_EX returns the handle to a new IM_2_EX or the handle to
%      the existing singleton*.
%
%      IM_2_EX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IM_2_EX.M with the given input arguments.
%
%      IM_2_EX('Property','Value',...) creates a new IM_2_EX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before im_2_ex_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to im_2_ex_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help im_2_ex

% Last Modified by GUIDE v2.5 11-May-2017 11:12:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @im_2_ex_OpeningFcn, ...
                   'gui_OutputFcn',  @im_2_ex_OutputFcn, ...
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


% --- Executes just before im_2_ex is made visible.
function im_2_ex_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to im_2_ex (see VARARGIN)

% Choose default command line output for im_2_ex
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
handles.para=para_multi;
%handles.current = 1;
[handles.current, change_direction, finished,output_plot_start, output_threshold, all_results] = where_to_start( para_multi );

% change gui
set(handles.filename, 'String', filename);

% current number
octave_separation = handles.para(handles.current,5);
all_result_index =  find(all_results(:,5) == octave_separation);
number_to_substract = all_results(all_result_index,4);
set(handles.current_num, 'String', handles.current-number_to_substract);

% trial number
how_many_finished = sum(all_results(:,1));
n = how_many_finished+1;
if n >= 4
	n=4;
end
trial_string = [num2str(n) '/4'];
set(handles.totaltrial, 'String', trial_string);
% disp(hObject)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes im_2_ex wait for user response (see UIRESUME)
% uiwait(handles.experiment);


% --- Outputs from this function are returned to the command line.
function varargout = im_2_ex_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
handles.output = hObject;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    handles.para(handles.current,13)=1;
    guidata(hObject, handles);
    
    %flash red if response is wrong and green if right
    if handles.para(handles.current,7)==handles.para(handles.current,13)

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
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');

    set(handles.yes,'Enable','off');
    set(handles.no,'Enable','off');

    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % based on consecutive 2 correct or not change separation ocataves %
    % 12 direction changes
    m_dis = handles.para(handles.current,5);
    
    switch m_dis
        
        case 0.3
            ax= handles_tracking.axes2;    
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject );
        case 0.5
            ax= handles_tracking.axes5;
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject );
        case 1
            ax= handles_tracking.axes6;
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject);
        case 1.5
            ax= handles_tracking.axes7;    
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject );
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %set(handles.current_num, 'String', handles.current+1);
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
    %[output_current, output_change_direction, finished] = where_to_start(handles.para);
    handles.para(handles.current,13)=2;
    guidata(hObject, handles);

    % flash red if response is wrong and green if right
    if handles.para(handles.current,7)==handles.para(handles.current,13)
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
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');

    set(handles.yes,'Enable','off');
    set(handles.no,'Enable','off');



    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % based on consecutive 2 correct or not change separation ocataves %
    % 12 direction changes
	
    m_dis = handles.para(handles.current,5);
    switch m_dis
        
        case 0.3
            ax= handles_tracking.axes2;    
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject );
        case 0.5
            ax= handles_tracking.axes5;
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject );
        case 1
            ax= handles_tracking.axes6;
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject );
        case 1.5
            ax= handles_tracking.axes7;    
            handles = adaptive_tracking( handles, handles_tracking, ax, hObject );
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % set(handles.current_num, 'String', handles.current+1);
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
%disp(handles.para_multi);
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
handles.para=para_multi;
%disp(filename);

% find where to begin the test
[handles.current, handles.change_direction, finished, handles.plot_start, handles.threshold, all_results] = where_to_start( handles.para );

% update gui
% current number
if isempty(handles.current)
	set(handles.current_num, 'String', 'Finished');
else
	octave_separation = handles.para(handles.current,5);
	all_result_index =  find(all_results(:,5) == octave_separation);
	number_to_substract = all_results(all_result_index,4);
	set(handles.current_num, 'String', handles.current-number_to_substract);
end

% trial number
how_many_finished = sum(all_results(:,1));
n = how_many_finished+1;
if n >= 4
	n=4;
end
trial_string = [num2str(n) '/4'];
set(handles.totaltrial, 'String', trial_string);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if finished == 1
    h = msgbox('Threshold test was finshed, Click OK and Wait for Instructions');  
    % use handles.threshold to generate new testing matrix for psycurve
    % and save that matrix
    %psy_para_multi = build_psycurve_matrix( handles.para, handles.threshold);
    %save([pwd '\conditions\' 'psy_curve_' filename],'psy_para_multi');
    %close(im_2_ex);
    sendemial_whendone;
else

    [Fs,sound] = build_sound_pesudonoise_mono( handles );
    
    % play the stimuli
    player = audioplayer(sound, Fs);
    playblocking(player);
      
    % update button
    set(handles.yes,'Enable','on');
    set(handles.no,'Enable','on');
    
    %set(handles.target_mask,'Enable','off');
    set(handles.target,'Enable','off');
    
    % update para if any
    selected=get(handles_tracking.conditions,'value');
    filename=handles_tracking.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');
    
    % updata handles
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
% para_multi=handles.para;
% if isempty(para_multi)
%     load([pwd '\conditions\' filename]);
% else
%     para_multi=handles.para;
% end
% save([pwd '\conditions\' filename],'para_multi');
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
% updata handles
guidata(hObject, handles);
test_training(handles.tracking);
%fig.Position(1)=200;


% --- Executes on button press in target_mask.
function target_mask_Callback(hObject, eventdata, handles)
% hObject    handle to target_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fig=test_training_part_2(handles);
%fig.Position(1)=200;

% --- Executes on key press with focus on experiment or any of its controls.
function experiment_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to experiment (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)switch eventdata.Key
switch eventdata.Key
	
    case '1' 
        yes_Callback(hObject, eventdata, handles);
   
    case '2'
        no_Callback(hObject, eventdata, handles);

end
