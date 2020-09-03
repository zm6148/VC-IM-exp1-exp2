function newSig=scale2db_mod(sig,dB,phones,Fs,varargin)
%scale sig to specified level in dB


if isempty(varargin)
    currentdB=amp2db(sig); %current intensity of signal (dB)
else
    refstim=varargin{1};
    currentdB=amp2db(refstim); %current intensity of signal (dB)
end

deldB=dB-currentdB;
cfactor_earphone=dBDiffPhones(sig,phones,Fs);
deldB=deldB+cfactor_earphone;

newSig=scalebydB(sig,deldB);









