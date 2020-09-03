function varargout = test_training(varargin)
% TEST_TRAINING MATLAB code for test_training.fig
%      TEST_TRAINING, by itself, creates a new TEST_TRAINING or raises the existing
%      singleton*.
%
%      H = TEST_TRAINING returns the handle to a new TEST_TRAINING or the handle to
%      the existing singleton*.
%
%      TEST_TRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_TRAINING.M with the given input arguments.
%
%      TEST_TRAINING('Property','Value',...) creates a new TEST_TRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_training_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_training_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_training

% Last Modified by GUIDE v2.5 27-Apr-2015 03:09:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_training_OpeningFcn, ...
                   'gui_OutputFcn',  @test_training_OutputFcn, ...
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


% --- Executes just before test_training is made visible.
function test_training_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_training (see VARARGIN)

% Choose default command line output for test_training

[a,map]=imread('up.jpg');
I=imresize(a, [30 80]);
set(handles.up,'CData',I);

[a,map]=imread('down.jpg');
I=imresize(a, [30 80]);
set(handles.down,'CData',I);

[a,map]=imread('flat.jpg');
I=imresize(a, [30 80]);
set(handles.flat,'CData',I);

[a,map]=imread('up-down.jpg');
I=imresize(a, [30 80]);
set(handles.up_down,'CData',I);

[a,map]=imread('down-up.jpg');
I=imresize(a, [30 80]);
set(handles.down_up,'CData',I);

handles.para=varargin{1}.para;
handles.go=0;

pt_bw = [0.3]; %pattern bandwidth 1
pt_dur = [150]; % pattern duration 2 
t_cf = handles.para(1,3); %target central frequence 3
spl = handles.para(1,4); %target attenuation 4
t_pt= [1 2 3 4 5]; %target pattern 5
t_es = handles.para(1,9); %target element spacing 6
TotalNumber=handles.para(1,11);%total number 7

a = {pt_bw pt_dur t_cf spl t_pt t_es TotalNumber};
% para = allcomb(a{:});
[a, b, c, d, e, f, g] = ndgrid(a{:});
para = [a(:) b(:) c(:) d(:) e(:) f(:) g(:)];

para_test = para (ceil((1:2*size(para ,1))/2), :);%repeat each condition 2 times
para_test=[para_test zeros(size(para_test,1),1)];
handles.para_test = para_test(randperm(size(para_test,1)),:);%shullfle the conditions
handles.count=1;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_training wait for user response (see UIRESUME)
% uiwait(handles.training);


% --- Outputs from this function are returned to the command line.
function varargout = test_training_OutputFcn(hObject, eventdata, handles) 
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
    handles.para_test(handles.count-1,8)=1;
    handles.output = hObject;
    guidata(hObject, handles);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
%   set(handles.play,'Enable','on');
    set(handles.text10, 'Visible', 'off');

    %flash red if response is wrong and green if right
   if handles.para_test(handles.count-1,5)==handles.para_test(handles.count-1,8)


        set(handles.up,'Backgroundcolor','g');
        pause(0.2);
        set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para_test(handles.count-1,5)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(0.2);
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
%    for jj=0:3
%        set(handles.timer,'String',4-jj);
%        pause(1);
%    end
%    
%    set(handles.timer,'String','');
       
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
    handles.para_test(handles.count-1,8)=2;
    handles.output = hObject;
    guidata(hObject, handles);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text10, 'Visible', 'off');
%   set(handles.play,'Enable','on');

    %flash red if response is wrong and green if right
    if handles.para_test(handles.count-1,5)==handles.para_test(handles.count-1,8)


        set(handles.down,'Backgroundcolor','g');
        pause(0.2);
        set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
    else
        
        switch handles.para_test(handles.count-1,5)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(0.2);
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
        
    end
    
%    for jj=0:3
%        set(handles.timer,'String',4-jj);
%        pause(1);
%    end
%    
%    set(handles.timer,'String','');
       
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
    handles.para_test(handles.count-1,8)=3;
    handles.output = hObject;
    guidata(hObject, handles);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text10, 'Visible', 'off');
%   set(handles.play,'Enable','on');

    %flash red if response is wrong and green if right
    if handles.para_test(handles.count-1,5)==handles.para_test(handles.count-1,8)


        set(handles.flat,'Backgroundcolor','g');
        pause(0.2);
        set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para_test(handles.count-1,5)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(0.2);
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
%    for jj=0:3
%        set(handles.timer,'String',4-jj);
%        pause(1);
%    end
%    
%    set(handles.timer,'String','');
       
   play_Callback(hObject, eventdata, handles);    
else 
    return;
end


% --- Executes on button press in down_up.
function up_down_Callback(hObject, eventdata, handles)
% hObject    handle to down_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.up_down,'Enable'),'on')
    
    %update results
    handles.para_test(handles.count-1,8)=4;
    handles.output = hObject;
    guidata(hObject, handles);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text10, 'Visible', 'off');
%   set(handles.play,'Enable','on');

    %flash red if response is wrong and green if right
    if handles.para_test(handles.count-1,5)==handles.para_test(handles.count-1,8)


        set(handles.up_down,'Backgroundcolor','g');
        pause(0.2);
        set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para(handles.count-1,5)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(0.2);
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
%    for jj=0:3
%        set(handles.timer,'String',4-jj);
%        pause(1);
%    end
%    
%    set(handles.timer,'String','');
       
   play_Callback(hObject, eventdata, handles);    
else 
    return;
end


% --- Executes on button press in up_down.
function down_up_Callback(hObject, eventdata, handles)
% hObject    handle to up_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.down_up,'Enable'),'on')
    
    %update results
    handles.para_test(handles.count-1,8)=5;
    handles.output = hObject;
    guidata(hObject, handles);

    set(handles.up,'Enable','off');
    set(handles.down,'Enable','off');
    set(handles.flat,'Enable','off');
    set(handles.up_down,'Enable','off');
    set(handles.down_up,'Enable','off');
    set(handles.text10, 'Visible', 'off');
%   set(handles.play,'Enable','on');

    %flash red if response is wrong and green if right
   if handles.para_test(handles.count-1,5)==handles.para_test(handles.count-1,8)
        set(handles.down_up,'Backgroundcolor','g');
        pause(0.2);
        set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para_test(handles.count-1,5)
            case 1
                set(handles.up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
            case 2
                set(handles.down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 3
                set(handles.flat,'Backgroundcolor','r');
                pause(0.2);
                set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
            case 4
                set(handles.up_down,'Backgroundcolor','r');
                pause(0.2);
                set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
            case 5
                set(handles.down_up,'Backgroundcolor','r');
                pause(0.2);
                set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
        end
    end
    
%    for jj=0:3
%        set(handles.timer,'String',4-jj);
%        pause(1);
%    end
%    
%    set(handles.timer,'String','');
       
   play_Callback(hObject, eventdata, handles);    
else 
    return;
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp(handles.para_test);
set(handles.play,'Enable','off');
set(handles.skip,'Enable','off');

if any(handles.para_test(:,8)==0,1)==0
    if sum(handles.para_test(:,5)==handles.para_test(:,8))>=8;
       %set(im_2_ex, 'Visible', 'on');
       test_training_part_2(handles);
       close(handles.training);
        
    else
        h = msgbox('Target partten test failed please try again', 'Error','error');
        handles.count=1;
        handles.para_test(:,8)=0;
        set(handles.play, 'Enable', 'on');
        %update handles
        handles.output = hObject;
        guidata(hObject, handles);
    end
    
else
        ii=handles.count;
        Fs=44.1e3; %sampling frequence
        Ramp = 10e-3; %ramp duration

        TotalNumber=handles.para_test(ii,7);
        Duration = handles.para_test(ii,2);% 200 ms long tone pips
        Delay = Duration/4; %delay may be random mark for edit later
        t = 0 : 1/Fs : Duration/1000;
        ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
        envelope = [ramp ones(length(t)-2*length(ramp),1)' fliplr(ramp)];
        t_cf = handles.para_test(ii,3);
        spl = handles.para_test(ii,4);
        t_pt = handles.para_test(ii,5);
        t_es = handles.para_test(ii,6);
        pt_bw = handles.para_test(ii,1);


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

        silence = 0.*(0:1/Fs : Delay/t_cf);
        target_pattern=[];
        [spl_c,freq]=iso226(spl);

        for j=1:TotalNumber
            t_spl=spline(freq,spl_c,t_frequencies(j));
            tone = envelope.*sin(2*pi*t_frequencies(j)*t);
            tone=(tone/rms(tone))*10^((t_spl-93)/20);
            target_pattern = [target_pattern, tone, silence];
        end


        handles.count=handles.count+1;
        %update handles
        handles.output = hObject;
        guidata(hObject, handles);



        set(handles.text8, 'Visible', 'on');
        set(handles.timer, 'Visible', 'on');

        for jj=0:1
               set(handles.timer,'String',1-jj);
               pause(1);
        end

        set(handles.timer,'String','');

        sound(target_pattern,Fs);
        set(handles.up,'Enable','on');
        set(handles.down,'Enable','on');
        set(handles.flat,'Enable','on');
        set(handles.up_down,'Enable','on');
        set(handles.down_up,'Enable','on');
        set(handles.text10, 'Visible', 'on');
        set(handles.text8, 'Visible', 'off');
        set(handles.timer, 'Visible', 'off');
    %     disp(handles.para_test);
end
   

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
guidata(hObject, handles);

close all;



% --- Executes on key press with focus on training or any of its controls.
function training_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to training (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case '1'
        up_Callback(hObject, eventdata, handles);
    case '2'
        down_Callback(hObject, eventdata, handles);
    case '3'
        flat_Callback(hObject, eventdata, handles);
    case '4'
        up_down_Callback(hObject, eventdata, handles);
    case '5'
        down_up_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in skip.
function skip_Callback(hObject, eventdata, handles)
% hObject    handle to skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
test_training_part_2(handles);
close(handles.training);
