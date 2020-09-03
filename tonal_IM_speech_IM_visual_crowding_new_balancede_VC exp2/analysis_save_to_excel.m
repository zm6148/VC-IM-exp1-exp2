clear;
close all;

addpath(genpath([pwd, '\processing_function']));

%% load data from 3 separate task
% exp1
exp1_tonal_IM_data_path = [pwd, '\new IM detection\Target detection mask\conditions\'];
exp1_noise_IM_data_path = [pwd, '\new IM detection\Target detection pesudo noise 2\conditions\'];
% exp2
exp2_speech_IM_data_path = [pwd, '\Hearing Task SOS new 2018 aug V2\data\'];
% exp3
exp3_VC_data_path = [pwd, '\CriticalSpacing-master_v2_bi\CriticalSpacing-master\data\'];

% load all .mat file from exp1 data dir
% and get the subject code order

filepattern = fullfile(exp1_tonal_IM_data_path, '*.mat');
files = dir(filepattern);

all_subject_name = {};
data_matrix = [];
for subject_index = 1 : length(files)
    base_name = files(subject_index).name;
    [folder, name, extention] = fileparts(base_name);
%     code = split(name, '_');
%     all_subject_order{subject_index} = code{1};
    all_subject_name{subject_index} = name;
end

% build subject data file order for all experiments
exp1_tonal_IM_subjectcode_order = {};
exp1_noise_IM_subjectcode_order = {};
exp2_speech_IM_subjectcode_order = {};
exp3_VC_IM_subjectcode_order = {};

for index = 1:length(all_subject_name)
    %     if all_subject_order(index) == TXX
    %         exp1_dummy = [all_subject_order(index), '_2'];
    %     else
    %         exp1_dummy = [all_subject_order(index), '_1'];
    %     end
    exp1_dummy = all_subject_name{index};
    exp2_dummy = ['Masked_Subj', all_subject_name{index}];
    exp3_dummy = [all_subject_name{index}, '_2'];
    
    exp1_tonal_IM_subjectcode_order{index} = exp1_dummy;
    exp1_noise_IM_subjectcode_order{index} = exp1_dummy;
    exp2_speech_IM_subjectcode_order{index} = exp2_dummy;
    exp3_VC_IM_subjectcode_order{index} = exp3_dummy;
    
    % load exp1 noise data
    exp1_noise_data = load([exp1_noise_IM_data_path, exp1_dummy, '.mat']);
    % load exp1 tonal data
    exp1_tonal_data = load([exp1_tonal_IM_data_path, exp1_dummy, '.mat']);
    % load exp2 data
    exp2_data = load([exp2_speech_IM_data_path, exp2_dummy, '.mat']);
    % load exp3 data
    exp3_data = load([exp3_VC_data_path, exp3_dummy, '.mat']);
    
    % 3 function to take in the data and output results
    % exp1 results
    % 0.3, 0.5, 1, 1.5
    % notch witdh   threshold
    [exp1_noise_results, tone_detection_threshold] = exp1_process_noise(exp1_noise_data);
    % too subject wrong reading due
    exp1_tonal_results = exp1_process_tone(exp1_tonal_data);
    
    % exp2 results
    % exp2 results: noise, speeach, release
    exp2_results = exp2_process(exp2_data, all_subject_name{index});
    
    % exp3 results
    % exp3 results 2 trial
    % each has Threshold log, Threshold log sd, Threshold in degree
    exp3_results = exp3_process(exp3_data);
    
    data_matrix_dummy = [exp1_noise_results(:,2)', exp1_tonal_results(:,2)', exp1_tonal_results(3,2)-exp1_noise_results(3,2), tone_detection_threshold...
                         exp2_results', ...
                         exp3_results(:,3)', mean(exp3_results(:,3))];
                      
    data_matrix = [data_matrix; data_matrix_dummy];
end


%% calculate excel file data entry

filename = 'summarized_results.xlsx';
sheet = 1;
xlRange_data = 'B4';
xlRange_order = 'A4';
xlswrite(filename, data_matrix, sheet, xlRange_data);
xlswrite(filename, all_subject_name', sheet, xlRange_order);



