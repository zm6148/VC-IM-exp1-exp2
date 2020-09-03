function distance = invgreenwood( f )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

A=165;
a=2.1;
k=0.88;

distance=(log10((f/A+k))/a)*35;

end

