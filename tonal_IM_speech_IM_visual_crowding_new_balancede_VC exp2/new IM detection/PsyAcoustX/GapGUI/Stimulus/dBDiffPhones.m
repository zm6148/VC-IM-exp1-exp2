function cfactor_earphone=dBDiffPhones(sig,phones,Fs)

% define the directory where frequency response data are stored
calDir=[cd '\Cal\'];

% get the frequency response of the headphones
switch phones
    case 'EAR5A'
        load([calDir 'EAR5A.mat']);
    case 'no_correction'
        cfactor_earphone=0;
        return;
    otherwise
        error('currently only the EAR5A earphones are supported...')
end

% for ease of computation create a vector with 1 Hz spacing going from the
% lowest to the highest frequency in the frequency response.
f=round(f);
calFreq=1000;
fInterp=min(f):max(f);

% interpolate the frequency response for values not present in the .mat
% file
dBInterp=interp1(f,dBre1kHz,fInterp);
dBInterp=dBInterp-dBInterp(logical(fInterp==calFreq)); % make 1 kHz the 0 dB reference

% convert the frequency response to a pressure-like variable
pRe1kHz=10.^(dBInterp./20);

% get the phase and spectrum of the signal
sigFFT=fft(sig,Fs);
sigSpec=abs(sigFFT);
sigAngle=angle(sigFFT);

% scale to spectral peak.
pSigSpec=sigSpec/max(sigSpec);

% create spectrum of headphone frequency response
pRe1kHzSpec=pSigSpec(1:round(Fs/2));
pRe1kHzSpec(fInterp)=pRe1kHz;

% add mirrored frequencies above Fs/2
pRe1kHzSpec=[pRe1kHzSpec fliplr(pRe1kHzSpec)];

% filter the signal by the frequency response
filteredSig=pSigSpec.*pRe1kHzSpec;

% put in imaginary form, take the ifft
sigIMAG=pSigSpec.*exp(1i*sigAngle);
filteredSigIMAG=filteredSig.*exp(1i*sigAngle);
sigWAV=real(ifft(sigIMAG));
filteredSigWAV=real(ifft(filteredSigIMAG));

% calculate the difference between the intended signal and the filtered
% signal.

cfactor_earphone=20*log10(rms(sigWAV)/rms(filteredSigWAV));

% make plots
pltYN=0;
if pltYN
    figure;
    plot(fInterp,pRe1kHz,'k'); hold on;
    plot(fInterp,pSigSpec,'g-');
    plot(fInterp,filteredSig,'m--');
    title(['correction factor (dB) = ' num2str(cfactor_earphone)]);
    
    keyboard;
else
end
