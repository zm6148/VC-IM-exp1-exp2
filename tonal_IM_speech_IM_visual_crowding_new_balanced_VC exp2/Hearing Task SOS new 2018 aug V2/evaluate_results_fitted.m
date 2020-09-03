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
SNs = {'TMB_run2'};

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
