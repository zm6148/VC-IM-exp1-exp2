function handles=setHPLevel(handles)

switch handles.stimParams.carrierType
    case 'tone'
        handles.stimParams.sigSpecLevel=handles.stimParams.sigLevel;
        handles.stimParams.carrierBW=1;
    case 'noise'
        handles.stimParams.carrierBW=handles.stimParams.noiseBW(2)-handles.stimParams.noiseBW(1);
        handles.stimParams.sigSpecLevel=handles.stimParams.sigLevel-10*log10(handles.stimParams.carrierBW);
    otherwise
        error('carrier type not recognized');
end

handles.stimParams.hpMaskerLevel=handles.stimParams.sigSpecLevel+handles.stimParams.hpOffset+10*log10(handles.stimParams.hpBW);    