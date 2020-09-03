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

% Last Modified by GUIDE v2.5 27-Sep-2016 13:58:23

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

[a,map]=imread('up.jpg');
I=imresize(a, [50 120]);
set(handles.up,'CData',I);

[a,map]=imread('down.jpg');
I=imresize(a, [50 120]);
set(handles.down,'CData',I);

[a,map]=imread('flat.jpg');
I=imresize(a, [50 120]);
set(handles.flat,'CData',I);

[a,map]=imread('up-down.jpg');
I=imresize(a, [50 120]);
set(handles.up_down,'CData',I);

[a,map]=imread('down-up.jpg');
I=imresize(a, [50 120]);
set(handles.down_up,'CData',I);

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

handles.output = hObject;
% handles.para= para_multi;
handles.para= [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.step=0;
handles.all_steps=[];%all step changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.up,'Enable'),'on')
    
    %update results
    handles.para(handles.current-1,13)=1;
    handles.output = hObject;
    guidata(hObject, handles);

    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');

    % load([pwd '\conditions\' filename]);
    % disp(para_multi);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text19, 'Visible', 'off');
%     set(handles.play,'Enable','on');
    set(handles.play_target,'Enable','on');
%     set(handles.reselect, 'Enable', 'on');

    %flash red if response is wrong and green if right
    if handles.para(handles.current-1,7)==handles.para(handles.current-1,13)

        set(handles.up,'Backgroundcolor','g');
        pause(str2num(get(handles.p_d,'String')));
        set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
        color=[0,1,0];
        
    else
        color=[1,0,0];
        switch handles.para(handles.current-1,7)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % based on consecutive 2 correct or not change separation ocataves %
    
    if ((handles.para(handles.current-1,7)==handles.para(handles.current-1,13)))
        handles.step= -0.5;
    else 
        handles.step= 0.25;
    end
    handles.all_steps=[handles.all_steps,handles.step];
    disp(handles.all_steps);
    handles.output = hObject;
    guidata(hObject, handles);
    
    %change next mask target separation based on response%
    m_dis = handles.para(handles.current-1,5)+handles.step;
    if m_dis>=2
        m_dis=2;
    elseif m_dis<=0
        m_dis=0.1;
    else
        m_dis=handles.para(handles.current-1,5)+handles.step;
    end
    %update next trial separation
    handles.para(handles.current,5)=m_dis;
    %disp(handles.para(handles.current,5));
    handles.output = hObject;
    guidata(hObject, handles);
    
    figure(2);
    hold on;
    handles.fig=plot(handles.all_steps,'color',color);
    ylim([-1,1])
    hold off;
    
    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    set(handles.current_num, 'String', handles.current);
    play_Callback(hObject, eventdata, handles);     
else 
    return;
end




% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.down,'Enable'),'on')
    
    %update results
    handles.para(handles.current-1,13)=2;
    handles.output = hObject;
    guidata(hObject, handles);

    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');

    % load([pwd '\conditions\' filename]);
    % disp(para_multi);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text19, 'Visible', 'off');
%     set(handles.play,'Enable','on');
    set(handles.play_target,'Enable','on');
%     set(handles.reselect, 'Enable', 'on');


    %flash red if response is wrong and green if right
    if handles.para(handles.current-1,7)==handles.para(handles.current-1,13)


        set(handles.down,'Backgroundcolor','g');
        pause(str2num(get(handles.p_d,'String')));
        set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
        color=[0,1,0];
    else
        color=[1,0,0];
        switch handles.para(handles.current-1,7)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % based on consecutive 2 correct or not change separation ocataves %
    
    if ((handles.para(handles.current-1,7)==handles.para(handles.current-1,13)))
        handles.step= -0.5;
    else 
        handles.step= 0.25;
    end
    handles.all_steps=[handles.all_steps,handles.step];
    disp(handles.all_steps);
    handles.output = hObject;
    guidata(hObject, handles);
    
    %change next mask target separation based on response%
    m_dis = handles.para(handles.current-1,5)+handles.step;
    if m_dis>=2
        m_dis=2;
    elseif m_dis<=0
        m_dis=0.1;
    else
        m_dis=handles.para(handles.current-1,5)+handles.step;
    end
    %update next trial separation
    handles.para(handles.current,5)=m_dis;
    %disp(handles.para(handles.current,5));
    handles.output = hObject;
    guidata(hObject, handles);
    
    figure(2);
    handles.fig=line([handles.current-1,handles.current-1+0.8],[handles.para(handles.current-1,5), handles.para(handles.current-1,5)],'color',color);
    ylim([0,3])
    
    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    set(handles.current_num, 'String', handles.current);
    play_Callback(hObject, eventdata, handles);    
else 
    return;
end

% --- Executes on button press in flat.
function flat_Callback(hObject, eventdata, handles)
% hObject    handle to flat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.flat,'Enable'),'on')
    
    %update results
    handles.para(handles.current-1,13)=3;
    handles.output = hObject;
    guidata(hObject, handles);

    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');

    % load([pwd '\conditions\' filename]);
    % disp(para_multi);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text19, 'Visible', 'off');
%     set(handles.play,'Enable','on');
    set(handles.play_target,'Enable','on');
%     set(handles.reselect, 'Enable', 'on');


    %flash red if response is wrong and green if right
    if handles.para(handles.current-1,7)==handles.para(handles.current-1,13)


        set(handles.flat,'Backgroundcolor','g');
        pause(str2num(get(handles.p_d,'String')));
        set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
        color=[0,1,0];
    else
        color=[1,0,0];
        switch handles.para(handles.current-1,7)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % based on consecutive 2 correct or not change separation ocataves %
    
    if ((handles.para(handles.current-1,7)==handles.para(handles.current-1,13)))
        handles.step= -0.5;
    else 
        handles.step= 0.25;
    end
    handles.all_steps=[handles.all_steps,handles.step];
    disp(handles.all_steps);
    handles.output = hObject;
    guidata(hObject, handles);
    
    %change next mask target separation based on response%
    m_dis = handles.para(handles.current-1,5)+handles.step;
    if m_dis>=2
        m_dis=2;
    elseif m_dis<=0
        m_dis=0.1;
    else
        m_dis=handles.para(handles.current-1,5)+handles.step;
    end
    %update next trial separation
    handles.para(handles.current,5)=m_dis;
    %disp(handles.para(handles.current,5));
    handles.output = hObject;
    guidata(hObject, handles);
    
    figure(2);
    handles.fig=line([handles.current-1,handles.current-1+0.8],[handles.para(handles.current-1,5), handles.para(handles.current-1,5)],'color',color);
    ylim([0,3])
    
    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    set(handles.current_num, 'String', handles.current);
    play_Callback(hObject, eventdata, handles);    
else 
    return;
end


% --- Executes on button press in up_down.
function up_down_Callback(hObject, eventdata, handles)
% hObject    handle to up_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.up_down,'Enable'),'on')
    
    %update results
    handles.para(handles.current-1,13)=4;
    handles.output = hObject;
    guidata(hObject, handles);

    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');

    % load([pwd '\conditions\' filename]);
    % disp(para_multi);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text19, 'Visible', 'off');
%     set(handles.play,'Enable','on');
    set(handles.play_target,'Enable','on');
%     set(handles.reselect, 'Enable', 'on');


    %flash red if response is wrong and green if right
    if handles.para(handles.current-1,7)==handles.para(handles.current-1,13)
        set(handles.up_down,'Backgroundcolor','g');
        pause(str2num(get(handles.p_d,'String')));
        set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
        color=[0,1,0];
    else
        color=[1,0,0];
        switch handles.para(handles.current-1,7)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % based on consecutive 2 correct or not change separation ocataves %
    
    if ((handles.para(handles.current-1,7)==handles.para(handles.current-1,13)))
        handles.step= -0.5;
    else 
        handles.step= 0.25;
    end
    handles.all_steps=[handles.all_steps,handles.step];
    disp(handles.all_steps);
    handles.output = hObject;
    guidata(hObject, handles);
    
    %change next mask target separation based on response%
    m_dis = handles.para(handles.current-1,5)+handles.step;
    if m_dis>=2
        m_dis=2;
    elseif m_dis<=0
        m_dis=0.1;
    else
        m_dis=handles.para(handles.current-1,5)+handles.step;
    end
    %update next trial separation
    handles.para(handles.current,5)=m_dis;
    %disp(handles.para(handles.current,5));
    handles.output = hObject;
    guidata(hObject, handles);
    
    figure(2);
    hold on;
    handles.fig=plot(handles.all_steps,'color',color);
    ylim([0,3])
    hold off;
    
    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    set(handles.current_num, 'String', handles.current);
    play_Callback(hObject, eventdata, handles);    
else 
    return;
end

% --- Executes on button press in down_up.
function down_up_Callback(hObject, eventdata, handles)
% hObject    handle to down_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.down_up,'Enable'),'on')
    
    %update results
    handles.para(handles.current-1,13)=5;
    handles.output = hObject;
    guidata(hObject, handles);

    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');

    % load([pwd '\conditions\' filename]);
    % disp(para_multi);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text19, 'Visible', 'off');
%     set(handles.play,'Enable','on');
    set(handles.play_target,'Enable','on');
%     set(handles.reselect, 'Enable', 'on');


    %flash red if response is wrong and green if right
    if handles.para(handles.current-1,7)==handles.para(handles.current-1,13)
        set(handles.down_up,'Backgroundcolor','g');
        pause(str2num(get(handles.p_d,'String')));
        set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        color=[0,1,0];
    else
        color=[1,0,0];
        switch handles.para(handles.current-1,7)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(str2num(get(handles.p_d,'String')));
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % based on consecutive 2 correct or not change separation ocataves %
    
    if ((handles.para(handles.current-1,7)==handles.para(handles.current-1,13)))
        handles.step= -0.5;
    else 
        handles.step= 0.25;
    end
    handles.all_steps=[handles.all_steps,handles.step];
    disp(handles.all_steps);
    handles.output = hObject;
    guidata(hObject, handles);
    
    %change next mask target separation based on response%
    m_dis = handles.para(handles.current-1,5)+handles.step;
    if m_dis>=2
        m_dis=2;
    elseif m_dis<=0
        m_dis=0.1;
    else
        m_dis=handles.para(handles.current-1,5)+handles.step;
    end
    %update next trial separation
    handles.para(handles.current,5)=m_dis;
    %disp(handles.para(handles.current,5));
    handles.output = hObject;
    guidata(hObject, handles);
    
    figure(2);
    handles.fig=line([handles.current-1,handles.current-1+0.8],[handles.para(handles.current-1,5), handles.para(handles.current-1,5)],'color',color);
    ylim([0,3])
    
    %save results
    selected=get(handles.conditions,'value');
    filename=handles.listofnames{selected};
    para_multi=handles.para;
    save([pwd '\conditions\' filename],'para_multi');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    set(handles.current_num, 'String', handles.current);
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


selected=get(handles.conditions,'value');
filename=handles.listofnames{selected};

load([pwd '\conditions\' filename]);

handles.current=find(para_multi(:,13)==0, 1, 'first');

handles.para=para_multi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stop condition met or not 1) all 240 finished %
if any(handles.para(:,13)==0,1)==0
    h = msgbox('This test was finshed, Thank you', 'Error','error');
    return;
end
% 12 direction changes
handles.all_steps
if sum(abs(sign(diff(sign(handles.all_steps)))))>=12
    h = msgbox('This test was finshed, Thank you', 'Error','error');    
    disp(handles.para(handles.current,5));
    set(handles.show_results,'Visible','on');
    return;
end
    

i=handles.current;
Fs=44.1e3; %sampling frequence
Ramp = 10e-3 ; %ramp duration 0.15s

TotalNumber=handles.para(i,11);
Duration = handles.para(i,2);% 150 ms long tone pips
Delay = Duration/4; %delay may be random mark for edit later
%phase = pi*rand(TotalNumber,1);
t = 0 : 1/Fs : Duration/1000;
ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
envelope = [ramp ones(length(t)-2*length(ramp),1)' fliplr(ramp)];
t_cf = handles.para(i,3);
pt_bw = handles.para(i,1);
pt_dur=handles.para(i,2);
spl = handles.para(i,4);
t_pt = handles.para(i,7);
t_es = handles.para(i,9);
m_dis = handles.para(i,5);
tm_dif = handles.para(i,6);
m_pt = handles.para(i,8);
m_es = handles.para(i,10);


%switch among element distance  
switch t_es
    case 1% even spacing
        f = round(logspace(log10(t_cf*2^(-pt_bw/2)),log10(t_cf*2^(pt_bw/2)),TotalNumber)); %bandwith/2?
%         f2 = round(logspace(log10(t_cf*2^(-pt_bw/2)),log10(t_cf*2^(pt_bw/2)),TotalNumber/2));
    case 2% random spacing
        f  = round(logspace(log10(t_cf*2^(-pt_bw/2)),log10(t_cf*2^(pt_bw/2)),((t_cf*2^(pt_bw/2)-(t_cf*2^(-pt_bw/2))))*(pt_dur/100)));
        y = datasample(f(2:(length(f)-1)),(TotalNumber-2),'Replace',false);
        f = [f(1) sort(y) f(length(f))];

%         f2  = round(logspace(log10(t_cf*2^(-pt_bw/2)),log10(t_cf*2^(pt_bw/2)),((t_cf*2^(pt_bw/2)-(t_cf*2^(-pt_bw/2))))*(pt_dur/100)));
%         y2 = datasample(f2(2:(length(f2)-1)),(round(TotalNumber/2)-2),'Replace',false);
%         f2 = [f2(1) sort(y2) f2(length(f2))];
end

%switch among target patterns    
switch t_pt
case 1 %Up
    t_frequencies = f;
case 2 % Down
    t_frequencies = fliplr(f);
case 3 % Flat
    t_frequencies = repmat(median(f),1,TotalNumber);
case 4 % Up-Down
    cc = round(TotalNumber/2);
    t_frequencies = [repmat(f(end),1,cc) repmat(f(1),1,cc)];
    t_frequencies = t_frequencies(1:TotalNumber);
%     t_frequencies = [f2 fliplr(f2)];
case 5 % Down-Up
    cc = round(TotalNumber/2);
    t_frequencies = [repmat(f(1),1,cc) repmat(f(end),1,cc)];
    t_frequencies = t_frequencies(1:TotalNumber);  
%     t_frequencies = [fliplr(f2) f2];
end
clear f;
clear f2;    

m_low_cf = t_cf*2^(-m_dis);
m_high_cf = t_cf*2^m_dis;


%switch among element distance
switch m_es
    case 1% even spacing
        f_low = round(logspace(log10(m_low_cf*2^(-pt_bw/2)),log10(m_low_cf*2^(pt_bw/2)),TotalNumber));
        f_high = round(logspace(log10(m_high_cf*2^(-pt_bw/2)),log10(m_high_cf*2^(pt_bw/2)),TotalNumber));

%         f_low2 = round(logspace(log10(m_low_cf*2^(-pt_bw/2)),log10(m_low_cf*2^(pt_bw/2)),TotalNumber/2));
%         f_high2 = round(logspace(log10(m_high_cf*2^(-pt_bw/2)),log10(m_high_cf*2^(pt_bw/2)),TotalNumber/2));

    case 2% random spacing
%         f_low = round(logspace(log10(m_low_cf*2^(-pt_bw/2)),log10(m_low_cf*2^(pt_bw/2)),((m_low_cf*2^(pt_bw/2)-(m_low_cf*2^(-pt_bw/2))))*(pt_dur/100)));
%         f_high = round(logspace(log10(m_high_cf*2^(-pt_bw/2)),log10(m_high_cf*2^(pt_bw/2)),((m_high_cf*2^(pt_bw/2)-(m_high_cf*2^(-pt_bw/2))))*(pt_dur/100)));

        f_low = round(logspace(log10(m_low_cf*2^(-pt_bw/2)),log10(m_low_cf*2^(pt_bw/2)),((m_low_cf*2^(pt_bw/2)-(m_low_cf*2^(-pt_bw/2))))*(pt_dur/100)));    
        y_low = datasample(f_low(2:(length(f_low)-1)),(round(TotalNumber/2)-2),'Replace',false);
        f_low = [f_low(1) sort(y_low) f_low(length(f_low))];

        f_high = round(logspace(log10(m_high_cf*2^(-pt_bw/2)),log10(m_high_cf*2^(pt_bw/2)),((m_high_cf*2^(pt_bw/2)-(m_high_cf*2^(-pt_bw/2))))*(pt_dur/100)));
        y_high = datasample(f_high2(2:(length(f_high)-1)),(round(TotalNumber/2)-2),'Replace',false);
        f_high = [f_high(1) sort(y_high) f_high(length(f_high))];            
end

%swith among mask patterns
switch m_pt
case 1%Up
    m_low_frequences = f_low;
    m_high_frequences = f_high;
case 2 % Down
    m_low_frequences = fliplr(f_low);
    m_high_frequences = fliplr(f_high);
case 3% Flat
    m_low_frequences = repmat(median(f_low),1,TotalNumber);
    m_high_frequences = repmat(median(f_high),1,TotalNumber);
case 4% Up-Down
%     m_low_frequences=[f_low2, fliplr(f_low2)];
%     m_high_frequences=[f_high2, fliplr(f_high2)];        
    cc = round(TotalNumber/2);
    m_low_frequences = [repmat(f_low(end),1,cc) repmat(f_low(1),1,cc)];
    m_low_frequences = m_low_frequences(1:TotalNumber);
    m_high_frequences = [repmat(f_high(end),1,cc) repmat(f_high(1),1,cc)];
    m_high_frequences = m_high_frequences(1:TotalNumber);
case 5% Down-Up
%     m_low_frequences=[fliplr(f_low2), f_low2];
%     m_high_frequences=[fliplr(f_high2), f_high2];       
    cc = round(TotalNumber/2);
    m_low_frequences = [repmat(f_low(1),1,cc) repmat(f_low(end),1,cc)];
    m_low_frequences = m_low_frequences(1:TotalNumber);
    m_high_frequences = [repmat(f_high(1),1,cc) repmat(f_high(end),1,cc)];
    m_high_frequences = m_high_frequences(1:TotalNumber);    
end   
clear f_low;
clear f_low2; 
clear f_high;
clear f_high2;

silence = 0.*(0:1/Fs : Delay/t_cf);
target_pattern=[];
mask_low_pattern=[];
mask_high_pattern=[];

%based on iso226 equal loudness curve calculate corresponding db to
%equal loudness
[spl_c,freq]=iso226(spl);
% disp(envelope);
% disp(t);

for j=1:TotalNumber
    t_spl=spline(freq,spl_c,t_frequencies(j));
    tone = envelope.*sin(2*pi*t_frequencies(j)*t);
    tone=(tone/rms(tone))*10^((t_spl-93)/20);
    target_pattern = [target_pattern, tone, silence];
    
    
    m_spl_low=spline(freq,spl_c,m_low_frequences(j));
    tone = envelope.*sin(2*pi*m_low_frequences(j)*t);
    tone=(tone/rms(tone))*10^((m_spl_low+tm_dif-93)/20);
    mask_low_pattern = [mask_low_pattern, tone, silence];
    
    m_spl_high=spline(freq,spl_c,m_high_frequences(j));
    tone = envelope.*sin(2*pi*m_high_frequences(j)*t);
    tone=(tone/rms(tone))*10^((m_spl_high+tm_dif-93)/20);
    mask_high_pattern = [mask_high_pattern, tone, silence];        
end

mask_pattern = mask_low_pattern+mask_high_pattern;

handles.current=handles.current+1;


handles.output = hObject;
guidata(hObject, handles);

set(handles.text12, 'Visible', 'on');
set(handles.timer, 'Visible', 'on');

for ii=0:str2num(get(handles.t_d,'String'))
       set(handles.timer,'String',str2num(get(handles.t_d,'String'))-ii);
       pause(1);
   end
   
set(handles.timer,'String','');

sound(target_pattern+mask_pattern,Fs);
set(handles.up,'Enable','on');
set(handles.down,'Enable','on');
set(handles.flat,'Enable','on');
set(handles.up_down,'Enable','on');
set(handles.down_up,'Enable','on');
set(handles.play,'Enable','off');
set(handles.play_target,'Enable','off');
set(handles.reselect, 'Enable', 'off');

set(handles.text19, 'Visible', 'on');
set(handles.text12, 'Visible', 'off');
set(handles.timer, 'Visible', 'off');


% --- Executes on button press in play_target.
function play_target_Callback(hObject, eventdata, handles)
% hObject    handle to play_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


test_training(handles);

set(handles.reselect, 'Enable', 'off');
set(handles.play,'enable','on');
set(handles.play_target, 'Enable' ,'off');

set(handles.experiment, 'Visible', 'off');

% --- Executes on button press in abort.
function abort_Callback(hObject, eventdata, handles)
% hObject    handle to abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
guidata(hObject, handles);

%save results
selected=get(handles.conditions,'value');
filename=handles.listofnames{selected};
para_multi=handles.para;
if isempty(para_multi)
    load([pwd '\conditions\' filename]);
else
    para_multi=handles.para;
end
save([pwd '\conditions\' filename],'para_multi');

handles.output = hObject;
guidata(hObject, handles);
close all;




% --- Executes on selection change in conditions.
function conditions_Callback(hObject, eventdata, handles)
% hObject    handle to conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns conditions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from conditions


clc;
selected=get(handles.conditions,'value');
filename=handles.listofnames{selected};
% disp(selected);
% disp(filename);
load([pwd '\conditions\' filename]);
save([pwd '\conditions\' filename],'para_multi');


current=find(para_multi(:,13)==0, 1, 'first'); %all trial finished
change_direction=sum(abs(sign(diff(sign(handles.all_steps)))));%12 change in direction
disp(change_direction);
if isempty(current)||change_direction>=12
    last=size(para_multi,1);
    set(handles.show_results,'Visible','on');
else
    set(handles.show_results,'Visible','off');
    last=current-1;
end
   

set(handles.total_condition, 'String', size(para_multi,1));
set(handles.last_num, 'String', last);
%update handle variable
% handles.output = hObject;
% guidata(hObject, handles);


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



selected=get(handles.conditions,'value');
filename=handles.listofnames{selected};

load([pwd '\conditions\' filename]);


if any(para_multi(:,13)==0,1)==0
    h = msgbox('This test was finshed, please select another one', 'Error','error');
    return;
end
    

% disp(handles.para);
handles.current=find(para_multi(:,13)==0, 1, 'first');
set(handles.current_num, 'String', handles.current);
set(handles.filename, 'String', filename);
handles.para=para_multi;
%update handle variable
handles.output = hObject;
guidata(hObject, handles);
set(handles.play_target,'Enable','on');
set(handles.conditions,'Enable','off');
set(handles.load,'Enable','off');
figure(2);


% --- Executes on button press in reselect.
function reselect_Callback(hObject, eventdata, handles)
% hObject    handle to reselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.conditions,'Enable','on');
set(handles.load,'Enable','on');
set(handles.play,'Enable','off');
set(handles.play_target,'Enable','off');



% --- Executes on button press in show_results.
function show_results_Callback(hObject, eventdata, handles)
% hObject    handle to show_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected=get(handles.conditions,'value');
filename=handles.listofnames{selected};

load([pwd '\conditions\' filename]);
save([pwd '\results\' filename],'para_multi');
x=unique(para_multi(:,5));
y=[];
% disp(x);
for i=1:length(x)
    y(i)=(sum(para_multi(:,5)==x(i) & para_multi(:,7)==para_multi(:,13)))/(sum(para_multi(:,5)==x(i)));
end
% disp(y);
figure(1);
plot(x,y*100,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
axis([min(x) max(x) 0 100])
set(gca,'XTick',x); 
xlabel('Mask Distance to Target in Octave');
ylabel('Percentage of Correctness');
    


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
function up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
