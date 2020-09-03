clear;
close;

%% add to path and change path
addpath(genpath([pwd, '\CriticalSpacing-master_v2_bi\CriticalSpacing-master']));
cd([pwd, '\CriticalSpacing-master_v2_bi\CriticalSpacing-master']);

%% quite training first
run('runCriticalSpacingAntjeBilateral');