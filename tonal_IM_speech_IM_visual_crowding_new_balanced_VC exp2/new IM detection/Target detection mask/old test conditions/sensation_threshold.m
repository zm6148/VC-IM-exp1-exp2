function varargout = sensation_threshold(varargin)
	if nargin && ischar(varargin{1}) && exist(varargin{1})==2
		func = str2func(varargin{1});
		if nargout(func);
			varargout = {func(varargin{2:end})};
		else
			func(varargin{2:end});
		end
		return;
	end

	% Begin initialization code - DO NOT EDIT
	gui_Singleton = 1;
	gui_State = struct('gui_Name',       mfilename, ...
					   'gui_Singleton',  gui_Singleton, ...
					   'gui_OpeningFcn', @fig_OpeningFcn, ...
					   'gui_OutputFcn',  @fig_OutputFcn, ...
					   'gui_LayoutFcn',  [] , ...
					   'gui_Callback',   []);
	if nargin && ischar(varargin{1})
		gui_State.gui_Callbcack = str2func(varargin{1});
	end

	if nargout
		[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
	else
		gui_mainfcn(gui_State, varargin{:});
	end
	% End initialization code - DO NOT EDIT


% --- Executes just before sensation_threshold is made visible.
function fig_OpeningFcn(obj, e, h, varargin)
	% Choose default command line output for sensation_threshold
	h.output = obj;
	
	if strcmp(h.fig.Visible, 'off')
		if ~isempty(varargin) && isa(varargin{1}, 'matlab.ui.Figure')
			h.fig2 = varargin{1};
		else
			delete(h.fig);
			controller_gui;
			return;
		end
		
		h.start_exp = @start_exp;
		h.next_trial = @next_trial;
		h.timer = [];
		joystick('start', @fig_WindowKeyPressFcn, h.fig);

		% OS compatibility
		if ispc
			h.txtStartInstructions.FontSize = 14;
		end
		
		% Init panels
		h.panels = findobj(h.fig, 'Type', 'uipanel')';
		for panel = h.panels
			if strcmp(panel.Visible, 'on')
				center_panel(h, panel);
				h.panel = panel;
			end
		end
		
		% Init buttons
		h.btnHear2.Position = h.btnHear1.Position;
	end
	
	% Update h structure
	guidata(obj, h);


function fig_CloseRequestFcn(obj, e, h)
	% Allow closing the figure only if there is one monitor connected,
	% that is when devloping the code and/or pilot testing
% 	monitors = get(0, 'MonitorPositions');
% 	if size(monitors,1) == 1;
	audio('stop');
	try stop(h.timer); delete(h.timer);
	catch; end
	joystick('stop', @fig_WindowKeyPressFcn);
	delete(obj);
% 	end


function fig_SizeChangedFcn(obj, e, h)
	center_panel(h, h.panel);


% --- Outputs from this function are returned to the command line.
function varargout = fig_OutputFcn(obj, e, h)
	% Get default command line output from h structure
	if ~isempty(h)
		varargout{1} = h.output;
	end


function fig_WindowKeyPressFcn(obj, e, h)
	if h.panel == h.pnlStart
		switch e.Key
			case {'return', 'space', 'joy a'}
				h = btnStart_Callback(obj, e, h);
		end
	elseif h.panel == h.pnlChoice
		switch e.Key
			case {'return', 'space', 'joy a'}
				h = btnHear_Callback(obj, e, h);
		end
	end
	
	guidata(h.fig, h);


function h = start_exp(h)
% Initialize the experiment with given parameters
% Will be called from the controller GUI (controller_gui.m)
	h2 = guidata(h.fig2);
    h.fig.Pointer = 'watch'; drawnow;
	h = open_panel(h, h.pnlStart);
	
	if isempty(h2.SID); msgbox('Invalid SID'); close(h.fig); return; end
	
    h.Params.SID = h2.SID;
	h.Params.Emotiva = str2num(h2.lstEmotiva.String{h2.lstEmotiva.Value});
	h.Params.referenceSPL = sl2sf(h.Params, 'reference');
	h.Params.TaskType = h2.TaskType;
	
    % ADJUSTABLE h.Params
	th = str2num(h2.edtThreshold.String); % a guessed hearing threshold
	th = round(th/10)*10;
	h.Params.startLevel = 30+th;     % level of first stim presentation for each ear in dB SPL
	h.Params.dwnSteps = 5;        % downward step sizes in dB SPL
	h.Params.upSteps = 2.5;          % upward step sizes in dB SPL
	h.Params.nRev = 20;     %[12]    % number of reversals for each step size in the vector - here a reversal is any change in direction
	
	if tasktype(h.Params.TaskType,'noise')
		h.Params.StimulusType = 'noise';
		h.Params.StimulusDuration = 1; % Total stimulus duration in seconds
		h.Params.Flo = 300; % Lower cut-off frequency in Hertz
		h.Params.Fhi = 1200; % Higher cut-off frequency in Hertz
		h.Params.RampDuration = 10e-3; % Ramp duration in seconds
		h.Params.Fs = 192e3;
	elseif tasktype(h.Params.TaskType,'click')
		h.Params.StimulusType = 'click';
		h.Params.StimulusDuration = .5; % Total stimulus duration in seconds
		h.Params.Flo = 300; % Lower cut-off frequency in Hertz
		h.Params.Fhi = 10e3; % Higher cut-off frequency in Hertz
		h.Params.RampDuration = 10e-3; % Ramp duration in seconds
		h.Params.Fs = 192e3;
	else
		error('Stimulus unknown');
	end
	
	if tasktype(h.Params.TaskType,'dichotic')
		h.Params.startingEar = 'r'; % right ear
	elseif tasktype(h.Params.TaskType,'diotic')
		h.Params.startingEar = 'd'; % both ears
	end
    
    % FIXED PARAMETERS
	h.Params.run = [0;0];
	h.Params.ear = h.Params.startingEar;
	h.Params.rev = [0;0];
    h.Params.responsesl = -1;
    h.Params.levelsl = h.Params.startLevel;
    h.Params.responsesr = -1;
    h.Params.levelsr = h.Params.startLevel;
    h.Params.hit = 0;
    h.Params.atten = h.Params.startLevel - h.Params.referenceSPL;
    % PERIODIC TIMER SETTINGS
    h.timer = timer;
    h.timer.TimerFcn = {@timerfunc, h.fig}; 
    h.timer.Period = 10;                 % seconds
    h.timer.StartDelay = interval();     % seconds
    h.timer.ExecutionMode = 'fixedrate'; %'fixedrate';
	
	h.t = 0  : 1/h.Params.Fs : h.Params.StimulusDuration;
	if strcmpi(h.Params.StimulusType,'noise')
		% Set up the stimulus noise, with zero ILD and zero ITD
		% The actual ramp as a function of time
		tramp = sin(0:0.5*pi/round(h.Params.RampDuration*h.Params.Fs):pi/2).^2;
		noise = rand(size(h.t));
		noise = noise - mean(noise);
		[b1,a1] = butter(3,[h.Params.Flo h.Params.Fhi]/(h.Params.Fs/2),'bandpass');
		noise = filtfilt(b1,a1,noise);
		% Ramp the stimulus
		stim = noise.*[tramp, ones(1,length(h.t)-2*length(tramp)), fliplr(tramp)];
		% Target has RMS = 1
		h.stim = stim/sqrt(mean(stim.^2));
	elseif strcmpi(h.Params.StimulusType,'click')
		ramp = sin(0:0.5*pi/round(h.Params.RampDuration*h.Params.Fs):pi/2).^2;

		stim = double(h.Params.StimulusDuration/2<h.t); % step function at middle of the stimulus
		[b1,a1] = butter(3,[h.Params.Flo h.Params.Fhi]/(h.Params.Fs/2),'bandpass');
		stim = filtfilt(b1,a1,stim);
		stim = stim .* [ramp, ones(1,length(h.t)-2*length(ramp)), fliplr(ramp)];
		h.stim = stim/sqrt(mean(stim.^2)); % rms of one
	end
	
	% Keep some possibly useful information in experiment data files
	h.Params.ExperimentName      = mfilename; % Experiment script file name
	h.Params.ExperimentCode      = 'THR'; % Prefix for data files
	h.Params.ExperimentTitle     = 'Sensation Threshold'; % Figure title
	h.Params.ExperimentStartTime = datetime;
	h.Params.ExperimentEndTime   = datetime.empty; % Will be set later
	
	t = datetime(h.Params.ExperimentStartTime,'format','yyMMdd-HHmmss');
	h.Params.DataFile = [h.Params.ExperimentCode '-' h.Params.SID '-' char(t)];
	
	audio('open', h.Params.Fs);
    
	h.fig.UserData = h.Params.ExperimentName; % Used in controller_gui
	h.fig.Name = h.Params.ExperimentTitle; % Figure title
	uicontrol(h.btnDummy);
	h.fig.Pointer = 'arrow'; drawnow;
	
	guidata(h.fig2, h2);
	guidata(h.fig, h);


function h = btnStart_Callback(obj, e, h)
	% BEGIN
	h = open_panel(h, h.pnlChoice);
    start(h.timer)
    guidata(h.fig, h);


function h = btnHear_Callback(obj, e, h)
	if wait; return; end
	
    h.Params.hit = 1;
	h.btnHear2.Visible = 'on' ; drawnow;
	h.btnHear1.Visible = 'off'; drawnow;
	wait(.3);
	h.btnHear2.Visible = 'off'; drawnow;
	h.btnHear1.Visible = 'on' ; drawnow;
	
    guidata(h.fig, h);


function h = open_panel(h, panel)
	if h.panel == panel; return; end
	
	center_panel(h, panel);
	panel.Visible = 'on';
	h.panel.Visible = 'off';
	h.panel = panel;
	drawnow;
	guidata(h.fig, h);
        
  
function h = center_panel(h, panel)
	panel.Position(1:2) = (h.fig.Position(3:4)-panel.Position(3:4))/2;


function timerfunc(~,~,fig)
% Check for reversals, play stim, and reset hit flag
	try
	h = guidata(fig);
	h2 = guidata(h.fig2);
	
	stop(h.timer);
	h.timer.StartDelay = interval();
	start(h.timer);
	
	r = rower(h.Params.ear,h.Params.startingEar);
	h.Params.run(r) = h.Params.run(r) + 1;  % run intialized to 1 in timerstart so first time here run = 2
	run = h.Params.run(r);
	
	if h.Params.hit
		if h.Params.rev(r) < h.Params.nRev && run > 1    % set level down one step and set response for that run = 1
			if h.Params.ear=='r' || h.Params.ear=='d'
				h.Params.levelsr(run) = h.Params.levelsr(run-1) - h.Params.dwnSteps(1);
				h.Params.atten = h.Params.levelsr(run) - h.Params.referenceSPL;
				h.Params.responsesr(run-1)=1;
			elseif h.Params.ear=='l'
				h.Params.levelsl(run) = h.Params.levelsl(run-1) - h.Params.dwnSteps(1);
				h.Params.atten = h.Params.levelsl(run) - h.Params.referenceSPL;
				h.Params.responsesl(run-1)=1;
			end

		elseif h.Params.rev(r) >= h.Params.nRev(1)  % if reached the number of reversals for the ear, got to the next ear
			ear = earChooser(h.Params.ear, h.Params.startingEar);
			h.Params.ear = ear;
			stim = nan;
		end

	else                % set level up one step and set response for that run = 0

		if h.Params.rev(r) < h.Params.nRev(1) && run > 1
			if h.Params.ear =='r' || h.Params.ear=='d'
				h.Params.levelsr(run) = h.Params.levelsr(run-1) + h.Params.upSteps(1);
				h.Params.atten = h.Params.levelsr(run) - h.Params.referenceSPL;
				h.Params.responsesr(run-1) = 0;
			elseif h.Params.ear=='l'
				h.Params.levelsl(run) = h.Params.levelsl(run-1) + h.Params.upSteps(1);
				h.Params.atten = h.Params.levelsl(run) - h.Params.referenceSPL;
				h.Params.responsesl(run-1) = 0;
			end
		elseif h.Params.rev(r) >= h.Params.nRev(1)    % if reached the number of reversals for the ear, go the next ear
			ear = earChooser(h.Params.ear, h.Params.startingEar);
			h.Params.ear = ear;
			stim = nan;
		end
	end


	% RESET THE HIT FLAG
	h.Params.hit = 0;

	% check if this was a reversal
	if h.Params.rev(r) < h.Params.nRev(1) && run >= 3 && ~isempty(h.Params.ear)
		if h.Params.ear=='r' || h.Params.ear=='d'
			if (h.Params.responsesr(run-1) - h.Params.responsesr(run-2)) ~= 0
				% INCREASE REVERSAL COUNT
				h.Params.rev(r) = h.Params.rev(r) + 1;
			end
		elseif h.Params.ear=='l'
			if (h.Params.responsesl(run-1) - h.Params.responsesl(run-2)) ~= 0
				% INCREASE REVERSAL COUNT
				h.Params.rev(r) = h.Params.rev(r) + 1;
			end
		end
	end
	
	analyze(h2.ax1, h.Params, 'tracks');

	% PLAY THE STIMULUS ON THE CORRECT CHANNEL UNLESS EAR IS EMPTY [] WHICH 
	% INDICATES BOTH EARS HAVE BEEN TESTED AND STOP THE TIMER     
	if ~isempty(h.Params.ear)   % "ear" is set to empty if both ears have been tested
		%  PLACE DATA ON CHANNEL THAT CORRESPONDS TO THE CURRENT EAR UNDER TEST
		x = 10^(h.Params.atten/20)*h.stim;
		z = zeros(size(x));
		if h.Params.ear=='r'
			stim = [z;x];
		elseif strcmpi(h.Params.ear,'l')
			stim = [x;z];
		elseif h.Params.ear=='d'
			stim = [x;x];
		else
			disp('Error: Invalid Ear Choice')
		end
		
		audio('play', stim);
	else
		h = end_exp(h);
	end
	
	catch me
		disp(getReport(me))
	end

	try
		guidata(h.fig2, h2);
		guidata(h.fig, h);
	catch
	end


function h = next_trial(h)
	ear = earChooser(h.Params.ear, h.Params.startingEar);
	h.Params.ear = ear;
	stim = nan;
	guidata(h.fig, h);


function h = end_exp(h)
	try
	h2 = guidata(h.fig2);
	
	stop(h.timer);
	
	
	% get levels that elicited a response and take the median of last 6
	% reversals
	ar = h.Params.responsesr .* h.Params.levelsr(1:end-1); 
	br = nonzeros(ar);
	h.Params.medianThresholdr = median(br(max(size(br)-6,1):end));
	h.Params.stdr = std(br(max(size(br)-6,1):end));
	
	al = h.Params.responsesl .* h.Params.levelsl(1:end-1); 
	bl = nonzeros(al);
	h.Params.medianThresholdl = median(bl(max(size(bl)-6,1):end));
	h.Params.stdl = std(bl(max(size(bl)-6,1):end));
	
	% Say thank you
	h = open_panel(h, h.pnlEnd);
	h.Params.ThresholdSPL = (h.Params.medianThresholdl+h.Params.medianThresholdr)/2;
	sf = sl2sf(h.Params, 40);
	audio('play', 'sounds/thanks.mp3', sf);
	
	analyze(h2.ax1, h.Params, 'summary');
	
	% Save results
	h.Params.ExperimentEndTime = datetime;
	Params = h.Params;
	save(['../data/' h.Params.DataFile], 'Params');
	
	catch me
		disp(getReport(me))
	end
	
	try
		guidata(h.fig2, h2);
		guidata(h.fig, h);
	catch
	end


function r = rower(ear, startingEar)
	if strcmpi(ear,startingEar)
		r = 1;
	elseif ~strcmpi(ear,startingEar)
		r = 2;
	else
		disp('Error: Invalid ear selection')
	end


function ear = earChooser(ear, startingEar)
	ear = lower(ear);
	startingEar = lower(startingEar);
	if strcmp(ear,startingEar) && strcmp(ear,'l')
		ear = 'r';
	elseif strcmp(ear,startingEar) && strcmp(ear,'r')
		ear = 'l';
	elseif strcmp(ear,'d') || ~strcmp(ear,startingEar) % completed both ears
		ear = '';
	else
		disp('Error: Invalid ear selection')
	end


function int = interval()
	int = rand()*2.5+3;
	int = int - rem(int, .5);


function list = plot_list(p)
	if length(p)>1 || length(p{1})>1
		list = {};
	else
		list = {'Summary','summary'; 'Tracks','tracks'};
	end


function analyze(ax, p, code)
	kw = {'markers',14, 'linewidth',2};
	leg   = {'fontsize',14, 'location','southeast'};
	notes = {};
	
	if isa(ax, 'matlab.graphics.axis.Axes')
		cla(ax,'reset'); hold(ax,'on'); grid(ax,'on');
	end
	
	if ~iscell(p); p = {{p}}; end % unify form
	
	if length(p)>1
		error('[sensation_threshold] group analysis not implemented');
	elseif length(p{1})>1
		error('[sensation_threshold] cross-run analysis not implemented');
	else
		p = p{1}{1};
		endtime = p.ExperimentEndTime;
		if isempty(endtime); endtime = datetime; end;
		t = char(endtime-p.ExperimentStartTime);
		
		if strcmpi(code, 'summary')
			if p.startingEar=='d'
				ar = p.responsesr .* p.levelsr(1:end-1);
				br = nonzeros(ar);
				cr = br(max(size(br)-7,1):end);
				
				h = boxplot(ax, cr, 'outliersize',14);
				
				notes{end+1} = sprintf('Diotic threshold: %.1f', p.medianThresholdr);
			else
				ar = p.responsesr .* p.levelsr(1:end-1);
				br = nonzeros(ar);
				cr = br(max(size(br)-7,1):end);

				al = p.responsesl .* p.levelsl(1:end-1);
				bl = nonzeros(al);
				cl = bl(max(size(bl)-7,1):end);
				h = boxplot(ax, [cr cl], {'Right Ear', 'Left Ear'}, 'outliersize',14);

				notes{end+1} = sprintf('Right threshold: %.2f', p.medianThresholdr);
				notes{end+1} = sprintf('Left threshold: %.2f', p.medianThresholdl);
				notes{end+1} = sprintf('Average threshold: %.2f', (p.medianThresholdr+p.medianThresholdl)/2);
			end
			
			for i=1:size(h,1)
				for j=1:size(h,2)
					set(h(i,j),'linewidth',2);
				end
			end
			
			notes{end+1} = sprintf('Duration: %s', t);
			title(ax, sprintf('Sensation thresholds for %s', p.SID));
			ylabel(ax, 'Threshold Response (dB SPL)');
			ax.Box = 'on';
		end

		if strcmpi(code, 'tracks')
			if p.startingEar=='d'
				plot(ax, p.levelsr, 'gs-', kw{:});
				notes{end+1} = 'Parameter set: Diotic';
				legend(ax, {'Diotic'}, 'fontsize',12, leg{:});
			else
				plot(ax, p.levelsr, 'ro-', kw{:});
				plot(ax, p.levelsl, 'bx-', kw{:});
				notes{end+1} = 'Parameter set: Dichotic';
				legend(ax, {'Right Ear', 'Left Ear'}, 'fontsize',12, leg{:});
			end

			steps = max(length(p.levelsr), length(p.levelsl));
			all = [p.levelsr p.levelsl];
			ax.YLim = [min(all)-5 max(all)+5];
			ax.XLim = [0 steps+1];

			notes{end+1} = sprintf('Duration: %s', t);
			title(ax, sprintf('Sensation tracks for %s', p.SID));
			xlabel(ax, 'Steps');
			ylabel(ax, 'Stimulus Level (dB SPL)');
		end
	end

	if isa(ax, 'matlab.graphics.axis.Axes')
		note(ax, notes{:});
	end
% imread('../pics/start.png','background',[.192 .725 .302])
% imread('../pics/start.png','background',[.292 .825 .402])
