function strtlvl=setStartLevelIncDec(handles)

%fkHz=handles.stimParams.markerCutoffs(1)/1000;
pLoc=handles.stimParams.gapCenterLoc;
%dWidth=handles.stimParams.initialGapDur*1000;
%pedLev=handles.stimParams.markerLevel;
% 
% a=3.9*2.5;
% b=0.475;
% c=25*5;
% sBase=-6;
% 
% strtlvl=sBase+(a/fkHz)+(b/pLoc)+(c/dWidth);
% 
% if strtlvl>pedLev
%     strtlvl=pedLev;
% else
% end

if pLoc==0.475
    strtlvl=13;
elseif pLoc==0.02
    strtlvl=20;
else
    strtlvl=15;
end
