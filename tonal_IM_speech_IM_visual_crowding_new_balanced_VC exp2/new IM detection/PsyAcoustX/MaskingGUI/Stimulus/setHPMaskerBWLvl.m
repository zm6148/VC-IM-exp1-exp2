function handles=setHPMaskerBWLvl(handles)

handles.stimParams.hpBW=handles.stimParams.hpCutUpper-(handles.stimParams.hpMaskerCutoffNrmlz.*handles.stimParams.targetFreq);
handles.stimParams.hpMaskerLevel=handles.stimParams.targetLevel+handles.stimParams.hpMaskerOffset+10*log10(handles.stimParams.hpBW); 