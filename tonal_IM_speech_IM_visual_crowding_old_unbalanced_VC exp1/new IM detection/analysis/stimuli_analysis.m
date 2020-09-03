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


handles.current =20;
handles.para = para_multi; %min_t_m_1000_test24
%handles.pare(20,3) =500;
%% tonal target and notched noise
[Fs2,sound2] = build_sound_pesudonoise_mono( handles );

%% tonal target and tonal mask

[Fs,sound] = build_sound_tonal_mask_mono_linear( handles );

%% 
% sound2 = sound2 (:,1:length(sound));

%% fft

f = [0 : (length(sound2)-1)]*Fs/length(sound2);
ind = find(f>10&f<8000);

Y1 = 20*log10(abs(fft(sound(1,:))));

Y2 = 20*log10(abs(fft(sound2(1,:))));

figure;
hold on;
plot(f(ind),Y1(ind));
plot(f(ind),Y2(ind));
legend('tonal mask', 'nothced noise');
% %% fft
% 
% Y = 20*log10(abs(fft(nn)));
% f = [0 : (length(nn)-1)]*Fs/length(nn);
% ind = find(f>10&f<12e3);
% figure;
% plot(f(ind),Y(ind));