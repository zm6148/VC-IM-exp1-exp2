function write_parameters_mod(handles,pathname)
%saves stimulus parameters from GUI for easy re-loading

fid = fopen(fullfile(pathname,handles.paramsFile),'w+'); %overwrites previous file
   
fprintf(fid,'%s\n',num2str(handles.stimParams.carrierType));    %carrier type 'noise', 'tone'
fprintf(fid,'%s\n',num2str(handles.stimParams.sigLevel));       %dB
fprintf(fid,'%s\n',num2str(handles.stimParams.dur));            %signal duration (s)
fprintf(fid,'%s\n',num2str(handles.stimParams.fc));             %carrier frequency (Hz)
fprintf(fid,'%s\n',num2str(handles.stimParams.fm));             %modulator frequency (Hz)
fprintf(fid,'%s\n',num2str(handles.stimParams.ramp));           %sec
fprintf(fid,'%s\n',num2str(handles.stimParams.preToggle));    
fprintf(fid,'%s\n',num2str(handles.stimParams.preLevel)); 
fprintf(fid,'%s\n',num2str(handles.stimParams.preDur)); 
fprintf(fid,'%s\n',num2str(handles.stimParams.pmToggle));    
fprintf(fid,'%s\n',num2str(handles.stimParams.pmCF)); 
fprintf(fid,'%s\n',num2str(handles.stimParams.pmBW)); 


fclose (fid);


