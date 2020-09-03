tm_differnces = para_multi(:,16);
indexes_valley = findpeaks(max(tm_differnces)-tm_differnces);
plot(tm_differnces);
plot(max(tm_differnces)-tm_differnces);
