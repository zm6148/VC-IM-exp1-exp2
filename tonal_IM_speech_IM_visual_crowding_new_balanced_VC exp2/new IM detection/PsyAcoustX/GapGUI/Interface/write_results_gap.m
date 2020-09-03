function   write_results_gap(handles,results_pathname)
% Write out results: response track, reversals, threshold, & std

levels=getappdata(0,'levels');
resps=getappdata(0,'resps');
reversalBool=getappdata(0,'reversalBool');
reversalLevels=getappdata(0,'reversalLevels');
thresh=getappdata(0,'thresh');
stdThresh=getappdata(0,'stdThresh');

temp = strrep(num2str(reversalBool'), '1', '*')';temp(ismember(temp,' '))=[];
stars=strrep(temp','0',' ')';

data = cat(1, num2cell(levels'),num2cell(resps'),cellstr(stars)');

fid = fopen(results_pathname,'a');
fseek(fid,0,'eof');
fprintf (fid, '-------------------------------------------\n');
fprintf (fid, 'gap (ms):  Resp.(1=corr.; 0=incorr.):\n');
fprintf (fid, '-------------------------------------------\n');
fprintf(fid,sprintf('%.2f     %.2f%s\n', data{:}));
fprintf (fid, '------------------------------------------------------------\n');
fprintf (fid, 'Reversal Levels (ms): ');
fprintf(fid,'%.2f ', reversalLevels);
fprintf(fid,'\n');
fprintf (fid, 'Threshold (ms): %.2f\n', thresh);
fprintf (fid, 'SD (ms): %.2f\n', stdThresh);
fprintf (fid, '------------------------------------------------------------\n');
fprintf (fid, '\n');
fclose (fid);


