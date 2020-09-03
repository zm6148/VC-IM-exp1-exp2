function exp3_results = exp3_process(exp3_data)

VC_data = exp3_data.oo;
conditions = size(VC_data, 2);
exp3_results = [];
for oi=1:conditions
    
    % Ask Quest for the final estimate of threshold.
    t=QuestMean(VC_data (oi).q);
    sd=QuestSd(VC_data (oi).q);
    
    exp3_results = [exp3_results; t, sd, 10^t];
    
end
end