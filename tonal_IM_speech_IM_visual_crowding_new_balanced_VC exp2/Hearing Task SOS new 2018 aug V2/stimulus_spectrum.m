f = [0 : (length(y_masker)-1)]*Fs/length(y_masker);
Y1 = 20*log10(abs(fft(y_masker(1,:))));
Y2 = 20*log10(abs(fft(y_target(1,:))));

%ind = find(f>100&f<12000);
figure;
hold on;
plot(f,Y1);
plot(f,Y2);
set(gca,'xscale','log') 