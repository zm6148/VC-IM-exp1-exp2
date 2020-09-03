%--------------------------------------------------------------------------
% SpeechOnSpeech_mainexperiment.m
%--------------------------------------------------------------------------
%
% BUG words, vocoded
% with masker (different band speech, different band noise)
%--------------------------------------------------------------------------
% Antje Ihlefeld Jan 2018
%--------------------------------------------------------------------------

%% Initialization:
%  ---------------
clear
close all
clc

% random seed initialization
Params.rand_seed = sum(100*clock);
rng(Params.rand_seed);

%% Experimental Parameters (non-subject specific):
%-------------------------------------------------
Params.Fs = 44.1e3; %sample frequency (Hz)

%Values for each word, talker, condition:
%------------------------------------------------------------------
raw_stim_directory = '.\RawSounds\BU Edited Words'; %stimulus directory
% use a subset of talkers from the corpus. informal listening suggests that processed utterances from this subset of
% talkers are more intelligible than the rest of the talkers (Kidd et al., 2009). Kidd Jr, G., Streeter, T.M., Ihlefeld, A., Maddox, R.K. and Mason, C.R., 2009. The intelligibility of pointillistic speech. The Journal of the Acoustical Society of America, 126(6), pp.EL196-EL201.
male_talker_list = [4 5 8 17];
female_talker_list= [11 14 16 18];
talker_list = [female_talker_list]; %only use female talkers to increase informational masking
wordorder_flag = 1; %1 for syntactically correct and 0 for random column
load('MBUG_word_array'); %MBUG_word_array
MBUG_word_array_sorted = {'Bob'	'bought'	'two'	'big'	'bags';...
'Gene'	'found'	'three'	'cheap'	'cards';...
'Jane'	'gave'	'four'	'green'	'gloves';...
'Jill'	'held'	'five'	'hot'	'hats';...
'Lynn'	'lost'	'six'	'new'	'pens';...
'Mike'	'saw'	'eight'	'old'	'shoes';...
'Pat'	'sold'	'nine'	'red'	'socks';...
'Sue'	'took'	'ten'	'small'	'toys'};
response_display_mode = 'light'; % 'dark' - white text on black

%% Subject session parameters:
%  ---------------------------
subject_ID = input('Subject ID: ','s');
subject_file_name = ['.\data\Quiet_Subj',subject_ID];

if exist([subject_file_name,'.mat'],'file') ~= 2
    
    %Test conditions:
    %----------------
    Params.Bands = [16];
    Params.Maskers = [1 2];% 1 = same talker, 2 = noise, 3 = another talker
    Params.MaskerFullNames = {'Different Band Different Talker';'Different Band Noise';'Different Band Same Talker'};
    Params.MaskerNames = {'DBDT';'DBN';'DBST'};
    Params.TMR = [-20 -20];
    Params.TotalConditions = length(Params.Bands)*length(Params.Maskers)*length(Params.TMR);
    Params.TrialsPerCondition = 5;%5
    Params.TrialsPerBlock = Params.TotalConditions*Params.TrialsPerCondition;
    Params.TotalBlocks = 2;%8
    Params.word_order = 'Syntactic';
    Params.talker_condition = 'Constant';%'Different'
    n =  0;
    for b = 1 : length(Params.Bands)
        for m = 1 : length(Params.Maskers)
            for t = 1 : length(Params.TMR)
                n = n + 1;
                ConditionList(n,:) = [ Params.Bands(b)  Params.Maskers(m) Params.TMR(t)];
            end
        end
    end
    Params.ConditionList = repmat(ConditionList,[Params.TrialsPerCondition 1]);
    clear ConditionList n b m t
    
    %Talker Settings:
    %----------------
    Params.target_gender = 'Female';
    Params.Talker_List = talker_list;
    Params.Female_Talker_List = female_talker_list;
    Params.Male_Talker_List = male_talker_list;
    Params.Total_Talkers = length(talker_list);
    
    %Vocoding Parameters
    Greenwood = inline('1/0.06*log10((f/165.4)+1)','f');
    invGreenwood = inline('165.4*(10.^(0.06*x)-1)','x');
    
    for which_voc = Params.Bands
        % analysis filters
        VocParams(which_voc).FMIN = 300;
        VocParams(which_voc).FMAX = 10000;
        switch Params.Bands
            case 32
                VocParams(which_voc).Nbands = 125;
            case 16
                VocParams(which_voc).Nbands = 61;
            case 8
                VocParams(which_voc).Nbands = 29;
        end
        f = [VocParams(which_voc).FMIN VocParams(which_voc).FMAX];
        x = linspace(Greenwood(f(1)),Greenwood(f(end)),2*VocParams(which_voc).Nbands+1); %corner freqs of linear spacing of 8 electrodes along the basilar membrane
        f2 = round(invGreenwood(x));
        VocParams(which_voc).F_octave_spacing = log2(f2(2:end)./f2(1:end-1));
        VocParams(which_voc).CF = f2(2:2:end);
        VocParams(which_voc).FLO = f2(1:2:end-1);
        VocParams(which_voc).FHI = f2(3:2:end);
        VocParams(which_voc).CF = VocParams(which_voc).CF(1:4:end);
        VocParams(which_voc).FLO = VocParams(which_voc).FLO(1:4:end);
        VocParams(which_voc).FHI = VocParams(which_voc).FHI(1:4:end);
        
        %synthesis filters
        VocParams(which_voc).FMINsy = VocParams(which_voc).FMIN;%1200;
        VocParams(which_voc).FMAXsy = VocParams(which_voc).FMAX + VocParams(which_voc).FMINsy - VocParams(which_voc).FMIN;
        VocParams(which_voc).Nbandssy = VocParams(which_voc).Nbands;
        f = [VocParams(which_voc).FMINsy VocParams(which_voc).FMAXsy];
        x = linspace(Greenwood(f(1)),Greenwood(f(end)),2*VocParams(which_voc).Nbandssy+1); %corner freqs of linear spacing of 8 electrodes along the basilar membrane
        f2 = round(invGreenwood(x));
        VocParams(which_voc).F_octave_spacingsy = log2(f2(2:end)./f2(1:end-1));
        VocParams(which_voc).CFsy = f2(2:2:end);
        VocParams(which_voc).FLOsy = f2(1:2:end-1);
        VocParams(which_voc).FHIsy = f2(3:2:end);
        VocParams(which_voc).CFsy = VocParams(which_voc).CFsy(1:4:end);
        VocParams(which_voc).FLOsy = VocParams(which_voc).FLOsy(1:4:end);
        VocParams(which_voc).FHIsy = VocParams(which_voc).FHIsy(1:4:end);
        VocParams(which_voc).Nbands = length(VocParams(which_voc).CF);
        
        VocParams(which_voc).Ramp_duration_in_ms = 20;% 20 ms ramp duration
        VocParams(which_voc).Ramp_duration_in_samples = round(VocParams(which_voc).Ramp_duration_in_ms*1e-3*Params.Fs);
        bw = blackman(2*VocParams(which_voc).Ramp_duration_in_samples);
        VocParams(which_voc).rampup = bw(1:VocParams(which_voc).Ramp_duration_in_samples);
        VocParams(which_voc).rampdn = bw(VocParams(which_voc).Ramp_duration_in_samples+1:end);
        clear bw dur
    end
    
    %Progress Tracking:
    %------------------
    Params.current_block = 1;
    Params.current_trial = 1;
    
    %Results Priming:
    %----------------
    Results.Response = []; %response
    Results.clock_start = []; %array storing the start of response
    Results.clock_end = []; %array storing the end of response
    
    save(subject_file_name,'Params','VocParams','Results')
else
    disp(['Continuing with data collection from previous sessions for ',subject_ID])
    load(subject_file_name);
    rng(Params.rand_seed);
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
        for which_band = 1:Bands
            
            %analysis filter
            [bx,ax] = butter(3, [VocParams(Params.Bands).FLO(which_band) VocParams(Params.Bands).FHI(which_band)]./(Params.Fs/2),'bandpass');
            ban{which_band} = bx;
            aan{which_band}= ax;
            % synthesis filter
            [by,ay] = butter(3, [VocParams(Params.Bands).FLOsy(which_band) VocParams(Params.Bands).FHIsy(which_band)]./(Params.Fs/2),'bandpass');
            bsy{which_band} = by;
            asy{which_band}= ay;
            clear ay by ax bx
        end
        WhichMasker = Params.ConditionList(RandomTrialIndex(n_trial),2);
        WhichTMR = Params.ConditionList(RandomTrialIndex(n_trial),3);
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
        row_list_target = zeros(1,5);
        
        row_list_masker = zeros(1,5);
        
        Ltarget = 0;
        Lmasker = 0;
        
        %assign random half of bands to target, other half to masker
        current_bands = randperm(Bands);
        half_ind = round(Bands/2);
        Params.band_list_target(n_block,n_trial,:) = sort(current_bands(1:half_ind));
        Params.band_list_masker(n_block,n_trial,:) = sort(current_bands(half_ind:end));
        
        clear half_ind
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
                [yraw] = audioread([raw_stim_directory,'\T0',num2str(target_talkers(n_col)),...
                    '\BUG_T0',num2str(target_talkers(n_col)),...
                    '_',num2str(row_list_target(n_col)),'_',num2str(col_list_target(n_col)),'.wav']);
            else
                [yraw] = audioread([raw_stim_directory,'\T',num2str(target_talkers(n_col)),...
                    '\BUG_T',num2str(target_talkers(n_col)),...
                    '_',num2str(row_list_target(n_col)),'_',num2str(col_list_target(n_col)),'.wav']);
            end
            
            %Vocode signal and store information:
            %-------------------------------------
            yraw = yraw./rms(yraw);
            traw = 0 : 1/Params.Fs : (length(yraw)-1)/Params.Fs;
            SVC = 0.*traw;%sine-vocoded sound
            for which_band = Params.band_list_target(n_block,n_trial,:)
                % analysis and envelope extraction
                tmp = filtfilt(ban{which_band},aan{which_band},yraw);
                env = abs(hilbert(tmp))';
                
                %diotic carrier tone
                tmp = env.*sin(2*pi*VocParams(Params.Bands).CFsy(which_band)*traw);
                tmp = filter(bsy{which_band},asy{which_band},tmp);
                SVC = SVC + tmp;
            end
            Ltarget(n_col) = length(SVC);
            bw = [VocParams(which_voc).rampup' ones(1,length(SVC)-2*VocParams(which_voc).Ramp_duration_in_samples) VocParams(which_voc).rampdn'];
            if size(bw)~=size(SVC)
                bw = bw';
            end
            target_token{n_col} = [bw.*SVC];
            clear which_band tmp env
            
            
            %Load the masker word:
            %---------------------
            if masker_talkers(n_col) < 10
                [yraw] = audioread([raw_stim_directory,'\T0',num2str(masker_talkers(n_col)),...
                    '\BUG_T0',num2str(masker_talkers(n_col)),...
                    '_',num2str(row_list_masker(n_col)),'_',num2str(col_list_masker(n_col)),'.wav']);
            else
                [yraw] = audioread([raw_stim_directory,'\T',num2str(masker_talkers(n_col)),...
                    '\BUG_T',num2str(masker_talkers(n_col)),...
                    '_',num2str(row_list_masker(n_col)),'_',num2str(col_list_masker(n_col)),'.wav']);
            end
            
            %Vocode signal and store information:
            % 1 = same talker, 2 = noise, 3 = another talker
            %-------------------------------------            
            yraw = yraw./rms(yraw);
            traw = 0 : 1/Params.Fs : (length(yraw)-1)/Params.Fs;
            SVC = 0.*traw;%sine-vocoded sound
            for which_band = Params.band_list_target(n_block,n_trial,:)
            
                % analysis and envelope extraction
                tmp = filtfilt(ban{which_band},aan{which_band},yraw);
                env = abs(hilbert(tmp))';
                
                %diotic carrier tone
                tmp = env.*sin(2*pi*VocParams(Params.Bands).CFsy(which_band)*traw);
                tmp = filter(bsy{which_band},asy{which_band},tmp);
                SVC = SVC + tmp;
            end
            Lmasker(n_col) = length(SVC);
            clear which_band tmp env
            bw = [VocParams(which_voc).rampup' ones(1,length(SVC)-2*VocParams(which_voc).Ramp_duration_in_samples) VocParams(which_voc).rampdn']';
            
            if WhichMasker == 2
                DBN = randn(size(SVC)); DBN = DBN - mean(DBN);
                DBN = DBN/max(abs(DBN(:)));
                DBN = DBN/rms(DBN)*rms(SVC);% make sure that sine-vocoded masker and noise masker have the same RMS
                if size(bw)~=size(DBN)
                    bw = bw';
                end
                masker_token{n_col} = bw.*DBN;
                
            else
                if size(bw)~=size(SVC)
                    bw = bw';
                end
                masker_token{n_col} = bw.*SVC;
            end
        end
        
        %ASSEMBLE THE TARGET AND MASKER
        y_target = [];
        y_masker = [];
        for n_col = 1 : 5
            tt = target_token{n_col};
            mm = masker_token{n_col};
            % make the words equal duration and temporally centered
            dt = length(tt)-length(mm);
            ind1 = round(abs(dt)/2);
            if dt>0 %target word longer duration than masker word
                mm = [zeros(1,ind1),mm,zeros(1,abs(dt)-ind1)];
            else %masker word longer than target word
                tt = [zeros(1,ind1),tt,zeros(1,abs(dt)-ind1)];
            end
            if length(tt)~=length(mm)
                keyboard
            end
            y_target = [y_target, tt];
            y_masker = [y_masker, mm];
            clear mm tt
        end
        RMS_targetalone = rms(y_target);
        RMS_masker = rms(y_masker);
        RMS_targetplusmasker = rms(y_target+y_masker);
        
        % this is a change in wording: y_target is really the acoustic mix
        % of target plus masker no masker, only target
        y_mix = 0.*y_masker + 10^(WhichTMR/20)*y_target;
        RMS_mix = rms(y_mix);
        
        
        %Prime the subject prior to starting stimulus
        %presentation:
        %--------------------------------------------
        gui_name = ['Trial ',num2str(n_trial),' of ',num2str(Params.TrialsPerBlock)]; %to be display at the top of the GUI
        BUG_touch_response_GUI('hide',gui_word_mode,'Please listen...',response_display_mode,gui_name,[]);
        pause(50e-3)
        
        %%% continue HERE
        player_mix = audioplayer(y_mix,Params.Fs);
        playblocking(player_mix);
        
        clear y_target y_masker y_mix
        
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
        save(subject_file_name,'Params','VocParams','Results')
    end
    Params.current_block = Params.current_block + 1;
    Params.current_trial = 1;
    save(subject_file_name,'Params','VocParams','Results')
    
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
disp('Thank you! You have finished the session.  You may now exit the booth.')

BUG_touch_response_GUI('close',gui_word_mode,' ',response_display_mode,gui_name,feedback);


