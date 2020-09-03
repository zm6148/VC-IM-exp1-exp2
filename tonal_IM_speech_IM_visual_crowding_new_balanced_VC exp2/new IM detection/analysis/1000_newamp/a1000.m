%[mask,Fs] = audioread('mask_1000_05.wav');
[target,Fs] = audioread('target_1000_newamp.wav');
[tm,Fs] = audioread('tm_1000_05_newamp.wav');

trim =  min([length(target), length(tm)]);
%mask = mask(1:trim);
target = target(1:trim);
tm = tm(1:trim);

%% fft

f = [0 : (trim-1)]*Fs/trim;
ind = find(f>100&f<8000);

%Y_mask= 20*log10(abs(fft(mask)));
Y_target= 20*log10(abs(fft(target)));
Y_tm= 20*log10(abs(fft(tm)));

figure(1);
hold on;
%plot(f(ind),Y_mask(ind),'b');
plot(f(ind),Y_target(ind),'r');
plot(f(ind),Y_tm(ind),'g');
legend('target', 'mask+target');
saveas(gca, [pwd,'\1000cf'], 'pdf') %Save figure