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

% Last Modified by GUIDE v2.5 09-Aug-2018 12:02:37

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
handles.output = hObject;
handles.ex = varargin{1};
handles_ex=guidata(handles.ex);
% handles_tracking = varargin{1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%handles.step= 10;
handles.count=1;
handles.change_direction = 0;
selected=get(handles_ex.conditions,'value');
filename=handles_ex.listofnames{selected};
load([pwd '\conditions\' filename]);

% find where to start
handles.para=para_multi;
handles.current = 1;

% change gui
set(handles.filename, 'String', filename);
set(handles.current_num, 'String', handles.current);
set(handles.totaltrial, 'String', size(para_multi,1));
% disp(hObject)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
handles.output = hObject;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
size = get(0, 'MonitorPositions');
set(gcf, 'Position', size(1,:));
undecorate(gcf);



% % --- Executes on button press in yes.
% function yes_Callback(hObject, eventdata, handles)
% % hObject    handle to yes (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% if strcmp(get(handles.yes,'Enable'),'on')
%
% 	%update results
% 	%[output_current, output_change_direction, finished] = where_to_start(handles.para);
% 	handles.para(handles.current-1,17)=1;
% 	guidata(hObject, handles);
%
% 	%     %flash red if response is wrong and green if right
% 	%     if handles.para(handles.current-1,17)==handles.para(handles.current-1,7)
% 	%
% 	%         set(handles.yes,'Backgroundcolor','g');
% 	%         pause(0.2);
% 	%         set(handles.yes,'Backgroundcolor',[0.94 0.94 0.94]);
% 	%
% 	%     else
% 	%
% 	% 		set(handles.no,'Backgroundcolor','r');
% 	% 		pause(0.2);
% 	% 		set(handles.no,'Backgroundcolor',[0.94 0.94 0.94]);
% 	%
% 	%     end
%
% 	%save results
% 	handles_ex=guidata(handles.ex);
% 	% disp(handles_ex);
% 	selected=get(handles_ex.conditions,'value');
% 	filename=handles_ex.listofnames{selected};
% 	para_multi=handles.para;
% 	save([pwd '\conditions\' filename],'para_multi');
%
% 	set(handles.yes,'Enable','off');
% 	%set(handles.no,'Enable','off');
%
% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	% based on consecutive 2 correct or not change separation ocataves %
% 	% 12 direction changes
% 	% plot on to the ttracking plot axes1
% 	ax = handles_ex.axes1;
% 	handles = adaptive_tracking_for_training_one_buttom( handles, handles_ex, ax, hObject );
% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 	set(handles.current_num, 'String', handles.current);
% 	play_Callback(hObject, eventdata, handles);
%
% else
% 	return;
% end


% % --- Executes on button press in no.
% function no_Callback(hObject, eventdata, handles)
% % hObject    handle to no (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% if strcmp(get(handles.no,'Enable'),'on')
%
%     %update results
%     %[output_current, output_change_direction, finished] = where_to_start(handles.para);
%     handles.para(handles.current-1,17)=2;
%     guidata(hObject, handles);
%
%     % flash red if response is wrong and green if right
%     if handles.para(handles.current-1,17)==handles.para(handles.current-1,7)
%         set(handles.no,'Backgroundcolor','r');
%         pause(0.2);
%         set(handles.no,'Backgroundcolor',[0.94 0.94 0.94]);
%     else
%
% 		set(handles.yes,'Backgroundcolor','g');
% 		pause(0.2);
% 		set(handles.yes,'Backgroundcolor',[0.94 0.94 0.94]);
%
%     end
%
%     %save results
% 	handles_ex=guidata(handles.ex);
% 	selected=get(handles_ex.conditions,'value');
%     filename=handles_ex.listofnames{selected};
%     para_multi=handles.para;
%     save([pwd '\conditions\' filename],'para_multi');
%
%     set(handles.yes,'Enable','off');
%     set(handles.no,'Enable','off');
%
% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	% based on consecutive 2 correct or not change separation ocataves %
% 	% 12 direction changes
% 	% plot on to the ttracking plot axes1
% 	ax = handles_ex.axes1;
% 	handles = adaptive_tracking_for_training_one_buttom( handles, handles_ex, ax, hObject );
% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     set(handles.current_num, 'String', handles.current);
% 	% call play function
%     play_Callback(hObject, eventdata, handles);
% else
%     return;
% end



% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp(handles.para_test);

set(handles.play,'Enable','off');
% set(handles.skip,'Enable','off');

% check finished or not
handles_ex=guidata(handles.ex);
selected=get(handles_ex.conditions,'value');
filename=handles_ex.listofnames{selected};
load([pwd '\conditions\' filename]);
handles.para=para_multi;
handles.current = find(handles.para(:,17) == 0,1,'first');





for i = handles.current:size(handles.para,1)
	
	set(handles.current_num, 'String', i);
	
	if isempty(handles.current)
		change_direction = 12;
	else
		change_direction = handles.change_direction;
	end
	
	%disp(change_direction);
	
	if change_direction >= 12
		h = msgbox('Target Training was finshed, Click OK and Wait for Instructions');
		break;
	else
		
		% load current condition and play sound one by one
		Fs=44.1e3; %sampling frequence
		Ramp = 10e-3; %ramp duration
		
		TotalNumber=handles.para(i,11);
		Duration = handles.para(i,2);% 150 ms long tone pips
		Delay = Duration/4; %delay may be random mark for edit later
		t = 0 : 1/Fs : Duration/1000;
		ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
		envelope = [ramp ones(length(t)-2*length(ramp),1)' fliplr(ramp)];
		t_cf = handles.para(i,3);
		pt_bw = handles.para(i,1);
		pt_dur=handles.para(i,2);
		spl = handles.para(i,16); % use training spl
		t_pt = 1; % for training target always there handles.para(i,7);
		t_es = handles.para(i,9);
		m_dis = handles.para(i,5);
		tm_dif = handles.para(i,6);
		m_pt = handles.para(i,8);
		m_es = handles.para(i,10);
		
		%switch among element distance
		switch t_es
			case 1% even spacing
				f=[];
				for jj = 1:TotalNumber
					f=[f,t_cf];
				end
			case 2% random spacing
				target_range_down=greenwood(target_distance - distance/2);
				target_range_up=greenwood(target_distance + distance/2);
				f  = round(logspace(log10(target_range_down),log10(target_range_up),((target_range_up-target_range_down))*(pt_dur/100)));
				y = datasample(f(2:(length(f)-1)),(TotalNumber-2),'Replace',false);
				f = [f(1) sort(y) f(length(f))];
		end
		
		t_frequencies = f;
		
		silence = 0.*(0:1/Fs : Delay/1000);
		target_pattern=[];
		
		for j=1:TotalNumber
			
			switch t_pt
				case 2 % target no there
					tone = 0*t;
					target_pattern = [target_pattern, tone, silence];
					
				case 1 % target there
					t_spl=spl; %spline(freq,spl_c,t_frequencies(j));
					phase_target=2*pi*rand(1,1);
					tone = envelope.*sin(2*pi*t_frequencies(j)*t+phase_target);
					tone=(tone/rms(tone))*10^((t_spl-88.4)/20);
					target_pattern = [target_pattern, tone, silence];
			end
			
		end
		
		
		%random mono to left or right ear
		left_or_right = 0; % round(rand);
		switch left_or_right
			case 1
				target_pattern = [zeros(length(target_pattern),1)'; target_pattern];
			case 0
				target_pattern = [target_pattern; zeros(length(target_pattern),1)'];
		end
		
		% play the stimuli
		player = audioplayer(target_pattern, Fs);
		play(player);
		
		% wait for random time for subject response
		% if respond with yes (key press), lower next trial sound level
		% if respond with no (no key press), up next trial sound level
		
		% generate random wait time (3 to 6 secs)
		wait_time =  randi([4 8],1);
		j = 1;
		
		%set(gcf,'KeyPressFcn','keydown=1;');
		set(gcf,'CurrentCharacter','3');
		set(gcf,'Selectiontype','alt');
		while j<wait_time
			mousein = get(gcf,'Selectiontype');
			keyIn = get(gcf,'CurrentCharacter');
			% wait for 1 sec each cycle
			pause(0.05);
			j = j+0.05;
		end
		
		% base on key press and do staff
		
		if strcmpi(mousein,'normal')
			% pressed space key decrease next sound level 1
			handles.para(i,17) = 1;
			ax = handles_ex.axes1;
			handles = adaptive_tracking_for_training_one_buttom(i, handles, handles_ex, ax, hObject, 1 );
		else
			% did not press space key increase next sound level 2
			handles.para(i,17) = 2;
			ax = handles_ex.axes1;
			handles = adaptive_tracking_for_training_one_buttom(i, handles, handles_ex, ax, hObject, 2 );
		end
		
		
		
% 		pause one more secs before next sound plays
% 		pause(1);
		
		% update button
		% set(handles.yes,'Enable','on');
		% set(handles.no,'Enable','on');
		
		% updata handles
		% handles.current = handles.current+1;
		
	end
	
	
end


guidata(hObject, handles);





% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
guidata(hObject, handles);

close();
im_2_ex()
%close all;

% --- Executes during object creation, after setting all properties.
function stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function yes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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
		handles.canhear = 'yes';
	case '2'
		handles.canhear = 'no';
end
guidata(hObject, handles);
