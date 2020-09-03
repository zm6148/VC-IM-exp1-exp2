%--------------------------------------------------------------------------
% SpeechOnSpeech_DBS.m
%--------------------------------------------------------------------------
%
% BUG words, vocoded
% with masker (different band speech, different band noise)
%--------------------------------------------------------------------------
% Antje Ihlefeld Jan 2018
%--------------------------------------------------------------------------

%% Initialization:
clear
clc
close all
% results path (enter the real path here)
pth = '.\data\';
% all sessions that should be evaluated are listed in a cell array named
% SNs (Session Names)
% always start session name with 3-letter subject code
SNs = {'TLT_run1'};

% set threshold
treshold_5_7 = 0.5; %or 0.7 or 0.5

%% define sigmoid function
% Set up fittype and options.
ft = fittype( 'a/(1+exp(-b*x))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.957166948242946 0.485375648722841];

%% plot part
symb = {'o';'s';'<';'>';'o';'o'};
lw = 2;
clrs = 'bgrm';
for SN = 1 : length(SNs)
    
    subject_ID = SNs{SN};
    subjectInitials = subject_ID(1:3);% three-letter subject code
    file_name = [pth,'Masked_Subj',subject_ID];
    load(file_name);
    correct_cnt = zeros(length(Params.Maskers),length(Params.TMR));%initialize counter for correct trials
    trial_sum = correct_cnt;%initialize counter for total words across all trials of each masker configuration and TMR 
    num_blocks = size(Results.PercentCorrect,1);
    
    % treat each word individually
%     for n_block = 1 : num_blocks
%         trial_list_temp = Params.TrialIndex(n_block,:);%pulls out all trial indices for the current plot
%         num_trials = size(Results.PercentCorrect,2);%only looks at the completed trials (i.e., if subject stops early, ignore the un-performed trials)
%         for n_trial = 1:num_trials
%             n_masker = find(Params.Maskers == Params.ConditionList(trial_list_temp(n_trial),2));%finds the masker index number for that trial in that block
%             n_tmr = find(Params.TMR == Params.ConditionList(trial_list_temp(n_trial),3));%finds the tmr index number for that trial in that block
%             correct_cnt(n_masker,n_tmr) = correct_cnt(n_masker,n_tmr) + sum(Results.CorrectArray(n_block,n_trial,:));% counts the correct trials
%             trial_sum(n_masker,n_tmr) = trial_sum(n_masker,n_tmr) + length(Results.CorrectArray(n_block,n_trial,:));%(here: 5 words per trial)
%         end
%     end
    
    % treat 2 words together
    for n_block = 1 : num_blocks
        trial_list_temp = Params.TrialIndex(n_block,:);%pulls out all trial indices for the current plot
        num_trials = size(Results.PercentCorrect,2);%only looks at the completed trials (i.e., if subject stops early, ignore the un-performed trials)
        for n_trial = 1:num_trials
            n_masker = find(Params.Maskers == Params.ConditionList(trial_list_temp(n_trial),2));%finds the masker index number for that trial in that block
            n_tmr = find(Params.TMR == Params.ConditionList(trial_list_temp(n_trial),3));%finds the tmr index number for that trial in that block
            % only both correct will be count as correct
            if Results.CorrectArray(n_block,n_trial,1) == 1 && Results.CorrectArray(n_block,n_trial,2) == 1
                correct_cnt(n_masker,n_tmr) = correct_cnt(n_masker,n_tmr) + 1;% counts the correct trials
            end
            trial_sum(n_masker,n_tmr) = trial_sum(n_masker,n_tmr) + 1;%(here: 5 words per trial)
        end
    end
    
    %% fit with sigmoid function
    
    
    speech_masker_correct = (correct_cnt(1,:) ) ./ trial_sum(1,:) * 100; % + up1;
    noise_masker_correct = (correct_cnt(2,:) ) ./ trial_sum(2,:) * 100; % + up2;
    
    
    % Fit model to data.
    xData = Params.TMR';
    [fitresult_speech, gof_speech] = fit( xData, speech_masker_correct', ft, opts );
    [fitresult_noise, gof_noise] = fit( xData, noise_masker_correct', ft, opts );
    
    % build matrix for psignifit
    % data =    [TMR, n_correct, total];
    % build data for speech first
    % build data for noise
    TMR = Params.TMR';
    data_speech =  cat(2, correct_cnt(1,:)', trial_sum(1,:)') ;
    data_noise =  cat(2, correct_cnt(2,:)', trial_sum(2,:)') ;
    
    data_speech =  cat(2, TMR, data_speech) ;
    data_noise =  cat(2, TMR, data_noise) ;
    
    
    
    %%
    figure(SN),clf
    hold on;
    
    % speech
    speech_a = fitresult_speech.a;
    speech_b = fitresult_speech.b;
    fitted_speech = speech_a ./ (1 + exp(-speech_b * [xData(1):1:xData(end)]));
    intersect_50_at_x_speech = log((speech_a / 50) - 1) / (-speech_b);
    
    % noise
    noise_a = fitresult_noise.a;
    noise_b = fitresult_noise.b;
    fitted_noise = noise_a ./ (1 + exp(-noise_b * [xData(1):1:xData(end)]));
    intersect_50_at_x_noise = log((noise_a / 50) - 1) / (-noise_b);
    
    p = plot(Params.TMR,correct_cnt./trial_sum*100,['',symb{SN}],'linewidth',lw);
    cc = get(p,'color');
    for ppp = 1 : length(p)
        set(p(ppp),'markerfacecolor',cc{ppp});
    end
    
    plot([xData(1):1:xData(end)], fitted_speech, 'color', cc{1});
    plot([xData(1):1:xData(end)], fitted_noise, 'color', cc{2});
    
    xlabel('TMR');
    ylabel('Percent Correct')
    %legend(Params.MaskerNames)
    ylim([10 105])
    set(gca,'xtick',Params.TMR)
    tstr = ['Subject: ' upper(subjectInitials) ' noise_x:' num2str(intersect_50_at_x_noise) ' speech_x:' num2str(intersect_50_at_x_speech)]; %' #Blocks: ' int2str(num_blocks) ' #Trials/block: ' int2str(num_trials)];
    tstr(tstr == '_') = '.';
    title(tstr);
    saveas(gcf,['.\figures\Results_',num2str(SN),'.pdf'],'pdf');
end



% The Psignifit 101
%close all;
%% save data in right format

% First we need the data in the format (x | nCorrect | total)
% As an example we use the following dataset from a 2AFC experiment with 90
% trials at each stimulus level. This dataset comes from a simple signal
% detection experiment.

% min_run1
% data_speech = [-20,0,16;-10,6,16;0,7,16;10,10,16;20,13,16];
% data_noise = [-20,1,16;-10,7,16;0,10,16;10,15,16;20,14,16];
% quiet = 0.98;

% taiga run1
% data_speech = [-20,4,16;-10,4,16;0,6,16;10,15,16;20,12,16];
% data_noise = [-20,3,16;-10,7,16;0,13,16;10,15,16;20,15,16];
% quiet = 0.95;

% TKI_run1
% data_speech = [-20,5,16;-10,9,16;0,8,16;10,12,16;20,12,16];
% data_noise = [-20,4,16;-10,7,16;0,12,16;10,15,16;20,13,16];
% quiet = 1;

% TKB_run1
% data_speech = [-20,2,16;-10,5,16;0,9,16;10,11,16;20,9,16];
% data_noise = [-20,1,16;-10,4,16;0,12,16;10,12,16;20,10,16];
% quiet = 0.98;

% TKI_run2
% data_speech = [-20,3,16;-10,5,16;0,5,16;10,11,16;20,10,16];
% data_noise = [-20,2,16;-10,9,16;0,14,16;10,12,16;20,14,16];
% quiet = 1;

% TKJ_run1
% data_speech = [-20,1,16;-10,0,16;0,5,16;10,6,16;20,10,16];
% data_noise = [-20,6,16;-10,6,16;0,12,16;10,13,16;20,14,16];
% quiet = 0.98;

% TKJ_run2
% data_speech = [-20,2,16;-10,4,16;0,4,16;10,7,16;20,13,16];
% data_noise = [-20,2,16;-10,10,16;0,10,16;10,15,16;20,14,16];
% quiet = 0.98;

% TKM_run2
% data_speech = [-20,3,16;-10,3,16;0,5,16;10,10,16;20,12,16];
% data_noise = [-20,2,16;-10,4,16;0,9,16;10,12,16;20,16,16];
% quiet = 0.95;

% TJM_run1
% data_speech = [-20,1,16;-10,2,16;0,6,16;10,11,16;20,7,16];
% data_noise = [-20,3,16;-10,6,16;0,9,16;10,13,16;20,13,16];
% quiet = 0.95;

% TKO_run1
% data_speech = [-20,0,16;-10,4,16;0,5,16;10,11,16;20,14,16];
% data_noise = [-20,2,16;-10,5,16;0,13,16;10,14,16;20,10,16];
% quiet = 0.95;

% TKO_run2
% data_speech = [-20,4,16;-10,11,16;0,9,16;10,12,16;20,13,16];
% data_noise = [-20,1,16;-10,3,16;0,9,16;10,7,16;20,9,16];
% quiet = 0.95;

% TIX_run1
% data_speech = [-20,2,16;-10,3,16;0,3,16;10,7,16;20,9,16];
% data_noise = [-20,3,16;-10,7,16;0,10,16;10,15,16;20,13,16];
% quiet = 0.98;

% TIX_run2
% data_speech = [-20,2,16;-10,5,16;0,6,16;10,6,16;20,16,16];
% data_noise = [-20,4,16;-10,10,16;0,9,16;10,13,16;20,13,16];
% quiet = 0.98;

% TKL_run1
% data_speech = [-20,2,16;-10,4,16;0,5,16;10,7,16;20,9,16];
% data_noise = [-20,2,16;-10,3,16;0,6,16;10,12,16;20,10,16];
% quiet = 0.98;

% TKL_run2
% data_speech = [-20,0,16;-10,8,16;0,2,16;10,5,16;20,6,16];
% data_noise = [-20,1,16;-10,7,16;0,11,16;10,13,16;20,14,16];
% quiet = 0.98;

% TKL_run2
% data_speech = [-20,1,16;-10,0,16;0,1,16;10,9,16;20,7,16];
% data_noise = [-20,1,16;-10,2,16;0,8,16;10,13,16;20,13,16];
% quiet = 0.83;

% TKK_run1
% data_speech = [-20,0,16;-10,5,16;0,3,16;10,7,16;20,13,16];
% data_noise = [-20,1,16;-10,8,16;0,10,16;10,15,16;20,13,16];
% quiet = 0.95;

% TKQ_run1
% data_speech = [-20,2,16;-10,3,16;0,2,16;10,11,16;20,12,16];
% data_noise = [-20,0,16;-10,3,16;0,9,16;10,12,16;20,10,16];
% quiet = 0.95;

% TKQ_run2
% data_speech = [-20,3,16;-10,3,16;0,4,16;10,7,16;20,12,16];
% data_noise = [-20,4,16;-10,7,16;0,11,16;10,12,16;20,12,16];
% quiet = 0.95;

% TKN_run1
% data_speech = [-20,1,16;-10,3,16;0,3,16;10,8,16;20,10,16];
% data_noise = [-20,2,16;-10,6,16;0,13,16;10,10,16;20,10,16];
% quiet = 0.95;

% TKR_run1
% data_speech = [-20,0,16;-10,3,16;0,7,16;10,10,16;20,16,16];
% data_noise = [-20,3,16;-10,6,16;0,10,16;10,15,16;20,16,16];
% quiet = 0.95;

% TJL_run1
% data_speech = [-20,2,16;-10,4,16;0,6,16;10,7,16;20,13,16];
% data_noise = [-20,2,16;-10,6,16;0,10,16;10,12,16;20,16,16];
% quiet = 0.98;

% TJF_run1
% data_speech = [-20,2,16;-10,2,16;0,7,16;10,10,16;20,14,16];
% data_noise = [-20,0,16;-10,7,16;0,10,16;10,14,16;20,15,16];
% quiet = 0.98;

% TKS_run2
% data_speech = [-20,3,16;-10,4,16;0,8,16;10,11,16;20,12,16];
% data_noise = [-20,3,16;-10,6,16;0,14,16;10,16,16;20,16,16];
% quiet = 1;

% TKP_run1
% data_speech = [-20,0,20;-10,3,20;0,3,20;10,14,20;20,15,20];
% data_noise = [-20,1,20;-10,2,20;0,7,20;10,17,20;20,15,20];
% quiet = 1;

% TKE_run1
% data_speech = [-20,5,20;-10,3,20;0,7,20;10,9,20;20,14,20];
% data_noise = [-20,2,20;-10,5,20;0,10,20;10,14,20;20,14,20];
% quiet = 0.98;

% TKU_run1
% data_speech = [-20,0,20;-10,4,20;0,9,20;10,16,20;20,16,20];
% data_noise = [-20,3,20;-10,6,20;0,17,20;10,18,20;20,16,20];
% quiet = 1;

% TKV_run1
% data_speech = [-20,1,20;-10,6,20;0,4,20;10,13,20;20,14,20];
% data_noise = [-20,2,20;-10,9,20;0,11,20;10,17,20;20,17,20];
% quiet = 0.98;

% TKW_run1
% data_speech = [-20,1,20;-10,2,20;0,6,20;10,5,20;20,15,20];
% data_noise = [-20,1,20;-10,5,20;0,12,20;10,16,20;20,16,20];
% quiet = 0.98;

% TLA_run1
% data_speech = [-20,1,20;-10,4,20;0,5,20;10,15,20;20,10,20];
% data_noise = [-20,3,20;-10,6,20;0,17,20;10,18,20;20,17,20];
% quiet = 0.93;

% TKY_run1
% data_speech = [-20,0,20;-10,2,20;0,4,20;10,7,20;20,11,20];
% data_noise = [-20,5,20;-10,2,20;0,9,20;10,11,20;20,14,20];
% quiet = 0.93;

% TKZ_run1
% data_speech = [-20,3,20;-10,4,20;0,5,20;10,10,20;20,10,20];
% data_noise = [-20,1,20;-10,5,20;0,10,20;10,10,20;20,15,20];
% quiet = 100;

% TLB_run1
% data_speech = [-20,1,20;-10,4,20;0,5,20;10,13,20;20,17,20];
% data_noise = [-20,4,20;-10,10,20;0,17,20;10,19,20;20,18,20];
% quiet = 100;

% TLC_run1
% data_speech = [-20,3,20;-10,2,20;0,5,20;10,8,20;20,18,20];
% data_noise = [-20,2,20;-10,4,20;0,16,20;10,15,20;20,19,20];
% quiet = 93;

% TLD_run1
% data_speech = [-20,1,20;-10,2,20;0,4,20;10,9,20;20,4,20];
% data_noise = [-20,2,20;-10,3,20;0,5,20;10,11,20;20,8,20];
% quiet = 90;

% TLH_run1
% data_speech = [-20,1,20;-10,3,20;0,7,20;10,11,20;20,15,20];
% data_noise = [-20,1,20;-10,7,20;0,12,20;10,18,20;20,16,20];
% quiet = 90;

% TLE_run1
% data_speech = [-20,0,20;-10,7,20;0,7,20;10,12,20;20,12,20];
% data_noise = [-20,0,20;-10,4,20;0,15,20;10,18,20;20,16,20];
% quiet = 98;

% TLF_run1
% data_speech = [-20,5,20;-10,8,20;0,9,20;10,12,20;20,15,20];
% data_noise = [-20,4,20;-10,10,20;0,15,20;10,18,20;20,19,20];
% quiet = 100;

% % TLI_run1
% data_speech = [-20,0,20;-10,2,20;0,3,20;10,14,20;20,16,20];
% data_noise = [-20,3,20;-10,7,20;0,10,20;10,15,20;20,17,20];
% quiet = 100;

% TLK_run1
% data_speech = [-20,3,20;-10,4,20;0,7,20;10,11,20;20,17,20];
% data_noise = [-20,4,20;-10,6,20;0,13,20;10,14,20;20,16,20];
% quiet = 98;

% TLM_run1
% data_speech = [-20,0,20;-10,6,20;0,13,20;10,10,20;20,15,20];
% data_noise = [-20,3,20;-10,9,20;0,14,20;10,17,20;20,12,20];
% quiet = 93;

% TLS_run1
% data_speech = [-20,0,20;-10,5,20;0,3,20;10,10,20;20,15,20];
% data_noise = [-20,1,20;-10,2,20;0,13,20;10,12,20;20,16,20];
% quiet = 74;

% TLO_run1
% data_speech = [-20,1,20;-10,1,20;0,8,20;10,11,20;20,13,20];
% data_noise = [-20,3,20;-10,10,20;0,11,20;10,15,20;20,15,20];
% quiet = 90;

% TLQ_run1
% data_speech = [-20,3,20;-10,5,20;0,6,20;10,12,20;20,14,20];
% data_noise = [-20,0,20;-10,8,20;0,13,20;10,13,20;20,15,20];
% quiet = 98;

% TLL_run1
% data_speech = [-20,3,20;-10,3,20;0,8,20;10,11,20;20,14,20];
% data_noise = [-20,1,20;-10,6,20;0,11,20;10,14,20;20,14,20];
% quiet = 98;

% TLT_run1
% data_speech = [-20,4,20;-10,5,20;0,7,20;10,9,20;20,11,20];
% data_noise = [-20,3,20;-10,7,20;0,12,20;10,11,20;20,12,20];
% quiet = 93;

% TLV_run1
% data_speech = [-20,1,20;-10,1,20;0,6,20;10,11,20;20,9,20];
% data_noise = [-20,3,20;-10,7,20;0,14,20;10,16,20;20,18,20];
% quiet = 95;

% TLW_run1
% data_speech = [-20,1,20;-10,3,20;0,6,20;10,9,20;20,14,20];
% data_noise = [-20,2,20;-10,6,20;0,11,20;10,18,20;20,15,20];
% quiet = 93;

% TMB_run1
% data_speech = [-20,1,20;-10,2,20;0,4,20;10,9,20;20,8,20];
% data_noise = [-20,1,20;-10,2,20;0,3,20;10,9,20;20,12,20];
% quiet = 83;

% TMB_run2
% data_speech = [-20,2,20;-10,3,20;0,8,20;10,12,20;20,13,20];
% data_noise = [-20,0,20;-10,4,20;0,14,20;10,15,20;20,18,20];
% quiet = 95;

% TMF_run1
% data_speech = [-20,0,20;-10,2,20;0,6,20;10,13,20;20,15,20];
% data_noise = [-20,3,20;-10,7,20;0,13,20;10,12,20;20,16,20];
% quiet = 90;

% TLY_run1
% data_speech = [-20,0,20;-10,6,20;0,6,20;10,12,20;20,17,20];
% data_noise = [-20,2,20;-10,13,20;0,12,20;10,16,20;20,17,20];
% quiet = 93;

% TLZ_run1
% data_speech = [-20,0,20;-10,6,20;0,6,20;10,14,20;20,14,20];
% data_noise = [-20,2,20;-10,7,20;0,14,20;10,17,20;20,18,20];
% quiet = 93;

% TMA_run1
% data_speech = [-20,0,20;-10,3,20;0,8,20;10,12,20;20,14,20];
% data_noise = [-20,1,20;-10,7,20;0,18,20;10,16,20;20,14,20];
% quiet = 98;

% TMJ_run1
% data_speech = [-20,0,20;-10,5,20;0,9,20;10,11,20;20,13,20];
% data_noise = [-20,4,20;-10,5,20;0,13,20;10,13,20;20,14,20];
% quiet = 93;

% TME_run1
% data_speech = [-20,1,20;-10,6,20;0,6,20;10,13,20;20,14,20];
% data_noise = [-20,3,20;-10,3,20;0,14,20;10,17,20;20,17,20];
% quiet = 90;

% TMK_run1
% data_speech = [-20,2,20;-10,4,20;0,3,20;10,12,20;20,14,20];
% data_noise = [-20,1,20;-10,2,20;0,9,20;10,11,20;20,15,20];
% quiet = 95;

% TMK_run2
% data_speech = [-20,0,20;-10,3,20;0,4,20;10,13,20;20,15,20];
% data_noise = [-20,2,20;-10,7,20;0,12,20;10,19,20;20,16,20];
% quiet = 98;

% TMM_run1
% data_speech = [-20,1,20;-10,3,20;0,5,20;10,15,20;20,14,20];
% data_noise = [-20,1,20;-10,9,20;0,15,20;10,19,20;20,19,20];
% quiet = 98;

% TMQ_run1
% data_speech = [-20,1,20;-10,3,20;0,6,20;10,12,20;20,18,20];
% data_noise = [-20,2,20;-10,9,20;0,9,20;10,13,20;20,14,20];
% quiet = 95;

% TMC_run1
% data_speech = [-20,3,20;-10,3,20;0,5,20;10,16,20;20,17,20];
% data_noise = [-20,2,20;-10,6,20;0,16,20;10,13,20;20,15,20];
% quiet = 98;

% TMT_run1
% data_speech = [-20,1,20;-10,4,20;0,8,20;10,9,20;20,17,20];
% data_noise = [-20,4,20;-10,7,20;0,12,20;10,18,20;20,18,20];
% quiet = 98;

% TMS_run1
% data_speech = [-20,2,20;-10,2,20;0,7,20;10,13,20;20,14,20];
% data_noise = [-20,4,20;-10,4,20;0,15,20;10,13,20;20,15,20];
% quiet = 95;

% TMR_run1
% data_speech = [-20,1,20;-10,3,20;0,8,20;10,13,20;20,16,20];
% data_noise = [-20,6,20;-10,9,20;0,18,20;10,14,20;20,19,20];
% quiet = 100;

% TMQ_run3
% data_speech = [-20,1,20;-10,6,20;0,8,20;10,6,20;20,16,20];
% data_noise = [-20,0,20;-10,4,20;0,16,20;10,19,20;20,20,20];
% quiet = 100;

% TME_run2
% data_speech = [-20,0,20;-10,4,20;0,6,20;10,11,20;20,15,20];
% data_noise = [-20,4,20;-10,8,20;0,15,20;10,20,20;20,19,20];
% quiet = 100;

% TLZ_run2
% data_speech = [-20,3,20;-10,3,20;0,8,20;10,15,20;20,16,20];
% data_noise = [-20,3,20;-10,7,20;0,15,20;10,19,20;20,16,20];
% quiet = 100;

% TMB_run2
% data_speech = [-20,1,20;-10,3,20;0,5,20;10,9,20;20,14,20];
% data_noise = [-20,3,20;-10,14,20;0,12,20;10,16,20;20,16,20];
% quiet = 100;

% TMN_run1
% data_speech = [-20,2,20;-10,2,20;0,8,20;10,9,20;20,11,20];
% data_noise = [-20,3,20;-10,5,20;0,10,20;10,14,20;20,15,20];
% quiet = 100;

% TMD_run1
% data_speech = [-20,3,20;-10,9,20;0,5,20;10,9,20;20,15,20];
% data_noise = [-20,5,20;-10,6,20;0,14,20;10,18,20;20,16,20];
% quiet = 98;

% TMO_run1
% data_speech = [-20,0,20;-10,3,20;0,11,20;10,15,20;20,15,20];
% data_noise = [-20,2,20;-10,9,20;0,15,20;10,16,20;20,18,20];
% quiet = 98;

% TMX_run1
% data_speech = [-20,1,20;-10,3,20;0,7,20;10,10,20;20,11,20];
% data_noise = [-20,1,20;-10,8,20;0,14,20;10,15,20;20,17,20];
% quiet = 98;

% TMX_run2
% data_speech = [-20,0,20;-10,4,20;0,8,20;10,13,20;20,9,20];
% data_noise = [-20,5,20;-10,6,20;0,6,20;10,15,20;20,13,20];
% quiet = 98;

% TMX_run3
% data_speech = [-20,3,20;-10,3,20;0,4,20;10,11,20;20,15,20];
% data_noise = [-20,2,20;-10,6,20;0,10,20;10,17,20;20,15,20];
% quiet = 98;

% TMX_run4
% data_speech = [-20,1,16;-10,3,16;0,3,16;10,8,16;20,10,16];
% data_noise = [-20,2,16;-10,6,16;0,13,16;10,10,16;20,10,16];
% quiet = 93;

%TMV_run1
% data_speech = [-20,2,20;-10,5,20;0,7,20;10,11,20;20,14,20];
% data_noise = [-20,0,20;-10,9,20;0,10,20;10,15,20;20,16,20];
% quiet = 98;

%TMV_run2
% data_speech = [-20,0,20;-10,5,20;0,8,20;10,15,20;20,13,20];
% data_noise = [-20,4,20;-10,4,20;0,12,20;10,15,20;20,17,20];
% quiet = 98;

%TMV_run3
% data_speech = [-20,0,20;-10,6,20;0,9,20;10,15,20;20,11,20];
% data_noise = [-20,4,20;-10,8,20;0,15,20;10,16,20;20,17,20];
% quiet = 100;

%TMW_run1
% data_speech = [-20,2,20;-10,1,20;0,10,20;10,12,20;20,16,20];
% data_noise = [-20,3,20;-10,8,20;0,15,20;10,17,20;20,18,20];
% quiet = 98;



% remark: This format differs slightly from the format used in older
% psignifit versions. 

%% construct an options struct
% To start psignifit you need to pass a struct, which specifies, what kind
% of experiment you did and any other parameters of the fit you might want
% to set:

% You can create a struct by simply calling [name]=struct

options             = struct;   % initialize as an empty struct

%Now you can set the different options with lines of the form
%[name].[field] as in the following lines:

options.sigmoidName = 'norm';                   % choose a cumulative Gaussian as the sigmoid
options.expType     = 'nAFC';                   % choose 2-AFC as the paradigm of the experiment
options.expN        = 8;                        % this sets the guessing rate to .2 and
options.estimateType   = 'MAP';
% options.priors{3} = 1 - quiet;

% To "heal" this psignifit allows you to pass another range, for which you
% believe in the assumptions of our prior. The prior will be set as for the
% true data range, but for the provided range.
% For our example dataset we might give a generous range and assume the
% possible range is .5 to 1.5 
% options.stimulusRange =[0.2, quiet];

% fits the rest of the parameters
% There are 3 other types of experiments supported out of the box:
% n alternative forces choice. The guessing rate is known.
%       options.expType = "nAFC"
%       options.expN    = [number of alternatives]
% Yes/No experiments a free guessing and lapse rate is estimated
%       options.expType = "YesNo"
% equal asymptote, as Yes/No, but enforces that guessing and lapsing occure
% equally often
%       options.expType = "equalAsymptote"

% Out of the box psignifit supports the following sigmoid functions,
% choosen by:
% options.sigmoidName = ...
% 
% 'norm'        a cummulative Gaussian distribution
% 'logistic'    a logistic function
% 'gumbel'      a cummulative gumbel distribution
% 'rgumbel'     a reversed gumbel distribution
% 'tdist'       a t-distribution with df=1 as a heavytail distribution
%
% for positive stimulus levels which make sense on a log-scale:
% 'logn'        a cumulative lognormal distribution
% 'Weibull'     a Weibull function

% There are many other options you can set in the options-file. You find
% them in demo_002

% options.stepN   = [40,40,20,20,20]
% This sets the number of grid points on each dimension in the final
% fitting (stepN) and in the moving of borders mbStepN
% the order is 
% [threshold,width,upper asymptote,lower asymptote,variance scaling]
% You may change this if you need more accurate estimates on the sparsely
% sampled parameters or if you want to play with them to save time
% for example to get an even more exact estimate on the 
% lapse rate/upper asymptote plug in 
% options.stepN=[70,quiet*100 - 20 ,quiet*100,1];

% threshold
% Which percent correct correspond to the threshold? 
% Given in Percent correct on the unscaled sigmoid (reaching from 0 to 1).
% For example to define the threshold as 90% correct try:  
% options.threshPC       = quiet;

% set priors
% options.betaPrior = 1;

%% Now run psignifit
% Now we are ready to run the main function, which fits the function to the
% data. You obtain a struct, which contains all the information about the
% fitted function and can be passed to the many other functions in this
% toolbox, to further process the results.

result_speech = psignifit(data_speech,options);
%plotPrior(result_speech);
speech_threshold = getThreshold(result_speech, treshold_5_7);

result_noise = psignifit(data_noise,options);
%plotPrior(result_noise);
noise_threshold = getThreshold(result_noise, treshold_5_7);

release = speech_threshold - noise_threshold;
%result is a struct which contains all information obtained from fitting your data. 
%Perhaps of primary interest are the fit and the confidence intervals:

result_speech.Fit
result_speech.conf_Intervals;

result_noise.Fit
result_noise.conf_Intervals;

% This gives you the basic result of your fit. The five values reported are:
%    the threshold
%    the width (difference between the 95 and the 5 percent point of the unscaled sigmoid)
%    lambda, the upper asymptote/lapse rate
%    gamma, the lower asymptote/guess rate
%    eta, scaling the extra variance introduced (a value near zero indicates 
%         your data to be basically binomially distributed, whereas values 
%         near one indicate severely overdispersed data)
% The field conf_Intervals returns credible intervals for the values provided 
% in options.confP. By default these are 68%, 90% and 95%. With default settings 
% you should thus receive a 5x2x3 array, which contains 3 sets of credible intervals 
% (lower and upper end = 2 values) for each of the 5 parameters.

%% visualize the results
% For example you can use the result struct res to plot your psychometric
% function with the data:

figure;
hold on;

plotOptions.plotData       = 1;                    % plot the data?
plotOptions.lineWidth      = 2;                    % lineWidth of the PF
plotOptions.xLabel         = 'Stimulus Level';     % xLabel
plotOptions.yLabel         = 'Percent Correct';    % yLabel
plotOptions.labelSize      = 15;                   % font size labels
plotOptions.fontSize       = 10;                   % font size numbers
plotOptions.fontName       = 'Helvetica';          % font
plotOptions.tufteAxis      = false;                % use special axis
plotOptions.plotAsymptote  = true;                 % plot Asympotes 
plotOptions.plotThresh     = false;                 % plot Threshold Mark
plotOptions.aspectRatio    = false;                % set aspect ratio
plotOptions.extrapolLength = .2;                   % extrapolation percentage
plotOptions.CIthresh       = false;                % draw CI on threhold

plotOptions.dataColor = [0,105/255,170/255];
plotOptions.lineColor = [0,105/255,170/255];
plotOptions.dataSize  = 10000./sum(result_speech.data(:,3)); % size of the data-dots
plotPsych(result_speech, plotOptions);

plotOptions.dataColor = [105/255,0,170/255];
plotOptions.lineColor = [105/255,0,170/255];
plotOptions.dataSize  = 10000./sum(result_noise.data(:,3)); % size of the data-dots
plotPsych(result_noise, plotOptions);

title(['release is: ', num2str(release), ' Noise threshold is: ', num2str(noise_threshold), ' Speech threshold is: ', num2str(speech_threshold)]);




%% remark for insufficient memory issues
% especially for YesNo experiments the result structs can become rather
% large. If you run into Memory issues you can drop the Posterior from the
% result with the following command.

% resultSmall = rmfield(result,{'Posterior','weight'});

% without these fields you will not be able to use the 2D Bayesian plots
% anymore. All other functions work without it.

