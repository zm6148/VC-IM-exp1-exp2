function sigOut=rampstim(sig,ramp,Fs)
% Ramp sig with cos^2 ramps (Hanning window) of duration ramp  ms

    rampSamps = floor(Fs*ramp/1000);
    w=hanning(2*rampSamps)'; %hanning window is cosine^2
    w1=w(1:ceil((length(w))/2));
    w2=w(ceil((length(w))/2)+1:end);
    w1 = [w1 ones(1,length(sig)-length(w1))];
    w2 = [ones(1,length(sig)-length(w2)) w2];
    sigOut = sig.*w1.*w2; 

end