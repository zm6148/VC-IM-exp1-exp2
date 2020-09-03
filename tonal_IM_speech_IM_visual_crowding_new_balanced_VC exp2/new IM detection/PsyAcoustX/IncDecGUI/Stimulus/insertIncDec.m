function [gapStim, refStim]=insertIncDec(xt,gapLoc,gapDur,Fs,f,IncDecLevel,DecrementYN,StimType)

nsamp=length(xt);
startSamp=round(nsamp*gapLoc);
nsigsamp=round(gapDur/(1/Fs));
endSamp=startSamp+nsigsamp-1;

% scale the increment decrement signal
Pr=sqrt(mean(xt.^2)); % rms of the pedestal
xt=xt./Pr; %set to rms = 1;

% define decrement signal, add ramps, scale
IncDecSig=xt(startSamp:endSamp);
Pcurr=sqrt(mean(IncDecSig.^2)); % current rms of the increment / decrement signal
IncDecSig=IncDecSig./Pcurr; % set to rms=1;

% add ramps to the increment / decrement
% application of the decrement is based on Forrest and Green (1987) and
% Buunen and van Valkenburg (1979): k=x/s, where x=noise amplitude, s= new amplitdue with gap
% Psig is 1+k (increment) or 1-k (decrement)

ramp=0.5*(gapDur*1000);
rampSamps = floor(Fs*ramp/1000);
w=hanning(2*rampSamps)'; %hanning window is cosine^2

if DecrementYN
    IncDecLevel=IncDecLevel*-1;
    dP=Pr*(10^(IncDecLevel/20))-Pr; % delta P    
    Psig=Pr+dP; % pressure of the increment/decrement signal
    w=w.*-(1-Psig)+1; % scale window and invert for decrement
else
    dP=Pr*(10^(IncDecLevel/20))-Pr; % delta P    
    Psig=Pr+dP; % pressure of the increment/decrement signal
    w=w*(Psig-1)+1;
end

steadyLevel=Psig;
w1=w(1:ceil((length(w))/2)); % make onset ramp
w2=w(ceil((length(w))/2)+1:end);% make offset ramp
wc=steadyLevel.*ones(1,length(IncDecSig)-(length(w1)+length(w2)));
IncDecSig = IncDecSig.*[w1 wc w2];

% add the signal to the pedestal
refStim=xt;
gapStim=xt;
gapStim(startSamp:endSamp)=IncDecSig;

