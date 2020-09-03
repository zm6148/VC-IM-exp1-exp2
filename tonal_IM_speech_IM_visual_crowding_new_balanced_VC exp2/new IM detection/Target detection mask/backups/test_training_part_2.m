function varargout = test_training_part_2(varargin)
% TEST_TRAINING_PART_2 MATLAB code for test_training_part_2.fig
%      TEST_TRAINING_PART_2, by itself, creates a new TEST_TRAINING_PART_2 or raises the existing
%      singleton*.
%
%      H = TEST_TRAINING_PART_2 returns the handle to a new TEST_TRAINING_PART_2 or the handle to
%      the existing singleton*.
%
%      TEST_TRAINING_PART_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_TRAINING_PART_2.M with the given input arguments.
%
%      TEST_TRAINING_PART_2('Property','Value',...) creates a new TEST_TRAINING_PART_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_training_part_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_training_part_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_training_part_2

% Last Modified by GUIDE v2.5 25-Aug-2016 14:50:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_training_part_2_OpeningFcn, ...
                   'gui_OutputFcn',  @test_training_part_2_OutputFcn, ...
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


% --- Executes just before test_training_part_2 is made visible.
function test_training_part_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_training_part_2 (see VARARGIN)

% Choose default command line output for test_training_part_2

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
pt_dur = [150]; % pattern duration 2 in ms
t_cf = handles.para(1,3); %target center frequence 3
spl=[50]; %desired sound loudness level 4
m_dis= [2]; %mask to target distance 5
tm_dif=[0]; %target mask loudness diff (target_loundness-mask_loudness) 6
t_pt= [1 2 3 4 5]; %target pattern 7
m_pt= [1 2 3 4 5]; %mask pattern 8
t_es= [1]; %target element spacing 9
m_es= [1]; %mask element spacing 10
num_tone=[8]; % total number of tones 11
repetition = 1; %number of repetition 12
a = {pt_bw pt_dur t_cf spl m_dis tm_dif t_pt m_pt t_es m_es num_tone repetition};
% para = allcomb(a{:});
[a, b, c, d, e, f, g, h, i, j, k, l] = ndgrid(a{:});
para = [a(:) b(:) c(:) d(:) e(:) f(:) g(:) h(:) i(:) j(:) k(:) l(:)];
para(para(:,7)==para(:,8),:)=[];
para_multi = para (ceil((1:repetition*size(para ,1))/repetition), :);%repeat each condition 3 times
para_multi=[para_multi zeros(size(para_multi,1),1)]; %add one colum for response 13
para_multi = para_multi(randperm(size(para_multi,1)),:);%shullfle the conditions

handles.para_test = para_multi(1:length(para_multi)/2,:);%10 conditions
handles.count=1;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_training_part_2 wait for user response (see UIRESUME)
% uiwait(handles.training);


% --- Outputs from this function are returned to the command line.
function varargout = test_training_part_2_OutputFcn(hObject, eventdata, handles) 
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
    handles.para_test(handles.count-1,13)=1;
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
   if handles.para_test(handles.count-1,7)==handles.para_test(handles.count-1,13)


        set(handles.up,'Backgroundcolor','g');
        pause(0.2);
        set(handles.up,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para_test(handles.count-1,7)
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
    handles.para_test(handles.count-1,13)=2;
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
    if handles.para_test(handles.count-1,7)==handles.para_test(handles.count-1,13)


        set(handles.down,'Backgroundcolor','g');
        pause(0.2);
        set(handles.down,'Backgroundcolor',[0.94 0.94 0.94]);
    else
        
        switch handles.para_test(handles.count-1,7)
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
    handles.para_test(handles.count-1,13)=3;
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
    if handles.para_test(handles.count-1,7)==handles.para_test(handles.count-1,13)


        set(handles.flat,'Backgroundcolor','g');
        pause(0.2);
        set(handles.flat,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para_test(handles.count-1,7)
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
    handles.para_test(handles.count-1,13)=4;
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
    if handles.para_test(handles.count-1,7)==handles.para_test(handles.count-1,13)


        set(handles.up_down,'Backgroundcolor','g');
        pause(0.2);
        set(handles.up_down,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para(handles.count-1,7)
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
    handles.para_test(handles.count-1,13)=5;
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
   if handles.para_test(handles.count-1,7)==handles.para_test(handles.count-1,13)
        set(handles.down_up,'Backgroundcolor','g');
        pause(0.2);
        set(handles.down_up,'Backgroundcolor',[0.94 0.94 0.94]);
    else

        switch handles.para_test(handles.count-1,7)
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

if any(handles.para_test(:,13)==0,1)==0
    
    if sum(handles.para_test(:,7)==handles.para_test(:,13))>=8;
       set(im_2_ex, 'Visible', 'on');
       close(handles.training);
        
    else
        h = msgbox('Training and mask test failed please try again', 'Error','error');
        handles.count=1;
        handles.para_test(:,13)=0;
        set(handles.play, 'Enable', 'on');
        %update handles
        handles.output = hObject;
        guidata(hObject, handles);
    end
    
else
        i=handles.count;

        Fs=44.1e3; %sampling frequence
        Ramp = 10e-3 ; %ramp duration 0.15s

        TotalNumber=handles.para_test(i,11);
        Duration = handles.para_test(i,2);% 150 ms long tone pips
        Delay = Duration/4; %delay may be random mark for edit later
        %phase = pi*rand(TotalNumber,1);
        t = 0 : 1/Fs : Duration/1000;
        ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
        envelope = [ramp ones(length(t)-2*length(ramp),1)' fliplr(ramp)];
        t_cf = handles.para_test(i,3);
        pt_bw = handles.para_test(i,1);
        pt_dur=handles.para_test(i,2);
        spl = handles.para_test(i,4);
        t_pt = handles.para_test(i,7);
        t_es = handles.para_test(i,9);
        m_dis = handles.para_test(i,5);
        tm_dif = handles.para_test(i,6);
        m_pt = handles.para_test(i,8);
        m_es = handles.para_test(i,10);


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

        sound(target_pattern+mask_pattern,Fs);%play sound 
        
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
set(im_2_ex, 'Visible', 'on');
close(handles.training);
