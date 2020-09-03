clear;
close;
addpath([pwd, '\new IM detection\PsyAcoustX']);
rmpath(genpath([pwd, '\new IM detection\Target detection mask']));
%% ask for subject name
subject_ID = input('Subject ID: ','s');

%% detection in noise first
path_noise = [pwd, '\new IM detection\Target detection pesudo noise 2'];
addpath(genpath(path_noise));

cd(path_noise);
file_name = Target_detection_noise_generate_conditions(subject_ID);
run('tracking_plot.m');

