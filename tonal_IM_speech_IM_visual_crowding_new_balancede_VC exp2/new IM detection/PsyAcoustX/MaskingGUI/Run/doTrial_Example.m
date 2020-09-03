function correctInt=doTrial_Example(handles,ISI)
%present single trial of experiment (called by runExperiment.m)
%edited by Skyler jennings on May 25th, 2012... now using audioplayer to
%create sound objects and synchronize the presentation lights

%-button light handles---------------------
int1_light=findall(0,'tag','int1_light_example');
int2_light=findall(0,'tag','int2_light_example');
int3_light=findall(0,'tag','int3_light_example');
int1_button=findall(0,'tag','obs1button');
int2_button=findall(0,'tag','obs2button');
int3_button=findall(0,'tag','obs3button');
%------------------------------------------

% create 2 intervals without target, one with-------
different=makeStim(handles);
handles.stimParams.targetLevel=-1000; %no target interval
foil1=makeStim(handles);
foil2=makeStim(handles);

stim(1,:)=foil1.stim;
stim(2,:)=foil2.stim;
stim(3,:)=different.stim;

presOrder=randperm(3); %randomize presenation order
correctInt=find(presOrder==3);
set(findall(0,'tag','answer_light_example'),'backgroundcolor',[0 1 0],'string',['target is presented in ''' num2str(find(presOrder==3)) '''']);drawnow;
%--------------------------------------------------

%concatenate intervals and ISI --------------------------------------
ISIbuff=zeros(ceil(ISI/(1/handles.Fs)),2);
snd_AllTrialsR=[[stim(presOrder(1),:);zeros(1,length(stim))]'; ISIbuff; [stim(presOrder(2),:);zeros(1,length(stim))]'; ISIbuff; [stim(presOrder(3),:);zeros(1,length(stim))]'; ISIbuff;];
snd_AllTrialsL=[[zeros(1,length(stim)); stim(presOrder(1),:)]'; ISIbuff; [zeros(1,length(stim)); stim(presOrder(2),:)]'; ISIbuff; [zeros(1,length(stim));stim(presOrder(3),:)]'; ISIbuff;];
snd_AllTrialsRL=[[stim(presOrder(1),:); stim(presOrder(1),:)]'; ISIbuff; [stim(presOrder(1),:); stim(presOrder(2),:)]'; ISIbuff; [stim(presOrder(1),:);stim(presOrder(3),:)]'; ISIbuff;];

h_L1L2L3=[int1_light int2_light int3_light]; % create a vector to hold the handles associated with the presentation lights

%assign the presentation mode (right, left or binaural) ------------------
if strcmp(handles.earPres,'R')
    APR=audioplayer(snd_AllTrialsR, handles.Fs,handles.bits);
elseif strcmp(handles.earPres,'L')
    APR=audioplayer(snd_AllTrialsL, handles.Fs,handles.bits);
else
    APR=audioplayer(snd_AllTrialsRL, handles.Fs,handles.bits);
end

% set up variables to pass to doLights.m for synchronization -------------
ttldur=APR.TotalSamples/handles.Fs;
APR.TimerPeriod=ttldur/30; 
APR.TimerFcn = {@doLights, APR, h_L1L2L3,ISI};
APR.UserData=1;

%disable the buttons
set(int1_button,'enable','off');
set(int2_button,'enable','off');
set(int3_button,'enable','off');

% play the all three intervals
playblocking(APR);
set(int3_light,'color',[0 0 0]);drawnow;


end
