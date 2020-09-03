function [Fs,sound] = build_sound_pesudonoise_mono( handles )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% load data
i=handles.current;

Fs=44.1e3; %sampling frequence
Ramp = 50e-3 ; %ramp duration 0.15s

TotalNumber=handles.para(i,11);
Duration = handles.para(i,2);% 150 ms long tone pips
Delay = Duration/4; %delay may be random mark for edit later
t = 0 : 1/Fs : Duration/1000;
ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
envelope = [ramp ones(length(t)-2*length(ramp),1)' fliplr(ramp)];
t_cf = handles.para(i,3);
pt_bw = handles.para(i,1);
pt_dur=handles.para(i,2);
spl = handles.para(i,4);
t_pt = handles.para(i,7);
t_es = handles.para(i,9);
m_dis = handles.para(i,5);
tm_dif = handles.para(i,6);
m_pt = handles.para(i,8);
m_es = handles.para(i,10);

distance=pt_bw;% in mm distance on the coclear fixed
target_distance=invgreenwood(t_cf);


%switch among element distance
switch t_es
    case 1% even spacing
        f=[];
        for jj = 1:TotalNumber
            f=[f,t_cf];
        end
    case 2% random spacing
        target_range_down=greenwood(target_distance - distance/2);
        target_range_up=greenwood(target_distance + distance/2);
        f  = round(logspace(log10(target_range_down),log10(target_range_up),((target_range_up-target_range_down))*(pt_dur/100)));
        y = datasample(f(2:(length(f)-1)),(TotalNumber-2),'Replace',false);
        f = [f(1) sort(y) f(length(f))];
end

% no target pattern only continuous pure tone
t_frequencies = f;

m_low_cf = t_cf*2^(-m_dis);
m_high_cf = t_cf*2^m_dis;
mask_low_distance=invgreenwood(m_low_cf);
mask_high_distance=invgreenwood(m_high_cf);

%switch among element distance
switch m_es
    case 1% even spacing
        
        %linear spacing on green wood distance
        g_distance_m_low = linspace(mask_low_distance-distance/2,mask_low_distance+distance/2,TotalNumber);
        f_low=[];
        for jj = 1:TotalNumber
            f_low=[f_low,greenwood(g_distance_m_low(jj))];
        end
        
        %linear spacing on green wood distance
        g_distance_m_high = linspace(mask_high_distance-distance/2,mask_high_distance+distance/2,TotalNumber);
        f_high=[];
        for jj = 1:TotalNumber
            f_high=[f_high,greenwood(g_distance_m_high(jj))];
        end
        
    case 2% random spacing
        
        f_low = round(logspace(log10(mask_low_range_down),log10(mask_low_range_up),((mask_low_range_up-mask_low_range_down))*(pt_dur/100)));
        y_low = datasample(f_low(2:(length(f_low)-1)),(round(TotalNumber/2)-2),'Replace',false);
        f_low = [f_low(1) sort(y_low) f_low(length(f_low))];
        
        f_high = round(logspace(log10(mask_high_range_down),log10(mask_high_range_up),((mask_high_range_up-mask_high_range_down))*(pt_dur/100)));
        y_high = datasample(f_high2(2:(length(f_high)-1)),(round(TotalNumber/2)-2),'Replace',false);
        f_high = [f_high(1) sort(y_high) f_high(length(f_high))];
end

%swith among mask patterns
switch m_pt
    case 1%Up
        m_low_frequences = f_low;
        m_high_frequences = f_high;
    case 2 % Down
        m_low_frequences = fliplr(f_low);
        m_high_frequences = fliplr(f_high);
    case 3% Flat
        m_low_frequences = repmat(median(f_low),1,TotalNumber);
        m_high_frequences = repmat(median(f_high),1,TotalNumber);
    case 4% Up-Down
        cc = round(TotalNumber/2);
        m_low_frequences = [repmat(f_low(end),1,cc) repmat(f_low(1),1,cc)];
        m_low_frequences = m_low_frequences(1:TotalNumber);
        m_high_frequences = [repmat(f_high(end),1,cc) repmat(f_high(1),1,cc)];
        m_high_frequences = m_high_frequences(1:TotalNumber);
    case 5% Down-Up
        cc = round(TotalNumber/2);
        m_low_frequences = [repmat(f_low(1),1,cc) repmat(f_low(end),1,cc)];
        m_low_frequences = m_low_frequences(1:TotalNumber);
        m_high_frequences = [repmat(f_high(1),1,cc) repmat(f_high(end),1,cc)];
        m_high_frequences = m_high_frequences(1:TotalNumber);
end


silence = 0.*(0:1/Fs : Delay/1000);
target_pattern=[];
mask_low_pattern=[];
mask_high_pattern=[];


% build sound file to play
for j=1:TotalNumber
    t_spl=spl; %spline(freq,spl_c,t_frequencies(j));
    
    %switch among target there or not t_pt= [0 1]; %target pattern 7 yes or no there or not there
    switch t_pt
        case 2 % target no there
            tone = 0*t;
			if TotalNumber == 1
				target_pattern = [target_pattern, tone];
			else
				target_pattern = [target_pattern, tone, silence];
			end
            
        case 1 % target there
            phase_target=2*pi*rand(1,1);
            tone = envelope.*sin(2*pi*t_frequencies(j)*t+phase_target);
			
			
			%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 			switch t_frequencies(j)
% 				case 1000
% 					cali = 88.2;
% 				case 500
% 					cali = 89.5;
% 				case 2000
% 					cali = 85.5;
% 			end
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			
			cali = 88.4;
            tone=(tone/rms(tone))*10^((tm_dif-cali)/20);
			
			if TotalNumber == 1
				target_pattern = [target_pattern, tone];
			else
				target_pattern = [target_pattern, tone, silence];
			end
    end
end

% build same length pesudorandom tone masker
data_length = length(target_pattern);
t_mask = 0:1/Fs:(data_length/Fs);
envelope_m = [ramp ones(length(t_mask)-2*length(ramp),1)' fliplr(ramp)];
% mask_pattern = zeros(1,length(t_mask));

% pesudorandom noise below low cf
%phase_mask=2*pi*rand(1,1);
% make same loudness
m_spl = spl;

% %mask_low_pattern = envelope_m.*notched_noise_no_iso(Fs, f_low(end)-max(f_low)/2, f_low(end), data_length/Fs);
% mask_low_pattern = envelope_m.*notched_noise_no_iso(Fs, f_low(end), f_high(1), data_length/Fs);
% mask_low_pattern = (mask_low_pattern/rms(mask_low_pattern))*10^((m_spl-101.3)/20);
% mask_pattern = mask_pattern + mask_low_pattern;
% 
% % pesudorandom noise above high cf
% %phase_mask=2*pi*rand(1,1);
% %mask_high_pattern = envelope_m.*notched_noise_no_iso(Fs, f_high(1), f_high(1)+max(f_high)/2, data_length/Fs);
% mask_high_pattern = envelope_m.*notched_noise_no_iso(Fs, f_low(end), f_high(1), data_length/Fs);
% mask_high_pattern = (mask_high_pattern/rms(mask_high_pattern))*10^((m_spl-101.3)/20);
% mask_pattern = mask_pattern + mask_high_pattern;
% a = notched_noise_no_iso(Fs, t_cf, m_dis, data_length/Fs);
% disp(size(a));
% disp(size(envelope_m));
mask_pattern = envelope_m.*notched_noise_no_iso(Fs, t_cf, m_dis, m_spl, data_length/Fs);


mask_pattern = mask_pattern(1:data_length);
%mask_pattern = mask_pattern(1:data_length)*0;

% add broadband noise
% broadband_noise_no_iso(Fs, Duration)

% add a noise that is 40 db below target mask
band = 200 + log2(t_cf/500)*100;
% calculate the sb spl level required for 40 spectrum level
notched_noise_spl = m_spl + 10*(log10(band*2));
noise_spl = notched_noise_spl - 40;
noise = broadband_noise_no_iso(Fs, noise_spl, length(mask_pattern));

mask_pattern = mask_pattern+ noise; 


%disp(length(mask_pattern));
%random mono to left or right ear
left_or_right = 2; % round(rand);

switch left_or_right
    case 1
        target_pattern = [zeros(length(target_pattern),1)'; target_pattern];
        mask_pattern = [zeros(length(mask_pattern),1)';mask_pattern];
    case 2
        target_pattern = [target_pattern; zeros(length(target_pattern),1)'];
        mask_pattern = [mask_pattern; zeros(length(mask_pattern),1)'];
	case 3
        target_pattern = [target_pattern; target_pattern];
        mask_pattern = [mask_pattern; mask_pattern];
end

sound = target_pattern + mask_pattern;

end

