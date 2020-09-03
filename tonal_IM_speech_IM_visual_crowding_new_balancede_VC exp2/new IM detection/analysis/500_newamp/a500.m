clear all;
close all;

%[mask,Fs] = audioread('mask_500_05.wav');
[target,Fs] = audioread('target_500_03_newamp.wav');
[tm,Fs] = audioread('tm_500_03_newamp.wav');

trim =  min([length(target), length(tm)]);
%mask = mask(1:trim);
target = target(1:trim);
tm = tm(1:trim);

%% fft

f = [0 : (trim-1)]*Fs/trim;
ind = find(f>100&f<8000);

%Y_mask= 20*log10(abs(fft(mask)));
Y_target= 20*log10(abs(fft(target)));
%Y_tm= 20*log10(abs(fft(tm)));

figure(1);
hold on;
%plot(f(ind),Y_mask(ind),'b');
plot(f(ind),Y_target(ind),'r');
%plot(f(ind),Y_tm(ind),'g');
legend('target', 'mask+target');
saveas(gca, [pwd,'\500cf'], 'pdf') %Save figure

%% stft

% Divide the signal into sections of length 128, windowed with a Hamming window.
% Specify 120 samples of overlap between adjoining sections.
% Evaluate the spectrum at  frequencies and  time bins.

figure(2);
window_length = floor(length(target)/20);
overlap = 0.2*window_length;
spectrogram(target,window_length ,overlap, window_length, Fs, 'yaxis')


