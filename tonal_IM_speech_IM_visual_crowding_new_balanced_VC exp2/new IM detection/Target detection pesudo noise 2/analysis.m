clear;

%frequency analysis

Fs=44.1e3; %sampling frequence
Ramp = 10e-3 ; %ramp duration 0.01

Duration = 0.6;% 150 ms long tone pips
Delay = Duration/4; %delay may be random mark for edit later
silence = 0.*(0:1/Fs : Delay);
t = 0 : 1/Fs : Duration;
ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
envelope = [ramp ones(length(t)-2*length(ramp),1)' fliplr(ramp)];
t_cf = 1000;
pt_bw = 0.4;
% pt_dur=handles.para(i,2);
spl = 50;
% t_pt = handles.para(i,7);
% t_es = handles.para(i,9);
m_dis = 0.3;
% tm_dif = handles.para(i,6);
% m_pt = handles.para(i,8);
% m_es = handles.para(i,10);
TotalNumber = 1;




%% build target
distance=pt_bw;% in mm distance on the coclear fixed
target_distance=invgreenwood(t_cf);

f=[];
for jj = 1:TotalNumber
	f=[f,t_cf];
end
t_frequencies = f;

target_pattern=[];
for j=1:TotalNumber
	t_spl=spl; %spline(freq,spl_c,t_frequencies(j));
	
	phase_target=2*pi*rand(1,1);
	tone = sin(2*pi*t_frequencies(j)*t+phase_target);
	tone=(tone/rms(tone))*10^((50-101.3)/20);
	%target_pattern = [target_pattern, tone, silence];
	target_pattern = [target_pattern, tone];
	
end

%% build noise 1
data_length = length(target_pattern);
mask_pattern = notched_noise_no_iso(Fs, t_cf, m_dis, data_length/Fs);
mask_pattern = (mask_pattern/rms(mask_pattern))*10^((50-101.3)/20);


%% notched noise 2
sf = 44100; % sample frequency in Hz
signaldur = 0.6; % signal duration
freq = 1000; % signal frequency
noisedur = 600; % noise duration
bw = 0.3; 
lf1 = 250; % noise lowest frequency
hf1 = 1000*2^(-bw/2); % noise highest frequency

lf2 = 1000*2^(bw/2); % noise lowest frequency
hf2 = 1000*2^(bw/2)+(1000*2^(-bw/2)-250); % noise highest frequency

% [1] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE SOUNDS
% signal = GenerateTone(sf, signaldur, freq);
% signal = GenerateEnvelope(sf, signal);
% signal = AttenuateSound(signal, var_level);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit here generate 2 noise
% noise 1
noise1 = GenerateNoise(sf, noisedur, 'bandpass', lf1, hf1);
noise1 = GenerateEnvelope(sf, noise1);
noise1 = AttenuateSound(noise1, -30);

% noise 2
noise2 = GenerateNoise(sf, noisedur, 'bandpass', lf2, hf2);
noise2 = GenerateEnvelope(sf, noise2);
noise2 = AttenuateSound(noise2, -30);

% add noise 1 and 2
noise =  noise1 + noise2;

% 
noise = (noise/rms(noise))*10^((50-101.3)/20);

%% fft

mask_pattern = noise;

mask_pattern_Y = 20*log10(abs(fft(mask_pattern)));
tatget_Y = 20*log10(abs(fft(target_pattern)));


f = [0 : (length(mask_pattern)-1)]*Fs/length(mask_pattern);
ind = find(f>0&f<5000);
figure;
hold on;
plot(f(ind),mask_pattern_Y(ind));
plot(f(ind),tatget_Y(ind));
title('fft gap is 2 octave');
legend('mask','target');
xlabel('frequence');

%% time
figure;
hold on;
plot(mask_pattern);
plot(target_pattern);
title('time gap is 0.3 octave');
legend('mask','target');

%% band stop filter

nn = rand(size(t));
nn = nn-mean(nn);
nn=(nn/rms(nn))*10^((50-101.3)/20);