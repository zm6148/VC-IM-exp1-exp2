function handles=load_parameters_mod(handles,pathname)
%load set of saved stimulus parameters to GUI

fid = fopen(fullfile(pathname,handles.paramsFile),'rt'); %overwrites previous file

handles.stimParams.carrierType=fscanf(fid,'%s',1);    %carrier type 'noise', 'tone'
handles.stimParams.sigLevel=fscanf(fid,'%f',1);       %dB
handles.stimParams.dur=fscanf(fid,'%f',1);            %signal duration (s)
handles.stimParams.fc=fscanf(fid,'%f',1);             %carrier frequency (Hz)
handles.stimParams.fm=fscanf(fid,'%f',1);             %modulator frequency (Hz)
handles.stimParams.ramp=fscanf(fid,'%f',1);           %sec

handles.stimParams.preToggle=fscanf(fid,'%f',1); 
handles.stimParams.preLevel=fscanf(fid,'%f',1);
handles.stimParams.preDur=fscanf(fid,'%f',1);
handles.stimParams.pmToggle=fscanf(fid,'%f',1); 
handles.stimParams.pmCF=fscanf(fid,'%f',1);
handles.stimParams.pmBW=fscanf(fid,'%f',1);

fclose(fid);


