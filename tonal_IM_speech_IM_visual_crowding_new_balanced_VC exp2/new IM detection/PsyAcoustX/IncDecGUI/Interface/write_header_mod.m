function write_header_mod(handles,results_pathname)

fid = fopen(results_pathname,'a');
fseek(fid,0,'eof');
time = clock;

stimParams=handles.blocks{handles.run.currentBlockNum-1}; %update stim params to current block

fprintf (fid, '\n');
fprintf (fid, '*********************************************************************************\n');
fprintf (fid, 'MODULATION DETECTION EXPERIMENT\n');
fprintf (fid, '%d/%d/%d %2d:%2d:%2d\n',time(2),time(3),time(1),time(4),time(5),round(time(6)));
fprintf (fid, '*********************************************************************************\n');
fprintf (fid, 'Listener:                   %s\n', handles.subID);
fprintf (fid, 'Paradigm:                   %s\n', '3AFC (2down-1up)');
fprintf (fid, 'Sample Rate (Hz):           %s\n', num2str(handles.Fs));
fprintf(fid,'\n');
fprintf(fid,'Carrier Type:               %s\n',stimParams.carrierType);       %carrier type 'noise', 'tone'

if strcmp(handles.stimParams.carrierType,'tone')
    fprintf(fid,'Carrier frequency (Hz):  %s\n',num2str(stimParams.fc));       %carrier frequency (Hz)
else
    fprintf (fid, 'Noise bandwidth (Hz):       %d %d\n', stimParams.noiseBW);
end
fprintf(fid,'Modulation frequency (Hz):  %s\n',num2str(stimParams.fm));        %modulator frequency (Hz)
fprintf(fid,'Signal level (dB):          %s\n',num2str(stimParams.sigLevel));  %dB
fprintf(fid,'Signal duration (ms):       %s\n',num2str(1000*stimParams.dur));  %signal duration (s)
fprintf(fid,'Ramping (ms):               %s\n',num2str(1000*stimParams.ramp));               %sec

fprintf(fid,'Precursor Toggle (boolean):        %s\n',num2str(stimParams.preToggle)); % write the precursor Toggle status
if stimParams.preToggle                                                               % write the precursor level and duration if preToggle=1
    fprintf(fid,'Precursor Level (dB SPL):      %s\n',num2str(stimParams.preLevel));
    fprintf(fid,'Precursor Duration (ms):       %s\n',num2str(stimParams.preDur)*1000);
else
end
fprintf(fid,'Partial Mod. Toggle (boolean):     %s\n',num2str(stimParams.pmToggle)); % write the partial modulations status
if stimParams.pmToggle                                                               % write the modulation CF and BW if pmToggle=1
    fprintf(fid,'Partial Modulation CF (Hz):    %s\n',num2str(stimParams.pmCF));
    fprintf(fid,'Partial Modualation BW (Hz):   %s\n',num2str(stimParams.pmBW));
else
end
fprintf (fid, '\n');
fclose (fid);