function [masker, LOW]=makeLNN_gap(masker,f,Fs)
%
% EB 5/16/03
% SGJ modified 12/11/13

pltYN=0;

npts=length(masker);
FreqRes=Fs/npts;
Mask=zeros(1,npts);
f1IDX=round(f(1)*npts/Fs);
f2IDX=round(f(2)*npts/Fs);
Mask(f1IDX:f2IDX)=ones(1,length(f1IDX:f2IDX));

if length(f)<3
    masker = fft_rect_filt(masker,f(1),f(2),Fs,0,0) ;%filter spectrally
else
    f3IDX=round(f(3)*npts/Fs);
    f4IDX=round(f(4)*npts/Fs);
    Mask(f3IDX:f4IDX)=ones(1,length(f3IDX:f4IDX));
    y1 = fft_rect_filt(masker,f(1),f(2),Fs,0,0) ;%filter spectrally
    y2 = fft_rect_filt(masker,f(3),f(4),Fs,0,0) ;%filter spectrally
    masker=[y1+y2]/2;
end

%scale masker to rms = 1
rms0=sqrt(mean(masker.^2));
masker=masker./rms0;
Msk_ss=sum(masker.^2);

randn('state',sum(100*clock));

LOW_reps=10;
LOW=masker;								% begin LNN generation with that same Gaussian sample
for loop=1:LOW_reps,
    LOW=LOW./(EB_envelope(LOW));	% divide time waveform by its envelope
    tmp_F=fft(LOW).*Mask;			% put into freq domain so you can filter off sidebands
    LOW=real(ifft(tmp_F));			% put back in time domain
end;

masker=masker*sqrt(Msk_ss/sum(masker.^2));	% scale to have RMS defined above
masker_env=EB_envelope(masker);			% extrat envelope (for plotting)
masker_f=abs(fft(masker));				% get frequency domain (for plotting)
LOW=LOW*sqrt(Msk_ss/sum(LOW.^2));
LOW_env=EB_envelope(LOW);
LOW_f=abs(fft(LOW));

if pltYN
    % plot results
    t=(1:npts)/Fs;
    fvec=(1:npts)*FreqRes;
    
    f1=figure(1);
    set(f1,'name','Gaussian noise','position',[587   489   686   363]);
    subplot(211);
    plot(t,masker,t,masker_env+0.1,'m');
    axis([0 0.8 -1.2 1.2]);
    xlabel('time');
    ylabel('amp');
    subplot(212);
    plot(fvec,masker_f,'*');
    axis([0 10000 0 3000]);
    xlabel('freq');
    ylabel('mag');
    
    f2=figure(2);
    set(f2,'name','Low-noise noise','position',[588    40   684   363]);
    subplot(211);
    plot(t,LOW,t,LOW_env+0.1,'m');
    axis([0 0.8 -1.2 1.2]);
    xlabel('time');
    ylabel('amp');
    subplot(212);
    plot(fvec,LOW_f,'*');
    axis([0 10000 0 3000]);
    xlabel('freq');
    ylabel('mag');
else
end
% Save results to disk, in WAV format
% wav_Scalar=0.75;
%
% masker=masker*wav_Scalar;			% scale down to prevent clipping
% 	filename='masker.wav';		% define filename
% 	wavwrite(masker,Fs,filename);	% save to disk, with appropriate sampling rate
%
% LOW=LOW*wav_Scalar;
% 	filename='LOW.wav';
% 	wavwrite(LOW,Fs,filename);
