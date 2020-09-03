function currentdB=amp2db(sig)
%report sig amplitude in dB


caldB=getappdata(0,'caldB');
ref=0.4;  % need to set lower than .707 when using a noise stimulus at a high level at the peaks of the noise will be clipped
% at ref =1/2, clipping will be avoided until 5 dB below caldB.  At cal dB
% clipping will occur for peaks greater than 2 std dev. above the mean (2.27 % of peaks).  
%ref=1/sqrt(2); % MATLAB RMS amplitude of 1/sqrt(2)=0.707 => caldB  level in SPL [must calibrate before experiment]
rms_sig=rms(sig);
currentdB=20*log10(rms_sig/ref)+caldB;
end









