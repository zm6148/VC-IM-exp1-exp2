function [gapStim, refStim]=insertGap(xt,gapLoc,gapDur,gapRamp,Fs,stimType)

% divide xt based on gapLoc
nsamp=length(xt);
gapSamp=round(nsamp*gapLoc);
xtPreGap=xt(1:gapSamp);
xtPostGap=xt(gapSamp+1:end);

% apply inner ramps based on gapRamp
rampSamps = floor(Fs*gapRamp);
w=hanning(2*rampSamps)'; %hanning window is cosine^2
w=w(1:ceil((length(w))/2));
w1 = [w ones(1,length(xtPreGap)-length(w))];
w2 = [w ones(1,length(xtPostGap)-length(w))];
xtPreGapRamped = fliplr(fliplr(xtPreGap).*w1);
xtPostGapRamped = xtPostGap.*w2;

% insert the gap 
nGapPts=floor(gapDur/(1/Fs));
gapVec=zeros(1,nGapPts);
gapStim=[xtPreGapRamped gapVec xtPostGapRamped];
refStim=xt;
