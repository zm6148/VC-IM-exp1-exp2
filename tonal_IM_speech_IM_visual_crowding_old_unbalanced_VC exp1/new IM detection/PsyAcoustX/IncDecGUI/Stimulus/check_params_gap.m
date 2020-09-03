function [exitYN, exitMsg]=check_params_gap(handles)

% check if all cutoff frequencies are specified
stimClass={'marker';'bnoise';'precursor'};
exit1=zeros(1,length(stimClass));
exit2=exit1;

for n=1:length(stimClass)
    typeStr=[stimClass{n} 'Type'];
    cutoffStr=[stimClass{n} 'Cutoffs'];
    sType=handles.stimParams.(typeStr);
    cutoffVals=handles.stimParams.(cutoffStr);
    exitMsg1='Cutoff frequencies must be specified';
    exitMsg2='Cutoff frequencies must be monotonically increasing';
    switch sType
        case 'NBN'
            exit1(n)=length(cutoffVals)~=2;
        case 'NtchN'
            exit1(n)=length(cutoffVals)~=4;
        case 'Tone'
            exit1(n)=length(cutoffVals)~=1;
        otherwise
            exit1(n)=0;
    end
    % check if cutoff frequencies are monotonically increasing
    monotonicYN=all(diff(cutoffVals)>0);  % icreasing if 1
    exit2(n)=monotonicYN==0;    
end
exit1=any(exit1==1);
exit2=any(exit2==1);
exitVec=[exit1 exit2];
MsgVec={exitMsg1 exitMsg2};
exitYN=any(exitVec)==1;

if exitYN
    exitMsg=MsgVec{exitVec};
else
    exitMsg='';
end