function [gapStim, refStim]=insertIncDec(xt,gapLoc,gapDur,Fs,f,IncDecLevel,DecrementYN,StimType)

% make the increment decrement signal
% IncDecLevel=0:3:30;
% rmsgap=zeros(length(IncDecLevel),1);
% k=rmsgap;
% for i=1:length(IncDecLevel)

nsamp=length(xt);
startSamp=round(nsamp*gapLoc);
nsigsamp=round(gapDur/(1/Fs));
endSamp=startSamp+nsigsamp-1;
if DecrementYN
    IncDecSig=xt(startSamp:endSamp).*-1;
    IncDecLevel=IncDecLevel*-1;
else
    IncDecSig=xt(startSamp:endSamp);
end

% scale the increment decrement signal
Pr=sqrt(mean(xt.^2)); % rms of the pedestal
dP=Pr*(10^(IncDecLevel/20))-Pr; % delta P
Psig=Pr+dP; % pressure of the increment/decrement signal
Pcurr=sqrt(mean(IncDecSig.^2)); % current rms of the increment / decrement signal
IncDecSig=IncDecSig./Pcurr; % set to rms=1;

% application of the decrement is based on Forrest and Green (1987) and
% Buunen and van Valkenburg (1979): k=x/s, where x=noise amplitude, s= new amplitdue with gap 
if DecrementYN
    k=Psig/Pr;
    IncDecSig=IncDecSig.*(1-k);
else
    k=(Psig/Pr)-1;
    IncDecSig=IncDecSig.*(k);
end

% add ramps to the increment / decrement
IncDecSig=rampstim(IncDecSig,2,Fs);

% add the signal to the pedestal
refStim=xt;
gapStim=xt;
gapStim(startSamp:endSamp)=xt(startSamp:endSamp)+IncDecSig;

% rmsgap =sqrt(mean(gapStim(startSamp:endSamp).^2));
% figure; plot(gapStim);
% waitfor(gcf);

% end