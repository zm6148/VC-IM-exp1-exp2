clear;
close;

%% add to path and change path
addpath(genpath([pwd, '\Hearing Task SOS new 2018 aug V2']));
cd([pwd, '\Hearing Task SOS new 2018 aug V2']);
subjectID = input('Subject ID: ','s');

%% quite training first
run('SpeechOnSpeech_mainexperiment_new_2018_AUG_CRM_quite');
clear Params;

%% run the whole experiment
run('SpeechOnSpeech_mainexperiment_new_2018_AUG_CRM');

% %% ask for subject name
% subject_ID = input('Subject ID: ','s');
% 
% 
% %% detection in tonal masker next
% path_tonal = [pwd, '\new IM detection\Target detection mask'];
% addpath(genpath(path_tonal));
% 
% cd(path_tonal);
% file_name = Target_detection_mask_generate_conditions(subject_ID);
% run('tracking_plot.m');