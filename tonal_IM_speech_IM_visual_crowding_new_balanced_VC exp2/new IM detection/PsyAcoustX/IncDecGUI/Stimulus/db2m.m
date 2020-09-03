function M=db2m(moddB)
%convert modulation depth in dB back to linear units (0-1)
M=10^(moddB/20);

end