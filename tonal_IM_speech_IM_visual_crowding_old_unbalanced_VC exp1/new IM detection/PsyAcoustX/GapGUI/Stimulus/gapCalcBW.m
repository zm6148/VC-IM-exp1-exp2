function BW=gapCalcBW(cFreqs)

if length(cFreqs)==1
    BW=1;
elseif length(cFreqs)==2
    BW=cFreqs(2)-cFreqs(1);
elseif length(cFreqs)==4
    BW=[cFreqs(4)-cFreqs(3)] + [cFreqs(2)-cFreqs(1)];
else
    error('must have 1, 2, or 4 cutoff frequencies');
end