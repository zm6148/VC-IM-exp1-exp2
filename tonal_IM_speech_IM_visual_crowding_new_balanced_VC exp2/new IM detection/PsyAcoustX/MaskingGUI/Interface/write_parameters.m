function write_parameters(handles,pathname)
%saves stimulus parameters from GUI for easy re-loading

fid = fopen(fullfile(pathname,handles.paramsFile),'w+'); %overwrites previous file
   
fprintf(fid,'%d\n',handles.stimParams.delay);         %sec (simult.=delay btw onset of masker & target; forward=delay btw masker offset & target onset)
fprintf(fid,'%d\n',handles.stimParams.preToggle);     %precursor toggle (default is off)
fprintf(fid,'%s\n',handles.stimParams.preType);       %precursor type ('tone' or 'noise')
fprintf(fid,'%d\n',handles.stimParams.preFreq);       %frequency for tonal precursor
fprintf(fid,'%d\n',handles.stimParams.preDur);        %frequency duration (s)
fprintf(fid,'%d\n',handles.stimParams.preLevel);      %dB
fprintf(fid,'%d\n',handles.stimParams.preRamp);       %sec
fprintf(fid,'%d\n',handles.stimParams.preDelay);      %sec; delay between end of precursor and masker
fprintf(fid,'%s\n',handles.stimParams.maskerType);    %masker type 'sim'=simultaneous; 'for'=forward
fprintf(fid,'%s\n',handles.stimParams.maskerSig);     %masker signal: 'tone'=pure tone; 'noise'=broadband noise
fprintf(fid,'%d\n',handles.stimParams.maskerFreq);    %Hz; only used when masker is tone, not noise
fprintf(fid,'%d\n',handles.stimParams.maskerDur);     %sec
fprintf(fid,'%d\n',handles.stimParams.notchToggle);   %notched noise toggle (0=off, 1=on)
fprintf(fid,'%d\n',handles.stimParams.hpMaskerToggle);%hp masker toggle (0=off, 1=on)
fprintf(fid,'%d\n',handles.stimParams.hpMaskerLevel); %hp masker level
fprintf(fid,'%d %d %d %d\n',handles.stimParams.maskerCutoffs); %masker cutoffs for notched noise
fprintf(fid,'%d\n',handles.stimParams.maskerLevel);   %dB
fprintf(fid,'%d\n',handles.stimParams.maskerRamp);    %sec
fprintf(fid,'%d\n',handles.stimParams.targetLevel);   %dB
fprintf(fid,'%d\n',handles.stimParams.targetFreq);    %Hz
fprintf(fid,'%d\n',handles.stimParams.targetDur);     %sec
fprintf(fid,'%d\n',handles.stimParams.targetAlone);   %1=masker off, search target threshold
fprintf(fid,'%d\n',handles.stimParams.trackTarget);   %0=track masker (default); 1=track target
fprintf(fid,'%d\n',handles.stimParams.targetRamp);    %sec
fprintf(fid,'%d\n',handles.stimParams.supToggle);     %suppressor (0=off, 1=on)
fprintf(fid,'%d\n',handles.stimParams.supFreq);       %frequency of suppressor
fprintf(fid,'%d\n',handles.stimParams.supDur);        %supressor duration (sec)
fprintf(fid,'%d\n',handles.stimParams.supDelay);      %delay from stim onset (after buffer) to start of suppressor
fprintf(fid,'%d\n',handles.stimParams.supLevel);      %dB
fprintf(fid,'%d\n',handles.stimParams.supRamp);       %sec

fclose (fid);


