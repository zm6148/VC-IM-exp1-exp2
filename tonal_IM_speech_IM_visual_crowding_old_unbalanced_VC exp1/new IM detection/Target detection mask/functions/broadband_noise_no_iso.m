function y = broadband_noise_no_iso(Fs, spl, length_n)

% random noise
nn = rand(1,length_n);
nn = nn-mean(nn);
nn = (nn/rms(nn))*10^((spl-66)/20);

% build ramp for added noise
Ramp = 10e-3 ; %ramp duration 10ms
ramp = sin(0:.5*pi/round(Ramp*Fs):pi/2).^2;%ramp time vector
envelope_noise = [ramp ones(length_n-2*length(ramp),1)' fliplr(ramp)];

y = envelope_noise .* nn;

end