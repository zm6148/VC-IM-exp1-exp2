function plotStimSpectrogam(handles)
%plots spectrogram of stimulus

Fs=handles.Fs;
sig=handles.stim;
width=25; %ms
step=2;   %ms

figure;
[yo,fo,to]=specgram(sig/max(sig),2^14,Fs,hamming(round((width/1000)*Fs)),round(((width-step)/1000)*Fs));
amp=abs(yo)/((width/1000)*Fs);
imagesc(to*1000, fo, 20*log10(amp),[-100 0]);colorbar;
axis xy;shading flat;xlabel('Time (ms)');ylabel('Frequency (Hz)');
ylim([0 10000]);

end

