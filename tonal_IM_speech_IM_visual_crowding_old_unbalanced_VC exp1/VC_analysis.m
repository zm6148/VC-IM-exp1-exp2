degrees = [oo.trialData.targetDeg];
figure;
plot(degrees, '-o');

diffs = [];
for ii = 1 : length(degrees) - 1
    
    diffs = [diffs, degrees(ii + 1) - degrees(ii)];
    
end

figure;
plot(diffs)