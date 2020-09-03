function [stimParamVals]=setStimParam(strInput)

% -- read in a string array separated by commas and store as a numeric
% array
wspace_indx=logical(isspace(strInput)); % find white space
strInput=strInput(~wspace_indx); % trim off the white space
inputCell=textscan(strInput,'%s','delimiter',','); % extract the numeric values using a comma as a delimiter
inputMat=cellfun(@str2double,[inputCell{:}]);% save the numeric array
stimParamVals=inputMat; % return the numeric array