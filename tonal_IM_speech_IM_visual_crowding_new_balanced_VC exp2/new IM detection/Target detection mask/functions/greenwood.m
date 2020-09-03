function cf = greenwood(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
A=165;
a=2.1;
k=0.88;
cf=A*(10^(a*(x/35))-k);
end

