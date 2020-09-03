function filteredSig=createNotchedNoise(sig,f,Fs)
%filter noise to create notched noise using cutoffs f (4-element vector)
%sig is noise vector

%--elliptic filtering---------
% N=3;    %filter order
% Rp=0.5; %p-p ripple
% Rs=80;  %stopband atentuation (dB)
% [B A] = ellip(N,Rp,Rs,[f(1) f(2)]/(Fs/2));
% y1=filtfilt(B,A,sig);  
% [B A] = ellip(N,Rp,Rs,[f(3) f(4)]/(Fs/2));
% y2=filtfilt(B,A,sig); 
% filteredSig=[y1+y2]/2;
%----------------------------

y1 = fft_rect_filt(sig,f(1),f(2),Fs,0,0) ;%filter spectrally
y2 = fft_rect_filt(sig,f(3),f(4),Fs,0,0) ;%filter spectrally

filteredSig=[y1+y2]/2;

end

