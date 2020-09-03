clear all;close all;clc;
%plays 10 sec sinusoid of amplitude ±1 (0.707 RMS) at user selected level and frequency

calPhones='EAR5A';
display(['using ' calPhones '.mat file to define test frequencies.']);
load([calPhones '.mat']);


Fs=44100;
caldB=100;  %system calibration level for ER2 headphones routed through TDT SI Headphone Module
             %Lynx sound card @ +4dBu and Ch. 3 fader set at -19 dB attenutation  
             %Lynx fader=-19; SPL=93.4; V=-4.69
%caldB=102.3; %max output of Sennheiser headphones [fader=-28; SPL=102.3]
           
% ref=1/sqrt(2); % MATLAB RMS amplitude of 1/sqrt(2)=0.707 => caldB  level in SPL [must calibrate before experiment]
ref=.4;

dur=10; %duration of tone           
t=linspace(0,dur,dur*Fs);
fRange=[1779 2110];
fAbove=f>fRange(1);
fBelow=f<fRange(2);
fIndx=logical(fAbove.*fBelow);
f2Eval=f(fIndx);
dB2Eval=dBre1kHz(fIndx);
newCorrect=zeros(length(dB2Eval),1);

for i=1:length(f2Eval)
    sig=sin(2*pi*t*f2Eval(i));
    
    rms_sig=rms(sig);
    currentdB=20*log10(rms_sig/ref)+caldB;
    deldB=caldB-currentdB;
    newSig=scalebydB(sig,deldB);
    rms_sig=rms(sig); %current RMS of signal
    rms_sig_new=rms_sig*10.^(deldB/20); %new RMS
    scale_f=rms_sig_new/rms_sig;
    scaledSig=scale_f*sig;
    display(['current frequency is: ' num2str(f2Eval(i))]);
    sound(scaledSig,Fs);
    display('Entered measured response.');
    actdB=input('-->');
    dBoffset=actdB-caldB;
    display(['measured offset = ' num2str(dBoffset) ' offset on file = ' num2str(dB2Eval(i))]);
    newCorrect(i)=dBoffset;
end

saveYN=input('save data YN?');

if saveYN
    dBre1kHz(fIndx)=newCorrect;
    save([calPhones '.mat'],'f','dBre1kHz');
else
end





