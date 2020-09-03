clear;
close;
addpath([pwd, '\new IM detection\PsyAcoustX']);
rmpath(genpath([pwd, '\new IM detection\Target detection pesudo noise 2']));
%% ask for subject name
subject_ID = input('Subject ID: ','s');

%% detection in tonal masker next
path_tonal = [pwd, '\new IM detection\Target detection mask'];
addpath(genpath(path_tonal));

cd(path_tonal);
file_name = Target_detection_mask_generate_conditions(subject_ID);
run('tracking_plot.m');

