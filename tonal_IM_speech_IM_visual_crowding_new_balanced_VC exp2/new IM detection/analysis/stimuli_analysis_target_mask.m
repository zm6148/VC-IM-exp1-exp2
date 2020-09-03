% Fs = 441000;
% m_dis = 0.3; %0.5; 1; 2
% t_cf = 1000;
% distance=0.4;% in mm distance on the coclear fixed
% pt_dur = 150;% in ms
% m_low_cf = t_cf*2^(-m_dis);
% m_high_cf = t_cf*2^m_dis;
%
%
% Lowestfreq = m_low_cf;
% Highestfreq = m_high_cf;
% y = notched_noise_no_iso(Fs, Lowestfreq, Highestfreq, 1);
%
% nn = rand(size(y));
% nn = nn-mean(nn);


handles.current =300;
handles.para = para_multi; %min_t_m_1000_test24
handles.para(:,7)=1;
%handles.pare(20,3) =500;
%% tonal target and notched noise
[Fs,sound_mask] = build_sound_pesudonoise_mono_maskonly( handles );
[Fs,sound_tone] = build_sound_pesudonoise_mono_toneonly( handles );
[Fs,sound_all] = build_sound_pesudonoise_mono( handles );
%% play and record

% play the stimuli
player = audioplayer(sound_tone, Fs);
playblocking(player);

% %% play and record
% 
% % play the stimuli
% player = audioplayer(sound_tone, Fs);
% playblocking(player);
