%--------------------------------------------------------------------------
% PointSpeech_HI_APR2010.m
%--------------------------------------------------------------------------
%
% Pointy + Compression
% with masker (another phrase, another phrase time-reversed, speech-shaped noise)
%--------------------------------------------------------------------------
%  Tim 1 APR 2010
% Antje May 5 2010
%--------------------------------------------------------------------------

%% Initialization:
%  ---------------
clear
close all
clc

Params.rand_seed = sum(100*clock);
rand('twister',Params.rand_seed);

%% Experimental Parameters (non-subject specific):
%-------------------------------------------------
sample_frequency = 50e3; %sample frequency (Hz)

%Maximum Hilbert magnitude values for each word, talker, condition:
%------------------------------------------------------------------
processed_stim_directory = '\\Sar-netapp2\kiddlab\Kidd_Stuff\Kidd_Exps\Pointillistic_Speech_Experiments\MBUG_PointProcessed_5APR2010'; %stimulus directory
% use a subset of talkers from the corpus. With the specific parameters used in the level quantization, this subset happens to have
% unimodal distributions of the RMS values of the pointilized & level-quantized words
% using only this subset has the advantage of increasing the minimum level across all utterances:
% when evaluated across all talkers, RMS levels of individual words range
% from 84.4 dB SPL to 105.1 dB SPL
% when evaluated only across the subset of talkers, RMS levels of
% individual words range from 92.5 dB SPL to 105.1 dB SPL
% informal listening suggests that processed utterances from this subset of
% talkers are more intelligible than the rest of the talkers
male_talker_list = [4 5 8 17];%[2:8 17];
female_talker_list= [11 14 16 18];%[10:16 18];
talker_list = [male_talker_list female_talker_list];
wordorder_flag = 1; %1 for syntactic and 0 for random column
load('MBUG_word_array'); %MBUG_word_array
load('MBUG_word_array_sorted'); %MBUG_word_array_sorted
load('PointSignalPeakRMS_5APR2010') %File contained PointPeak and PointRMS values for all talker/word/conditions
MaxPointPeak = max(PointPeak(:)); %Use this value for digital attenuation (no peak over 10v(TDT->D/A) or 2^15(MATLAB->TDT))
response_display_mode = 'light'; % 'dark' - white text on black

%% Subject session parameters:
%  ---------------------------
subject_ID = input('Subject ID: ','s');
subject_file_name = ['MaskedPointHI_Subj',subject_ID];

subject_earstr = '';
while ~ (strcmp(subject_earstr,'l')||strcmp(subject_earstr,'L')||strcmp(subject_earstr,'r')||strcmp(subject_earstr,'R'))
    subject_earstr = input('Which Ear (L/R): ','s');
end
if (strcmp(subject_earstr,'l')||strcmp(subject_earstr,'L'))
    subject_ear = 1;
else
    subject_ear = 2;
end
disp(['Make sure to set the headphone attenuator to 0 dB'])


if exist([subject_file_name,'.mat'],'file') ~= 2
    Params.whichear = subject_ear;
    Params.target_attenuation_dB = input('Please input PA4 attenuation (0 to 99.9): ');
    
    %Test conditions:
    %----------------
    Params.Bands = [4 16];
    Params.Wintime = [10];
    Params.Maskers = [1 2 3];% 1 = another talker, 2 = another talker, time-reversed, 3 = noise
    Params.TMR = [-5 5];
    Params.TotalConditions = length(Params.Bands)*length(Params.Wintime)*length(Params.Maskers)*length(Params.TMR);
    Params.TrialsPerCondition = 3;
    Params.TrialsPerBlock = Params.TotalConditions*Params.TrialsPerCondition;
    Params.TotalBlocks = 8;
    Params.word_order = 'Syntactic';
    
    n =  0;
    for b = 1 : length(Params.Bands)
        for w = 1 : length(Params.Wintime)
            for m = 1 : length(Params.Maskers)
                for t = 1 : length(Params.TMR)
                    n = n + 1;
                    cond =  [ Params.Bands(b) Params.Wintime(w) Params.Maskers(m) Params.TMR(t)];
                    T(n) = sum((squeeze(ConditionList(:,1))==cond(1))&(squeeze(ConditionList(:,2))==cond(2))&(squeeze(ConditionList(:,3))==cond(3))&(squeeze(ConditionList(:,4))==cond(4)));
                    ConditionList(n,:) = cond;
                end
            end
        end
    end
    ConditionList = repmat(ConditionList,[Params.TrialsPerCondition 1]);

    Params.ConditionList = ConditionList;
    clear ConditionList n b w m t
    
    %Talker Settings:
    %----------------
    Params.target_gender = 'Female';
    Params.talker_condition = 'Constant';
    Params.Talker_List = talker_list;
    Params.Female_Talker_List = female_talker_list;
    Params.Male_Talker_List = male_talker_list;
    Params.Total_Talkers = length(talker_list);
    Params.Total_Female_Talkers = length(female_talker_list);
    Params.Total_Male_Talkers = length(male_talker_list);
    
    %Progress Tracking:
    %------------------
    Params.current_block = 1;
    Params.current_trial = 1;
    
    %Results Priming:
    %----------------
    Results.Response = []; %response
    Results.clock_start = []; %array storing the start of response
    Results.clock_end = []; %array storing the end of response
    
    save(subject_file_name,'Params','Results')
else
    disp(['Continuing with data collection from previous sessions for ',subject_ID])
    load(subject_file_name);
    rand('twister',Params.rand_seed);
end

%% TDT Initialization
%---------------
maxduration = 5; % in seconds
maxspeechpts = round(maxduration*sample_frequency);
IDs = tdt_setup;
if ~strcmp(IDs.DAC_type,'SC')
    
    tdt_1v = 2^15/10; %MATLAB to TDT scale factor to ensure 1V-RMS [2^15
    %(signed 16-BIT) divied by 10 for D/A output range]
    
    %always start with attenuators muted and set to AC mode
    for chan=1:4
        S232('PA4mute',chan);
        S232('PA4ac',chan);
    end
    
    S232('DA3srate',1,1/sample_frequency*1e6);         % DAC sample period
    DAinfo.mcode = sum(IDs.DAC([1 2 3 4]));
    S232('DA3mode',1,DAinfo.mcode);             % Set the mode
    
    %NOW JUST RIGHT AND LEFT EARS
    playlist = 100;
    LeftTargetChanID = 101;
    LeftMaskerChanID = 102;
    RightTargetChanID = 103;
    RightMaskerChanID = 104;
    
    S232('allot16',LeftTargetChanID,maxspeechpts);
    S232('allot16',LeftMaskerChanID,maxspeechpts);
    S232('allot16',RightTargetChanID,maxspeechpts);
    S232('allot16',RightMaskerChanID,maxspeechpts);
    S232('allot16',playlist,5); %for play specification list for mplay
    S232('dpush',5);
    
    S232('make',0,LeftTargetChanID);
    S232('make',1,LeftMaskerChanID);
    S232('make',2,RightTargetChanID);
    S232('make',3,RightMaskerChanID);
    S232('make',4,0);
    S232('qpop16',playlist);
end

%Set mode for response word order:
%---------------------------------
if strcmp(Params.word_order,'Random')
    gui_word_mode = 'random';
else
    gui_word_mode = 'off';
end

%% DATA COLLECTION
%-------------------------------------------------------
%BLOCK LOOP:
%-------------------------------------------------------
for n_block = Params.current_block : Params.TotalBlocks
    
    %Initialize Subject Response GUI:
    %--------------------------------
    gui_text = {['Block ',num2str(Params.current_block),' of ',num2str(Params.TotalBlocks)],...
        ' ','Please press the start button to begin.'};
    BUG_touch_response_GUI('start',gui_word_mode,gui_text,response_display_mode,' ',[]);
    
    %-------------------------------------------------------------
    %TRIAL LOOP:
    %-------------------------------------------------------------
    if Params.current_trial == 1
        RandomTrialIndex = randperm(Params.TrialsPerBlock);
        Params.TrialIndex(Params.current_block,:) = RandomTrialIndex;
    else
        RandomTrialIndex = Params.TrialIndex(Params.current_block,:);
    end
    for n_trial = Params.current_trial : Params.TrialsPerBlock
        
        %Time-window and Band condition for current trial:
        %-------------------------------------------------
        Bands = Params.ConditionList(RandomTrialIndex(n_trial),1);
        Wintime = Params.ConditionList(RandomTrialIndex(n_trial),2);
        WhichMasker = Params.ConditionList(RandomTrialIndex(n_trial),3);
        WhichTMR = Params.ConditionList(RandomTrialIndex(n_trial),4);
        %Target Talker List:
        %-------------------
        switch Params.target_gender
            case 'Female'
                target_talker_list = Params.Female_Talker_List;
            case 'Male'
                target_talker_list = Params.Male_Talker_List;
            case 'Both'
                target_talker_list = Params.Talker_List;
        end
        number_of_target_talkers = length(target_talker_list);
        
        %Generate talker word lists for current trial:
        %---------------------------------------------
        switch Params.talker_condition
            case 'Constant' %same talker across words
                %Shuffle list:
                target_talker_temp = target_talker_list(randperm(number_of_target_talkers));
                masker_talker_temp = target_talker_temp(2);
                target_talker_temp = target_talker_temp(1);                
                
                target_talkers = target_talker_temp*ones(1,5);
                masker_talkers = masker_talker_temp*ones(1,5);
            case 'Different'
                %Shuffle list:
                target_talker_temp = target_talker_list(randperm(number_of_target_talkers));
                target_talkers = target_talker_temp(1:5);                
                masker_talkers = target_talker_temp(6:10);
        end
        
        Results.target_talkers(n_block,n_trial,:) = target_talkers;
        Results.masker_talkers(n_block,n_trial,:) = masker_talkers;
        
        %Generate column indices:
        %------------------------
        switch Params.word_order
            case 'Random' %random column order
                col_list_target = randperm(5);
                col_list_masker = randperm(5);
            case 'Syntactic' %syntactically correct
                col_list_target = 1:5;
                col_list_masker = 1:5;
        end
        Results.col_list_target(n_block,n_trial,:) = col_list_target;
        Results.col_list_masker(n_block,n_trial,:) = col_list_masker;
        
        %Loop through the 5 word columns:
        %--------------------------------
        Hfreq_target = [];
        Hmag_target = [];
        row_list_target = zeros(1,5);
        
        Hfreq_masker = [];
        Hmag_masker = [];
        row_list_masker = zeros(1,5);
        
        Ltarget = 0;
        Lmasker = 0;
        for n_col = 1:5
            
            %Row selections: (with fixed target call sign)
            %---------------            
            if n_col ~= 1
                row_temp = randperm(8);
                row_list_target(n_col) = row_temp(1);
                row_list_masker(n_col) = row_temp(2);
            else
                row_temp = randperm(7)+1;
                row_list_target(n_col) = 1;
                row_list_masker(n_col) = row_temp(2);
            end
            
            target_word_text{n_col} = MBUG_word_array{row_list_target(n_col),col_list_target(n_col)};
            masker_word_text{n_col} = MBUG_word_array{row_list_masker(n_col),col_list_masker(n_col)};
            %Load the target word:
            %---------------------
            if target_talkers(n_col) < 10
                load([processed_stim_directory,'\MBUG_T0',num2str(target_talkers(n_col)),...
                    '_',num2str(row_list_target(n_col)),'_',num2str(col_list_target(n_col)),'_B',num2str(Bands),'_TW',num2str(Wintime)]);
            else
                load([processed_stim_directory,'\MBUG_T',num2str(target_talkers(n_col)),...
                    '_',num2str(row_list_target(n_col)),'_',num2str(col_list_target(n_col)),'_B',num2str(Bands),'_TW',num2str(Wintime)]);
            end
            
            %Extract signal information and store:
            %-------------------------------------
            Hfreq_temp = signal_win.HILBERT_FREQUENCY;
            Hmag_temp = signal_win.HILBERT_MAGNITUDE;
            
            Ltarget(n_col) = size(Hfreq_temp,2);
            Hfreq_target = [Hfreq_target Hfreq_temp];
            Hmag_target = [Hmag_target Hmag_temp];
            clear Hmag_temp Hphs_temp
            
            
            % 1 = another talker, 2 = another talker, time-reversed, 3 = noise
            %Load the masker word:
            %---------------------
            if masker_talkers(n_col) < 10
                load([processed_stim_directory,'\MBUG_T0',num2str(masker_talkers(n_col)),...
                    '_',num2str(row_list_masker(n_col)),'_',num2str(col_list_masker(n_col)),'_B',num2str(Bands),'_TW',num2str(Wintime)]);
            else
                load([processed_stim_directory,'\MBUG_T',num2str(masker_talkers(n_col)),...
                    '_',num2str(row_list_masker(n_col)),'_',num2str(col_list_masker(n_col)),'_B',num2str(Bands),'_TW',num2str(Wintime)]);
            end
            
            %Extract signal information and store:
            %-------------------------------------
            Hfreq_temp = signal_win.HILBERT_FREQUENCY;
            Hmag_temp = signal_win.HILBERT_MAGNITUDE;
            
            Lmasker(n_col) = size(Hfreq_temp,2);
            Hfreq_masker = [Hfreq_masker Hfreq_temp];
            Hmag_masker = [Hmag_masker Hmag_temp];
            
          
            
            clear Hmag_temp Hphs_temp
        end
        
        %ASSEMBLE THE TARGET AND MASKER
        %---------------------------------------
        switch WhichMasker
            case {1,2}
                tcolposi = 1;
                y_targ = [];
                mcolposi = 1;
                y_mask = [];
                for n_col = 1 : 5
                    
                    % TARGET
                    Hmag_targettmp = squeeze(Hmag_target(:,tcolposi : tcolposi + Ltarget(n_col)-1));
                    Hfreq_targettmp = squeeze(Hfreq_target(:,tcolposi : tcolposi + Ltarget(n_col)-1));
                    tcolposi = tcolposi + Ltarget(n_col)-1;
                    [nH,mH] = size(Hmag_targettmp);
                    timewindow_env = signal_win.timewindow_env; % makes a cosine ramped envelope
                    Lwin = length(timewindow_env); %length of a time window in samples
                    y_target = zeros(mH,Lwin);
                    for n_band = 1:nH
                        y_target = y_target + ...
                            cos(2*pi*Hfreq_targettmp(n_band,:)'*(1:Lwin)/sample_frequency).*...
                            ((Hmag_targettmp(n_band,:))'*ones(1,Lwin)).*...
                            (ones(mH,1)*timewindow_env);
                    end
                    %Reshape from time windows:
                    %--------------------------
                    y_target = reshape(y_target',1,mH*Lwin);
                    
                    
                    % MASKER
                    Hmag_maskertmp = squeeze(Hmag_masker(:,mcolposi : mcolposi + Lmasker(n_col)-1));
                    Hfreq_maskertmp = squeeze(Hfreq_masker(:,mcolposi : mcolposi + Lmasker(n_col)-1));
                    mcolposi = mcolposi + Lmasker(n_col)-1;
                    
                    [nH,mH] = size(Hmag_maskertmp);
                    timewindow_env = signal_win.timewindow_env; % makes a cosine ramped envelope
                    Lwin = length(timewindow_env); %length of a time window in samples
                    y_masker = zeros(mH,Lwin);
                    for n_band = 1:nH
                        y_masker = y_masker + ...
                            cos(2*pi*Hfreq_maskertmp(n_band,:)'*(1:Lwin)/sample_frequency).*...
                            ((Hmag_maskertmp(n_band,:))'*ones(1,Lwin)).*...
                            (ones(mH,1)*timewindow_env);
                    end
                    %Reshape from time windows:
                    %--------------------------
                    y_masker = reshape(y_masker',1,mH*Lwin);
                    
                    
                    y_target = [y_target,zeros(1,length(y_masker)-length(y_target))];
                    if WhichMasker == 1 %a different word from the same column as masker
                        y_masker = [y_masker,zeros(1,length(y_target)-length(y_masker))];
                    else %a different + time reversed word from the same column as masker
                        y_masker = [fliplr(y_masker),zeros(1,length(y_target)-length(y_masker))];
                    end
                    
                    y_targ = [y_targ, y_target];
                    y_mask = [y_mask, y_masker];
                    
                end
                clear y_target
                y_target = y_targ;
                clear y_targ
                clear y_masker
                y_masker = y_mask;
                clear y_mask
            case 3 %speech shaped noise
                tcolposi = 1;
                y_targ = [];
                mcolposi = 1;
                y_mask = [];
                for n_col = 1 : 5
                    % TARGET
                    Hmag_targettmp = squeeze(Hmag_target(:,tcolposi : tcolposi + Ltarget(n_col)-1));
                    Hfreq_targettmp = squeeze(Hfreq_target(:,tcolposi : tcolposi + Ltarget(n_col)-1));
                    tcolposi = tcolposi + Ltarget(n_col)-1;
                    [nH,mH] = size(Hmag_targettmp);
                    timewindow_env = signal_win.timewindow_env; % makes a cosine ramped envelope
                    Lwin = length(timewindow_env); %length of a time window in samples
                    y_target = zeros(mH,Lwin);
                    for n_band = 1:nH
                        y_target = y_target + ...
                            cos(2*pi*Hfreq_targettmp(n_band,:)'*(1:Lwin)/sample_frequency).*...
                            ((Hmag_targettmp(n_band,:))'*ones(1,Lwin)).*...
                            (ones(mH,1)*timewindow_env);
                    end
                    %Reshape from time windows:
                    %--------------------------
                    y_target = reshape(y_target',1,mH*Lwin);
                    
                    
                    % MASKER
                    Hmag_maskertmp = squeeze(Hmag_masker(:,mcolposi : mcolposi + Lmasker(n_col)-1));
                    Hfreq_maskertmp = squeeze(Hfreq_masker(:,mcolposi : mcolposi + Lmasker(n_col)-1));
                    mcolposi = mcolposi + Lmasker(n_col)-1;
                    [nH,mH] = size(Hmag_maskertmp);
                    timewindow_env = signal_win.timewindow_env; % makes a cosine ramped envelope
                    Lwin = length(timewindow_env); %length of a time window in samples
                    y_masker = zeros(mH,Lwin);
                    for n_band = 1:nH
                        y_masker = y_masker + ...
                            cos(2*pi*Hfreq_maskertmp(n_band,:)'*(1:Lwin)/sample_frequency).*...
                            ((Hmag_maskertmp(n_band,:))'*ones(1,Lwin)).*...
                            (ones(mH,1)*timewindow_env);
                    end
                    %Reshape from time windows:
                    %--------------------------
                    y_masker = reshape(y_masker',1,mH*Lwin);
                    
                    phases = angle(fft(rand(size(y_masker))));
                    
                    tmprms = sqrt(mean(y_masker.^2));
                    
                    y_masker = real(ifft(abs(fft(y_masker)).*exp(1i.*phases)));
                    yy = tukeywin(length(y_masker),round(2e-3*sample_frequency)/length(y_masker));
                    y_masker = yy'.*y_masker;
                    y_masker = y_masker/sqrt(mean(y_masker.^2)).*tmprms;
                    
                    y_target = [y_target,zeros(1,length(y_masker)-length(y_target))];
                    y_masker = [y_masker,zeros(1,length(y_target)-length(y_masker))];
                   
                    y_targ = [y_targ, y_target];
                    y_mask = [y_mask, y_masker];
                end
                clear y_target
                y_target = y_targ;
                clear y_targ
                clear y_masker
                y_masker = y_mask;
                clear y_mask
        end
        
        
        clear Hfreq_target Hmag_target  ...
            timewindow_env signal_win input_param filter_param row_list_target
        
        RMS_targetalone = rms(y_target);
        RMS_masker = rms(y_masker);
        RMS_targetplusmasker = rms(y_target+y_masker);
       
         % this is a change in wording: y_target is really the acoustic mix
        % of target plus masker
        y_target = y_target + 10^(WhichTMR/20)*y_masker;
        RMS_target = rms(y_target);
       
        
        %Prime the subject prior to starting stimulus
        %presentation:
        %--------------------------------------------
        gui_name = ['Trial ',num2str(n_trial),' of ',num2str(Params.TrialsPerBlock)]; %to be display at the top of the GUI
        BUG_touch_response_GUI('hide',gui_word_mode,'Please listen...',response_display_mode,gui_name,[]);
        pause(50e-3)
        
        if ~strcmp(IDs.DAC_type,'SC')
            
            % TDT Playback:
            %--------------
            S232('PA4atten',1,Params.target_attenuation_dB); %Left Target Attenuation
            S232('PA4atten',3,Params.target_attenuation_dB); %Right Target Attenuation
            
            dBSPL_1V_RMS = 113; %1V @ rms = 1 && [att = 0] == 103 dB SPL
            
            digital_attenuation_dB = -10 + 20*log10(10/MaxPointPeak);  %ensures that the max peak does not go above 10V
            
            signal_RMS_dB = 20*log10(RMS_target);
            
            signal_presentation_level = dBSPL_1V_RMS + ... %[dB SPL output level] = [dB SPL for a 1V RMS signal] +
                signal_RMS_dB + ... %[target dB SPL scaling based on the signal RMS] +
                digital_attenuation_dB - ... %[digital attenuation to ensure 10V max peak] +
                Params.target_attenuation_dB;      %[PA4 attenuation set at the beginning of the session]
            
            target_signal = y_target*tdt_1v*10^(digital_attenuation_dB/20);
            pushf_length = length(target_signal);
            
            %Move the signals to the buffer:
            %-------------------------------
            
            if subject_ear == 1
                S232('push16',target_signal,pushf_length);
                %            S232('qdup')
                S232('qpop16',LeftTargetChanID);
                S232('push16',0.*target_signal,pushf_length);
                S232('qpop16',RightTargetChanID);
            else
                S232('push16',0.*target_signal,pushf_length);
                %            S232('qdup')
                S232('qpop16',LeftTargetChanID);
                S232('push16',target_signal,pushf_length);
                S232('qpop16',RightTargetChanID);
            end
            S232('push16',target_signal*0,pushf_length);
            S232('qdup')
            S232('qpop16',LeftMaskerChanID);
            S232('qpop16',RightMaskerChanID);
            
            
            S232('mplay',playlist);
            S232('DA3npts',1,pushf_length)
            S232('DA3arm', 1);
            
            S232('DA3go', 1);
            pause(0.95*pushf_length/sample_frequency)
            while S232('DA3status',1) ~= 0,end      % wait for DA conversion to be over
            S232('DA3stop',1);
            
            
            
            
            
        else
            soundsc([y_target; y_target]',sample_frequency);
            pause(length(y_target)/sample_frequency);
            signal_presentation_level = -13;
        end
        clear y_target y_masker RE LE
        
        %Obtain response and save state:
        %-------------------------------
        Results.clock_start(n_block,n_trial,:) = clock; %store time when response begins
        [resp_matrix,resp_list] = BUG_touch_response_GUI('trial',gui_word_mode,'Please respond...',response_display_mode,gui_name,[]);
        Results.clock_end(n_block,n_trial,:) = clock; %store time when response ends
        
        %Track performance:
        %------------------
        nwcorr = 0;
        for n_resp = 1:5
            [n_col,n_row] = find(resp_matrix==n_resp);
            response_word_text{n_col} = MBUG_word_array_sorted{n_row,n_col};
            if strcmp(MBUG_word_array_sorted{n_row,n_col},target_word_text{n_col})
                if n_resp>1
                    nwcorr = nwcorr + 1;
                end
            end
        end
        
        Results.signal_presentation_level(n_block,n_trial) = signal_presentation_level;
        
        Results.response_list{n_block,n_trial} = resp_list;
        Results.response_word_text{n_block,n_trial} = response_word_text;
        Results.target_word_text{n_block,n_trial} = target_word_text;
        
        Results.CorrectArray(n_block,n_trial,:) = strcmp(response_word_text(1:5),target_word_text(1:5));
        Results.PercentCorrect(n_block,n_trial) = sum(strcmp(response_word_text(1:5),target_word_text(1:5)))/5;
        Results.Masker(n_block,n_trial) = WhichMasker;
        Results.TMR(n_block,n_trial) = WhichTMR;
        
        %Give feedback:
        %--------------
        feedback.target = target_word_text;
        feedback.response = response_word_text;
        gui_name = ['Trial ',num2str(n_trial),' of ',num2str(Params.TrialsPerBlock)]; %to be display at the top of the GUI
        BUG_touch_response_GUI('feedback',gui_word_mode,'Please listen...',response_display_mode,gui_name,feedback);
        
        Params.current_trial = n_trial+1;
        save(subject_file_name,'Params','Results')
    end
    Params.current_block = Params.current_block + 1;
    Params.current_trial = 1;
    save(subject_file_name,'Params','Results')
    
    %Display progress at command line:
    %---------------------------------
    BUG_touch_response_GUI('vis',gui_word_mode,' ',response_display_mode,' ',[]);
    clc
    disp(' Block      Percent')
    disp(' Number     Correct')
    disp(' ------     -------')
    for n_block = 1:Params.current_block-1
        pc_text = num2str(round(mean(Results.PercentCorrect(n_block,:),2)*100));
        block_text = num2str(n_block);
        if n_block<10
            disp(['  ',num2str(n_block),'          ',pc_text,'%'])
        else
            disp(['  ',num2str(n_block),'         ',pc_text,'%'])
        end
    end
    disp(' ')
    disp('Please press enter to continue...')
    pause
    BUG_touch_response_GUI('vis',gui_word_mode,' ',response_display_mode,' ',[]);
    
    
end
disp('Thankyou! You have finished the session.  You may now exit the booth.')
disp(['Experimenter: Make sure to set the headphone attenuator back to -10 dB'])

BUG_touch_response_GUI('close',gui_word_mode,' ',response_display_mode,gui_name,feedback);

%Close TDT link:
%---------------
if ~strcmp(IDs.DAC_type,'SC')
    tdt_close;
end
