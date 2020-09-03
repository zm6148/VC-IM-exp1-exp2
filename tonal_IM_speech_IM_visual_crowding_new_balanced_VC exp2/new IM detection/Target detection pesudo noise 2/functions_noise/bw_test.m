
i=34;
t_cf = para_multi(i,3);

distance=0.4;
target_distance=invgreenwood(t_cf);
t_low_g=greenwood(target_distance - distance/2);
t_up_g=greenwood(target_distance + distance/2);


Fs=44.1e3; %sampling frequence
Ramp = 10e-3 ; %ramp duration 0.15s

TotalNumber=para_multi(i,11);
Duration = para_multi(i,2);% 150 ms long tone pips
Delay = Duration/4; %delay may be random mark for edit later
%phase = pi*rand(TotalNumber,1);
t = 0 : 1/Fs : Duration/1000;
ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
envelope = [ramp ones(length(t)-2*length(ramp),1)' fliplr(ramp)];
t_cf = para_multi(i,3);
pt_bw = para_multi(i,1);
pt_dur=para_multi(i,2);
spl = para_multi(i,4);
t_pt = para_multi(i,7);
t_es = para_multi(i,9);
m_dis = para_multi(i,5);
tm_dif = para_multi(i,6);
m_pt = para_multi(i,8);
m_es = para_multi(i,10);

distance=pt_bw;% in mm distance on the coclear fixed
target_distance=invgreenwood(t_cf);

%switch among element distance  
switch t_es
    case 1% even spacing
		%linear spacing on green wood distance
        g_distance = linspace(target_distance-distance/2,target_distance+distance/2,TotalNumber);
        f=[];
        for jj = 1:TotalNumber
            f=[f,greenwood(g_distance(jj))];
        end
%         f2 = round(logspace(log10(t_cf*2^(-pt_bw/2)),log10(t_cf*2^(pt_bw/2)),TotalNumber/2));
    case 2% random spacing
        target_range_down=greenwood(target_distance - distance/2);
        target_range_up=greenwood(target_distance + distance/2);
        f  = round(logspace(log10(target_range_down),log10(target_range_up),((target_range_up-target_range_down))*(pt_dur/100)));
        y = datasample(f(2:(length(f)-1)),(TotalNumber-2),'Replace',false);
        f = [f(1) sort(y) f(length(f))];

%         f2  = round(logspace(log10(t_cf*2^(-pt_bw/2)),log10(t_cf*2^(pt_bw/2)),((t_cf*2^(pt_bw/2)-(t_cf*2^(-pt_bw/2))))*(pt_dur/100)));
%         y2 = datasample(f2(2:(length(f2)-1)),(round(TotalNumber/2)-2),'Replace',false);
%         f2 = [f2(1) sort(y2) f2(length(f2))];
end

%switch among target patterns    
switch t_pt
case 1 %Up
    t_frequencies = f;
case 2 % Down
    t_frequencies = fliplr(f);
case 3 % Flat
    t_frequencies = repmat(median(f),1,TotalNumber);
case 4 % Up-Down
    cc = round(TotalNumber/2);
    t_frequencies = [repmat(f(end),1,cc) repmat(f(1),1,cc)];
    t_frequencies = t_frequencies(1:TotalNumber);
%     t_frequencies = [f2 fliplr(f2)];
case 5 % Down-Up
    cc = round(TotalNumber/2);
    t_frequencies = [repmat(f(1),1,cc) repmat(f(end),1,cc)];
    t_frequencies = t_frequencies(1:TotalNumber);  
%     t_frequencies = [fliplr(f2) f2];
end
clear f;
clear f2;    

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

%         f_low2 = round(logspace(log10(m_low_cf*2^(-pt_bw/2)),log10(m_low_cf*2^(pt_bw/2)),TotalNumber/2));
%         f_high2 = round(logspace(log10(m_high_cf*2^(-pt_bw/2)),log10(m_high_cf*2^(pt_bw/2)),TotalNumber/2));

    case 2% random spacing
%         f_low = round(logspace(log10(m_low_cf*2^(-pt_bw/2)),log10(m_low_cf*2^(pt_bw/2)),((m_low_cf*2^(pt_bw/2)-(m_low_cf*2^(-pt_bw/2))))*(pt_dur/100)));
%         f_high = round(logspace(log10(m_high_cf*2^(-pt_bw/2)),log10(m_high_cf*2^(pt_bw/2)),((m_high_cf*2^(pt_bw/2)-(m_high_cf*2^(-pt_bw/2))))*(pt_dur/100)));

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
%     m_low_frequences=[f_low2, fliplr(f_low2)];
%     m_high_frequences=[f_high2, fliplr(f_high2)];        
    cc = round(TotalNumber/2);
    m_low_frequences = [repmat(f_low(end),1,cc) repmat(f_low(1),1,cc)];
    m_low_frequences = m_low_frequences(1:TotalNumber);
    m_high_frequences = [repmat(f_high(end),1,cc) repmat(f_high(1),1,cc)];
    m_high_frequences = m_high_frequences(1:TotalNumber);
case 5% Down-Up
%     m_low_frequences=[fliplr(f_low2), f_low2];
%     m_high_frequences=[fliplr(f_high2), f_high2];       
    cc = round(TotalNumber/2);
    m_low_frequences = [repmat(f_low(1),1,cc) repmat(f_low(end),1,cc)];
    m_low_frequences = m_low_frequences(1:TotalNumber);
    m_high_frequences = [repmat(f_high(1),1,cc) repmat(f_high(end),1,cc)];
    m_high_frequences = m_high_frequences(1:TotalNumber);    
end   
clear f_low;
clear f_low2; 
clear f_high;
clear f_high2;

silence = 0.*(0:1/Fs : Delay/1000);
target_pattern=[];
mask_low_pattern=[];
mask_high_pattern=[];

%based on iso226 equal loudness curve calculate corresponding db to
%equal loudness
[spl_c,freq]=iso226(spl);
% disp(envelope);
% disp(t);

% add a random phase
%rng(1);
phase_target=2*pi*rand(1,1);
%rng(2);
phase_mask=2*pi*rand(1,1);
%save phase to file
%save results to file


% build sound file to play
for j=1:TotalNumber
    t_spl=spline(freq,spl_c,t_frequencies(j));
    tone = envelope.*sin(2*pi*t_frequencies(j)*t+phase_target);
    tone=(tone/rms(tone))*10^((t_spl+tm_dif-93)/20);
    target_pattern = [target_pattern, tone, silence];
    
    m_spl_low=spline(freq,spl_c,m_low_frequences(j));
    tone = envelope.*sin(2*pi*m_low_frequences(j)*t+phase_mask);
    tone=(tone/rms(tone))*10^((m_spl_low-93)/20);
    mask_low_pattern = [mask_low_pattern, tone, silence];
    
    m_spl_high=spline(freq,spl_c,m_high_frequences(j));
    tone = envelope.*sin(2*pi*m_high_frequences(j)*t+phase_mask);
    tone=(tone/rms(tone))*10^((m_spl_high-93)/20);
    mask_high_pattern = [mask_high_pattern, tone, silence];        
end

mask_pattern = mask_low_pattern+mask_high_pattern;

%% plot and check
figure(1);
subplot(2,1,1);
plot(target_pattern);
title('target pattern');
subplot(2,1,2);
plot(mask_pattern)
title('mask pattern');
% subplot(3,1,3);
% plot(mask_low_pattern)
% title('

%dF = Fs/NFFT
figure(2);
subplot(2,1,1);
%spectrogram(x,window,noverlap,nfft) 
spectrogram(target_pattern,256,250,[],Fs,'yaxis')
title(['the center f is ', num2str(t_cf)]);
subplot(2,1,2);
spectrogram(mask_pattern,256,250,[],Fs,'yaxis')

%% pitch shift/frequency scaling analysis

% A pitch shifter is a sound effects unit that raises or lowers the pitch of
% an audio signal by a preset interval. For example, a pitch shifter set to 
% increase the pitch by a fourth will raise each note three diatonic
% intervals above the notes actually played. Simple pitch shifters raise or
% lower the pitch by one or two octaves, while more sophisticated devices 
% offer a range of interval alterations. Pitch shifters are included in
% most audio processors today.
% 

