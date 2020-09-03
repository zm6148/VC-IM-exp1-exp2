function doLights(...
    obj, ...            % refers to the object that called this function (necessary parameter for all callback functions)
    eventdata, ...      % this parameter is not used but is necessary for all callback functions
    APR, h_L1L2L3,ISI)  

% called by doTrial_mod.m.  used to synchronize the presentation lights
% with the audio

a=APR.CurrentSample;
del=a/APR.SampleRate; % get the delay from stimulus onset
% display({'Delay:' del; 'Sample:' a});
% set up a vector to hold the time windows for each interval
t_fcncall=(APR.TotalSamples/3)/APR.SampleRate;
tbuff=ISI/2;
intwindow=t_fcncall+tbuff:t_fcncall:APR.TotalSamples/APR.SampleRate;

% add a constant if you're computer is too slow
t_comp=0.0;
intwindow=intwindow+t_comp;

% reassign handle names
L1=h_L1L2L3(1);
L2=h_L1L2L3(2);
L3=h_L1L2L3(3);

% present the lights in the interval corresponding to the current sample of the stimulus
if del<tbuff
    set(L1,'color',[0 0 0]);drawnow;
    set(L2,'color',[0 0 0]);drawnow;
    set(L3,'color',[0 0 0]); drawnow;
    
elseif del < intwindow(1) && del > tbuff
    set(L1,'color',[1 1 1]);drawnow;
    
elseif del > intwindow(1) && del < intwindow(2)
    set(L1,'color',[0 0 0]);drawnow;
    set(L2,'color',[1 1 1]);drawnow;
    
else
    set(L2,'color',[0 0 0]);drawnow;
    set(L3,'color',[1 1 1]);drawnow;
end