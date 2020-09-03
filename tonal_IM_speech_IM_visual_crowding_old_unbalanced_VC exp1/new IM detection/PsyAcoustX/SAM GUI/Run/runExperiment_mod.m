function [levels, trial, resps, reversalLevels,reversalBool, thresh, stdThresh, exitFlagLvl, handles]=runExperiment_mod(handles)
%runs adpative tracking paradigm after subject hits START button

handles.stimParams=handles.blocks{handles.run.currentBlockNum}; %update stim params to current block

% open the status window -------------------------%
hRW=get(0,'CurrentFigure');
runTracker_mod(handles);
set(findall(0,'tag','statusFIG'),'Units','normalized','Position',[1.05 .15 .5 .33]);

answer_light=findall(0,'tag','answer_light');
ISI=handles.run.ISI;
nReversals=handles.run.nReversals;
nReversalConsider=handles.run.nReversalConsider;
trial=1;
numCorrect=0;
direction=-1; %when direction changes--> count reversal
reversal=0;  %reversal count
lastDirection=direction;
nRevAdd=0;

% build a empty character array to be used to display tracking info in
% runTracker.m
trackChar_nrows=11;
trackChar_ncols=20; % must be an even number
trackInfoMat=99.*ones(trackChar_nrows,trackChar_ncols);
trackInfoIndx=reshape(1:1:numel(trackInfoMat),trackChar_nrows,trackChar_ncols);
rowsIndx1=1:2:trackChar_ncols;
rowsIndx2=2:2:trackChar_ncols;
trackIndxPair1=zeros(1,numel(trackInfoMat)/2);
trackIndxPair2=zeros(1,numel(trackInfoMat)/2);

for ncells=1:length(rowsIndx1)
    istart=ncells*trackChar_nrows-trackChar_nrows+1;
    iend=ncells*trackChar_nrows;
    trackIndxPair1(istart:iend)=trackInfoIndx(:,rowsIndx1(ncells));
    trackIndxPair2(istart:iend)=trackInfoIndx(:,rowsIndx2(ncells));
end

trackIndxPair=[trackIndxPair1; trackIndxPair2];
maxLvl=0;

% double click response window using the java robot to ensure that focus is
% not directed away from the response window when loading the next
% condition / repetition. 
robot = java.awt.Robot;
pos = get(hRW, 'Position');
set(0, 'PointerLocation', [pos(1)+0.5*pos(3) pos(2)+0.5*pos(4)]);
robot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
robot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
robot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
robot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);

%--loop trials until threshold is found-------------------
while reversal < nReversals    %stop run after this many reversals
    %while trial <=50 %stop after fixed number of trials
    
    set(findall(0,'tag','start'),'string','RUNNING','foregroundcolor','r','Enable','off'); %button says running
    
    %--turn OFF close and plot buttons while runnign --------
    set(findall(0,'tag','plotRespButton'),'Visible','off'); %turn on track plotting button
    set(findall(0,'tag','closeRespWinButton'),'Visible','off'); %turn on close button
    %--------------------------------------------------------
    
    %--turn ON buttons; experiment started--------
    set(findall(0,'tag','button1'),'enable','on');set(findall(0,'tag','button2'),'enable','on');set(findall(0,'tag','button3'),'enable','on');
    %--------------------------------------------
    
    % select size of step size---------------------
    if reversal > 3
        stepSize=handles.run.stepSize.final;
    else
        stepSize=handles.run.stepSize.initial;
    end
    %---------------------------------------------
    
    
    levels(trial,1)=m2dB(handles.stimParams.M); %keep track of modulation level (dB)
    
    
    disp(['Current level (dB): ' num2str(levels(end))]); %display current level
    
    
    %     disp(['Carrier spec level:' num2str(95+20*log10(sqrt(mean((handles.modstim).^2))/0.4)-10*log10(handles.stimParams.carrierBW))]);
    %     disp(['hpMasker spec level:' num2str(95+20*log10(sqrt(mean((handles.hpMasker).^2))/0.4)-10*log10(handles.stimParams.hpBW))]);
    %
    
    
    set(findall(0,'tag','depvarLevel'),'String',num2str(levels(end)));
    correctInt=doTrial_mod(handles,ISI); %present single trial of stimulus
    %correctInt is where the target actually was
    set(0,'CurrentFigure',hRW);
    
    % set focus back to the response window.
    figure(hRW);
    
    uiwait; %get user's response
    buttonPressed=getappdata(0,'buttonPressed');
    answerFlag=buttonPressed==correctInt; %subject's answer 0=incorrect, 1=correct
    
    %---manipulate stimuli based on user's response------------------------
    if answerFlag==1
        numCorrect=numCorrect+1;
        set(answer_light,'backgroundcolor',[0 1 0],'string','CORRECT');drawnow;pause(0.25);
        set(answer_light,'backgroundcolor',[0 0 0],'string','');
        set(findall(0,'tag','currCorrect'),'String','+');
        
        if numCorrect==2 %2 correct, change level
            handles.stimParams.M=db2m(m2dB(handles.stimParams.M)-stepSize); %decrease modulation depth
            
            numCorrect=0; %reset adaptive track counter
            direction=-1;
        end
    else %incorrect
        direction=1;
        numCorrect=0; %reset adaptive track counter
        set(answer_light,'backgroundcolor',[1 0 0],'string','INCORRECT');drawnow;pause(0.25);
        set(answer_light,'backgroundcolor',[0 0 0],'string','');
        set(findall(0,'tag','currCorrect'),'String','-');
        % don't let m (in dB) be greater than 0 dB
        if db2m(m2dB(handles.stimParams.M)+stepSize)>1
            handles.stimParams.M=1;
        else
            handles.stimParams.M=db2m(m2dB(handles.stimParams.M)+stepSize); %increase modulation depth
        end
        
        
    end
    %-------------------------------------------------------------------
    
    
    if lastDirection ~=direction %reversal has occured
        if nRevAdd==0
        else
            reversal=reversal+1;
            reversalLevels(reversal,1)=levels(trial,1); %record level of reversal
            reversalBool(trial, 1)=1; %vector showing where reversals are
        end
        nRevAdd=nRevAdd+1;
    else
        if nRevAdd==0 && answerFlag==0
            nRevAdd=nRevAdd+1;
        else
        end
        reversalBool(trial, 1)=0;
    end
    
    resps(trial,1)=answerFlag; %keep track of S's responses
    
    trackInfoArray=[resps(trial,1);levels(trial,1)];
    trackInfoMat(trackIndxPair(:,trial))=trackInfoArray;
    trackInfoStr=num2str(trackInfoMat');
    trackInfoStr(trackInfoStr=='9')=' ';
    
    set(findall(0,'tag','trackStr'),'String',trackInfoStr);
    exitFlagLvl=0;
%     if trial >= 5
%         last4lvls=levels(trial-3:trial);
%         flagLvl=last4lvls>=maxLvl;
%         if sum(flagLvl)==4
%             % subject is at limits of equipment... need to exit
%             exitFlagLvl=1;
%             break;
%         else
%             exitFlagLvl=0;
%         end
%     else
%         exitFlagLvl=0;
%     end
    
    trial=trial+1; %increment trial #
    
    lastDirection=direction; %update track direction
    
end
%--------------------------------------------------------

set(findall(0,'tag','start'),'string','START','foregroundcolor','b'); %button displays end of run

if handles.run.currentBlockNum < length(handles.blocks)
    set(findall(0,'tag','start'),'enable','on'); %enable button to start new block if there are blocks left to run
else
    set(findall(0,'tag','closeRespWinButton'),'Visible','On'); %turn on close button
    set(findall(0,'tag','start'),'Visible','Off'); %disable the start button
end

set(findall(0,'tag','plotRespButton'),'Visible','On'); %turn on track plotting button


%---compute listeners threshold /std-----
thresh=mean(reversalLevels(end-nReversalConsider+1:end)); %take mean of last 'nReversalConsider' reversals as threshold
stdThresh=std(reversalLevels(end-nReversalConsider+1:end));
disp('---------------------------------------');
disp(['Threshold: ' num2str(thresh) 'dB']);
disp(['Std:       ' num2str(stdThresh) 'dB']);
disp('---------------------------------------');
set(findall(0,'tag','threshText'),'String',{['Thresh: ' num2str(thresh,'%4.2f') 'dB'];['Std: ' num2str(stdThresh,'%4.2f') 'dB']})
%----------------------------------------
set(findall(0,'tag','start'),'String','Saving...','enable','off');
set(findall(0,'tag','start'),'String','START','enable','on');

