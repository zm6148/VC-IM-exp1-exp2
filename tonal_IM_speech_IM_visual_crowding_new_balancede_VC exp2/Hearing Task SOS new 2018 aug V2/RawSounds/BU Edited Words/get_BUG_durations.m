%get the durations of all the bug words for sandwich paper
% read in all the single words and get average for resamp and faster

clear all;
close all;
fclose all;

nwordrows = 8;
nwordcols = 5;
talk = 1:18;
ntalkers = length(talk);
duration = zeros(ntalkers,nwordrows,nwordcols);

wordpath = 'k:\BU Edited Words\';
for nt = 1:ntalkers
    nwcount = 0;
    for nrows = 1:nwordrows
        for ncols = 1:nwordcols
            talknum = talk(nt);
            if talknum < 10
                wordfile = [wordpath 'T0' int2str(talk(nt)) '\BUG_T0' int2str(talk(nt)) '_' int2str(nrows) '_' int2str(ncols) '.wav']
            else
                wordfile = [wordpath 'T' int2str(talk(nt)) '\BUG_T' int2str(talk(nt)) '_' int2str(nrows) '_' int2str(ncols) '.wav']
            end;
            [w,Fs] = wavread(wordfile);
            BUG_word_durations_secs(nt,nrows,ncols) = length(w)/Fs;
        end;
    end;
end;

save BUG_word_durations_secs BUG_word_durations_secs;


                    
                
            