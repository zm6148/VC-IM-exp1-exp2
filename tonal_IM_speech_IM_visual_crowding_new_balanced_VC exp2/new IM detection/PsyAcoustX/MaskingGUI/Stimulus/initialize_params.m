function initialize_params(handles)


%-Import intialized parameters--------------------------
set(handles.maskerLevelEdit, 'String', num2str(handles.stimParams.maskerLevel));
set(handles.maskerDurEdit, 'String', num2str(1000*handles.stimParams.maskerDur));
set(handles.maskerRampEdit, 'String', num2str(1000*handles.stimParams.maskerRamp));
set(handles.maskerFreqEdit, 'String', num2str(handles.stimParams.maskerFreq));
set(handles.cutoffFreqs, 'String', num2str(handles.stimParams.maskerCutoffs));

set(handles.targetLevelEdit, 'String', num2str(handles.stimParams.targetLevel));
set(handles.targetDurEdit, 'String', num2str(1000*handles.stimParams.targetDur));
set(handles.targetRampEdit, 'String', num2str(1000*handles.stimParams.targetRamp));
set(handles.targetFreqEdit, 'String', num2str(handles.stimParams.targetFreq));

set(handles.preRampEdit, 'String', num2str(1000*handles.stimParams.preRamp));
set(handles.preDelayEdit, 'String', num2str(1000*handles.stimParams.preDelay));
set(handles.preFreqEdit, 'String', num2str(handles.stimParams.preFreq));
set(handles.preDurEdit, 'String', num2str(1000*handles.stimParams.preDur));
set(handles.preLevelEdit, 'String', num2str(handles.stimParams.preLevel));


set(handles.supFreqEdit, 'String', num2str(handles.stimParams.supFreq));
set(handles.supDurEdit, 'String', num2str(1000*handles.stimParams.supDur));
set(handles.supDelayEdit, 'String', num2str(1000*handles.stimParams.supDelay));
set(handles.supRampEdit, 'String', num2str(1000*handles.stimParams.supRamp));
set(handles.supLevelEdit, 'String', num2str(handles.stimParams.supLevel));

set(handles.delayEdit, 'String', num2str(1000*handles.stimParams.delay));
set(handles.targetAloneCheck, 'Value', handles.stimParams.targetAlone);
set(handles.trackTargetCheck, 'Value', handles.stimParams.trackTarget);
set(handles.hpMaskerToggle, 'Value', handles.stimParams.hpMaskerToggle);
set(handles.supToggle, 'Value', handles.stimParams.supToggle);
set(handles.blockEdit, 'String', num2str(handles.stimParams.blockNum));

maskerType=handles.stimParams.maskerType;
maskerSig=handles.stimParams.maskerSig;
notchOption=handles.stimParams.notchToggle;
preOption=handles.stimParams.preToggle;
preType=handles.stimParams.preType;
hpMaskOption=handles.stimParams.hpMaskerToggle;
supOption=handles.stimParams.supToggle;
%--------------------------------------------------------------------------

if get(handles.targetAloneCheck,'value')==1
    set(handles.trackTargetCheck, 'Value', 1,'enable','off');
    handles.stimParams.maskerType='forward';
    set(handles.simMask, 'Value', 0,'enable','off');
    set(handles.forMask, 'Value', 1);    
end

if get(handles.trackTargetCheck,'value')==1
    handles.stimParams.trackTarget=1;
else
end

if hpMaskOption==1
    set(handles.hpMaskerToggle, 'Value',1);
else
     set(handles.hpMaskerToggle, 'Value',0);
end

if supOption==1
    set(handles.supToggle, 'Value',1);
else
     set(handles.supToggle, 'Value',0);
end


%--precursor--------------------------
set(handles.precursorToggle, 'Value', preOption);

if strcmp(preType,'noise')
    set(handles.tonePreOn, 'Value',0);
    set(handles.noisePreOn, 'Value',1);
    set(handles.preFreqEdit, 'Enable', 'off');
else
    set(handles.tonePreOn, 'Value',1);
    set(handles.preFreqEdit, 'Enable', 'on');
    set(handles.noisePreOn, 'Value',0);
end

if preOption==1; %precursor on
    set(handles.tonePreOn, 'Enable', 'on');
    set(handles.noisePreOn, 'Enable', 'on');
    set(handles.preDurEdit, 'Enable', 'on'); 
    set(handles.preFreqEdit, 'Enable', 'on'); 
    set(handles.preRampEdit, 'Enable', 'on'); 
    set(handles.preDelayEdit, 'Enable', 'on'); 
    set(handles.preLevelEdit, 'Enable', 'on'); 
else %turn of options, precusor not selected
    set(handles.tonePreOn, 'Enable', 'off');
    set(handles.noisePreOn, 'Enable', 'off'); 
    set(handles.preDurEdit, 'Enable', 'off'); 
    set(handles.preFreqEdit, 'Enable', 'off'); 
    set(handles.preRampEdit, 'Enable', 'off'); 
    set(handles.preDelayEdit, 'Enable', 'off'); 
    set(handles.preLevelEdit, 'Enable', 'off'); 
end
%--------------------------------------

%-- supressor----------------------------
if supOption==1; %supressor on
    set(handles.supRampEdit, 'Enable', 'on'); 
    set(handles.supFreqEdit, 'Enable', 'on'); 
    set(handles.supLevelEdit, 'Enable', 'on'); 
    set(handles.supDurEdit, 'Enable', 'on'); 
     set(handles.supDelayEdit, 'Enable', 'on'); 
else %turn of options, supressor not selected
    set(handles.supRampEdit, 'Enable', 'off'); 
    set(handles.supFreqEdit, 'Enable', 'off'); 
    set(handles.supLevelEdit, 'Enable', 'off'); 
    set(handles.supDurEdit, 'Enable', 'off'); 
    set(handles.supDelayEdit, 'Enable', 'off'); 
end
%--------------------------------------



%----masker---------------------------------------------------------------
imshow('maskerFig.tif');%alpha(0.1)
set(handles.notchToggle, 'Value', notchOption);

if strcmp(maskerType,'simultaneous'); %masking select, default is forward masking
    set(handles.simMask, 'Value', 1);
    set(handles.forMask, 'Value', 0);
else
    set(handles.forMask, 'Value', 1);
    set(handles.simMask, 'Value',0);
end

if strcmp(maskerSig,'noise'); %masking signal select, default is noise
    set(handles.noiseMask, 'Value', 1);
    set(handles.toneMask, 'Value', 0);
    set(handles.maskerFreqEdit, 'Enable', 'Off');%disable selection of masker frequency until user selects
    set(handles.notchToggle, 'Enable', 'on');
    
    if  notchOption==1; %notched masker box checked
        set(handles.cutoffFreqs, 'Enable', 'On'); %turn on feature
        %alpha(1); %show masking schematic  
    else
        set(handles.cutoffFreqs, 'Enable', 'off'); %turn on feature    
    end
else %tone masker selected
    set(handles.toneMask, 'Value', 1);
    set(handles.cutoffFreqs, 'Enable', 'off'); %turn on feature   
    set(handles.notchToggle, 'Enable', 'off','Value',0);
    %alpha(0.1);
end
%---------------------------------------------------------





