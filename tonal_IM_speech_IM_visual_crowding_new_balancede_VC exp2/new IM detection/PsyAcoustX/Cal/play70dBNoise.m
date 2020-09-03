load('stim70dBNoise.mat');

Nreps=10;

sig=repmat(sig,1,Nreps);

sound(sig,Fs,Bits);