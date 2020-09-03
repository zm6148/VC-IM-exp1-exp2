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
SNs = {'Taiga_run1'};

symb = {'o';'s';'<';'>'};
lw = 2;
clrs = 'bgrm';
for SN = 1 : length(SNs)
    subject_ID = SNs{SN};
    subjectInitials = subject_ID(1:3);% three-letter subject code
    file_name = [pth,'Quiet_Subj',subject_ID];
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
    
    
    
    %%
    figure(SN),clf
    p = plot(Params.TMR,correct_cnt./trial_sum*100,['-',symb{SN}],'linewidth',lw);
    cc = get(p,'color');
    for ppp = 1 : length(p)
        set(p(ppp),'markerfacecolor',cc{ppp});
    end
    
    xlabel('TMR');
    ylabel('Percent Correct')
    legend(Params.MaskerNames)
    ylim([10 105])
    %set(gca,'xtick',Params.TMR)
    tstr = ['Subject: ' upper(subjectInitials) ' #Blocks: ' int2str(num_blocks) ' #Trials/block: ' int2str(num_trials)];
    tstr(tstr == '_') = '.';
    title(tstr);
    saveas(gcf,['.\figures\Results_',num2str(SN),'.pdf'],'pdf');
end

