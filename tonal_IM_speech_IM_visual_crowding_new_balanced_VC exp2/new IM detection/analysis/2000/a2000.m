[mask,Fs] = audioread('mask_2000_05.wav');
[target,Fs] = audioread('target_2000.wav');
[tm,Fs] = audioread('tm_2000_05.wav');

trim =  min([length(mask), length(target), length(tm)]);
mask = mask(1:trim);
target = target(1:trim);
tm = tm(1:trim);

%% fft

f = [0 : (trim-1)]*Fs/trim;
ind = find(f>100&f<8000);

Y_mask= 20*log10(abs(fft(mask)));
Y_target= 20*log10(abs(fft(target)));
Y_tm= 20*log10(abs(fft(tm)));

figure(1);
hold on;
%plot(f(ind),Y_mask(ind),'b');
%plot(f(ind),Y_target(ind),'r');
plot(f(ind),Y_tm(ind),'b');
legend('mask', 'target', 'mask+target');
saveas(gca, [pwd,'\2000cf'], 'pdf') %Save figure