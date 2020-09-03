function y = notched_noise_no_iso(Fs, t_cf, m_dis, m_spl, Duration)

%[spl_c,freq]=iso226(spl);


% notched the noise
% Fs
t.Fs = Fs;
t.Duration = Duration;
t.t = 0 : 1/t.Fs : t.Duration; % time vector

% random noise
nn = rand(size(t.t));
nn = nn-mean(nn);

% calculate the distance
distance  = t_cf*(2^(m_dis/2)) - t_cf*(2^(-m_dis/2));

f_2 = t_cf - distance/2;
f_3 = t_cf + distance/2;

% noise bandwidth
% change here for differen band width based on target center frequency

% switch t_cf
% 	case 250
% 		band = 100;
% 	case 1500
% 		band = 350;
% 	case 1000
% 		band = 300;
% 	case 500
% 		band = 200;
% 	case 2000
% 		band = 400;
% end

band = 200 + log2(t_cf/500)*100;

f_1 = f_2 - band;
f_4 = f_3 + band;

% calculate the sb spl level required for 40 spectrum level
spl = m_spl + 10*(log10(band*2));

% set to certain db spl and fixed
nn = (nn/rms(nn))*10^((spl-66)/20);


%% notched noise 1
% desgin f cutoffs
% lower 2 octave from center
% upper 2 octave from center


f_all= [f_1, f_2, f_3, f_4];

filteredSig = createNotchedNoise(nn,f_all,Fs);

y = filteredSig;

%% nostched noise 2

% sf = Fs; % sample frequency in Hz
% noisedur = length(t.t)/Fs*1000; % noise duration
% lf1 = f_1; % noise lowest frequency
% hf1 = f_2; % noise highest frequency
% 
% lf2 = f_3; % noise lowest frequency
% hf2 = f_4; % noise highest frequency
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % edit here generate 2 noise
% % noise 1
% noise1 = GenerateNoise(sf, noisedur, 'bandpass', lf1, hf1);
% noise1 = GenerateEnvelope(sf, noise1);
% noise1 = AttenuateSound(noise1, -30);
% 
% % noise 2
% noise2 = GenerateNoise(sf, noisedur, 'bandpass', lf2, hf2);
% noise2 = GenerateEnvelope(sf, noise2);
% noise2 = AttenuateSound(noise2, -30);
% 
% % add noise 1 and 2
% noise =  noise1 + noise2;
% 
% y = noise;

end