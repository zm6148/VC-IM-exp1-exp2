function write_header(handles,results_pathname)

fid = fopen(results_pathname,'a');
fseek(fid,0,'eof');
time = clock;

stimParams=handles.blocks{handles.run.currentBlockNum-1}; %update stim params to current block

fprintf (fid, '\n');
fprintf (fid, '*********************************************************************************\n');
fprintf (fid, 'MASKING EXPERIMENT\n');
fprintf (fid, '%d/%d/%d %2d:%2d:%2d\n',time(2),time(3),time(1),time(4),time(5),round(time(6)));
fprintf (fid, '*********************************************************************************\n');
fprintf (fid, 'Listener:                 %s\n', handles.subID);
if stimParams.trackTarget==1
    fprintf (fid, 'Paradigm:                 %s\n', '3AFC (2down-1up, tracking target)');
else
   fprintf (fid, 'Paradigm:                 %s\n', '3AFC (2up-1down, tracking masker)'); 
end
fprintf (fid, 'Sample Rate (Hz):         %s\n', num2str(handles.Fs));
if stimParams.targetAlone~=1

    if stimParams.preToggle==1
        fprintf (fid, 'Precursor type:           %s\n', stimParams.preType);
        fprintf (fid, 'Pre. duration (ms):       %s\n', num2str(1000*stimParams.preDur));
        fprintf (fid, 'Pre. ramping (ms):        %s\n', num2str(1000*stimParams.preRamp));
        if strcmp(stimParams.preType,'tone')
           fprintf (fid, 'Pre. frequency (Hz):      %s\n', num2str(stimParams.preFreq));
        end
        fprintf (fid, 'Pre. level (dB):          %s\n', num2str(stimParams.preLevel));
    end
    fprintf (fid, '\n');
    fprintf (fid, 'Masking paradigm:         %s\n', stimParams.maskerType);
        
    if stimParams.hpMaskerToggle==1
        fprintf (fid, 'HP masker:                %s\n', 'on');
    else
        fprintf (fid, 'HP masker:                %s\n', 'off');
    end
            
    if stimParams.notchToggle==1
        fprintf (fid, '                          %s\n', 'notched noise');
        fprintf (fid, 'Masker cutoffs (Hz):      %d %d %d %d\n', stimParams.maskerCutoffs);
    else %noise masker
        if strcmp(stimParams.maskerSig,'tone')
            fprintf (fid, 'Masker type:              %s\n','tone');
            fprintf (fid, 'Masker frequency (Hz):    %s\n', num2str(stimParams.maskerFreq));
        else
            fprintf (fid, 'Masker type:              %s\n','broadband noise');
        end
    end
    fprintf (fid, 'Initial masker level (dB):%s\n', num2str(stimParams.maskerLevel));
    fprintf (fid, 'Masker duration (ms):     %s\n', num2str(1000*stimParams.maskerDur));
    fprintf (fid, 'Masker ramping (ms):      %s\n', num2str(1000*stimParams.maskerRamp));
    fprintf (fid, '\n');
    
    if stimParams.supToggle==1
        fprintf (fid, 'Supp. duration (ms):      %s\n', num2str(1000*stimParams.supDur));
        fprintf (fid, 'Supp. Frequency (Hz):     %s\n', num2str(stimParams.supFreq));
        fprintf (fid, 'Supp. Level (dB):         %s\n', num2str(stimParams.supLevel));
        fprintf (fid, 'Supp. delay (ms):         %s\n', num2str(1000*stimParams.supDelay));
        fprintf (fid, 'Supp. ramping (ms):       %s\n', num2str(1000*stimParams.supRamp));
        fprintf (fid, '\n');
    end
      
else
    fprintf (fid, 'Target threshold paradigm:\n');
end

    fprintf (fid, 'Target frequency (Hz):    %s\n', num2str(stimParams.targetFreq));
    fprintf (fid, 'Initial target level (dB):%s\n', num2str(stimParams.targetLevel));
    fprintf (fid, 'Target duration (ms):     %s\n', num2str(1000*stimParams.targetDur));
    fprintf (fid, 'Target ramping (ms):      %s\n', num2str(1000*stimParams.targetRamp));
    fprintf (fid, 'Masker-target Delay (ms): %s\n', num2str(1000*stimParams.delay));

      

fprintf (fid, '\n');
fclose (fid);


