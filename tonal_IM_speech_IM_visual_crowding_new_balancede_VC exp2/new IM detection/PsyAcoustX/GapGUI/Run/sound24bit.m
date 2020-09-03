% sound24bit, plays wav files at 24 bits/sample
% function sound24bit(x,Fs)
%
% Last Revised: 06/19/06, J. Alexander

function sound24bit(x,Fs)

y = audioplayer(x,Fs,24);
play(y);