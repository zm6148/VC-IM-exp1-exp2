function rmsAmp=rms(sig)
%compute rms amplitude of signal

rmsAmp=sqrt(mean(sig.^2));
  
end