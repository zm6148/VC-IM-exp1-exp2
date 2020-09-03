function handles=load_parameters(handles,pathname)
%load set of saved stimulus parameters to GUI

fid = fopen(fullfile(pathname,handles.paramsFile),'rt'); %overwrites previous file

handles.stimParams.delay=fscanf(fid,'%f',1);         %sec (simult.=delay btw onset of masker & target; forward=delay btw masker offset & target onset)
handles.stimParams.preToggle=fscanf(fid,'%f',1);     %precursor toggle (default is off)
handles.stimParams.preType=fscanf(fid,'%s',1);       %precursor type ('tone' or 'noise')
handles.stimParams.preFreq=fscanf(fid,'%f',1);       %frequency for tonal precursor
handles.stimParams.preDur=fscanf(fid,'%f',1);        %frequency duration (s)
handles.stimParams.preLevel=fscanf(fid,'%f',1);      %dB
handles.stimParams.preRamp=fscanf(fid,'%f',1);       %sec
handles.stimParams.preDelay=fscanf(fid,'%f',1);      %sec; delay between end of precursor and masker
handles.stimParams.maskerType=fscanf(fid,'%s',1);    %masker type 'simultaneous' or 'forward'
handles.stimParams.maskerSig=fscanf(fid,'%s',1);     %masker signal: 'tone'=pure tone; 'noise'=broadband noise
handles.stimParams.maskerFreq=fscanf(fid,'%f',1);    %Hz; only used when masker is tone, not noise
handles.stimParams.maskerDur=fscanf(fid,'%f',1);     %sec
handles.stimParams.notchToggle=fscanf(fid,'%f',1);   %notched noise toggle (0=off, 1=on)
handles.stimParams.hpMaskerToggle=fscanf(fid,'%f',1);%hp masker toggle (0=off, 1=on)
handles.stimParams.hpMaskerLevel=fscanf(fid,'%f',1); %hp masker level
handles.stimParams.maskerCutoffs=fscanf(fid,'%d',[1,4]); %masker cutoffs for notched noise
handles.stimParams.maskerLevel=fscanf(fid,'%f',1);   %fB
handles.stimParams.maskerRamp=fscanf(fid,'%f',1);    %sec
handles.stimParams.targetLevel=fscanf(fid,'%f',1);   %fB
handles.stimParams.targetFreq=fscanf(fid,'%f',1);    %Hz
handles.stimParams.targetDur=fscanf(fid,'%f',1);     %sec
handles.stimParams.targetAlone=fscanf(fid,'%f',1);   %1=masker off, search target threshold
handles.stimParams.trackTarget=fscanf(fid,'%f',1);   %0=track masker (default); 1=track target
handles.stimParams.targetRamp=fscanf(fid,'%f',1);    %sec
handles.stimParams.supToggle=fscanf(fid,'%f',1);     %suppressor (0=off, 1=on)
handles.stimParams.supFreq=fscanf(fid,'%f',1);       %frequency of suppressor
handles.stimParams.supDur=fscanf(fid,'%f',1);        %supressor duration (sec)
handles.stimParams.supDelay=fscanf(fid,'%f',1);      %delay from stim onset (after buffer) to start of suppressor
handles.stimParams.supLevel=fscanf(fid,'%f',1);      %dB
handles.stimParams.supRamp=fscanf(fid,'%f',1);       %sec

fclose(fid);


