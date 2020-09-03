function y = pesudo_random_noise_no_iso(Fs, Lowestfreq, Highestfreq, Duration)

%[spl_c,freq]=iso226(spl);

t.Fs = Fs;
M.Lowestfreq = Lowestfreq;
M.Highestfreq =  Highestfreq;
t.Duration = Duration;
t.t = 0 : 1/t.Fs : t.Duration; % time vector

M.fNoise = M.Lowestfreq : 1/t.t(end) : M.Highestfreq ;

M.which_comp = randperm(length(M.fNoise));
M.which_comp = M.which_comp(1:length(M.fNoise)-10);
M.comp_phase = rand(size(M.which_comp))*pi;
M.M = 0.*t.t;
M.F = 0.*t.t;

% nn = rand(size(t.t)); nn = nn-mean(nn);
% [b,a] = butter(4,


for which_comp = 1 : length(M.which_comp)
    dummy = sin(2*pi*M.fNoise(M.which_comp(which_comp))*t.t + M.comp_phase(which_comp));
    %m_spl=spl;
    % dummy = (dummy/rms(dummy))*10^((m_spl-93)/20);
    M.M = M.M + dummy;
end

y = M.M;


end