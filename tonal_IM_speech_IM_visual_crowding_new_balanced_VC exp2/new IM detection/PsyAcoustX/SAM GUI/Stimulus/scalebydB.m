function scaledSig=scalebydB(sig,dB)
%scale (rms) amplitude of sig by dB

rms_sig=rms(sig); %current RMS of signal
rms_sig_new=rms_sig*10.^(dB/20); %new RMS
scale_f=rms_sig_new/rms_sig;
scaledSig=scale_f*sig;


end









