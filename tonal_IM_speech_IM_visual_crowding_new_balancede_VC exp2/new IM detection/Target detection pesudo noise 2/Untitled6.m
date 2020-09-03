%% noise and tonal mask compare
clear;
close all;


%% x_n
t_cf = 1000;

x1 = (t_cf*(2^(0.15)-2^(-0.15))/2)/t_cf; %0.3
x2 = (t_cf*(2^(0.25)-2^(-0.25))/2)/t_cf; %0.5
x3 = (t_cf*(2^(0.5)-2^(-0.5))/2)/t_cf;   %1
x4 = (t_cf*(2^(0.75)-2^(-0.75))/2)/t_cf;       %2

x_n= [x1, x2, x3, x4];


% %% x_t
% t_cf = 1000;
% 
% x1 = (1000-1000*2^(-0.3))/1000; %0.3
% x2 = (1000-1000*2^(-0.5))/1000; %0.5
% x3 = (1000-1000*2^(-1))/1000;   %1
% x4 = (1000-1000*2^(-2))/1000;   %2
% 
% x_t= [x1, x2, x3, x4];

%% pelin

name = 'min';
y_t1 = 48;
y_t2 = 45;
y_t3 = 30;
y_t4 = 17;
y_t = [y_t1, y_t2, y_t3, y_t4];

% 1000
       %29%23%19%18%17%16 % 15
y_n1 = 54; 50;%54;%53;%50;%49;%53;
y_n2 = 48;%49;%46;%42;%42;%46;
y_n3 = 30;%28;%30;%22;%25;%30;
y_n4 = 21;%23;%14;%16;%12;%17;
y_n = [y_n1, y_n2, y_n3, y_n4];

% 2000
       %24%19%18%17%16 % 15
% y_n1 = 50;%54;%53;%50;%49;%53;
% y_n2 = 48;%49;%46;%42;%42;%46;
% y_n3 = 33;%28;%30;%22;%25;%30;
% y_n4 = 23;%23;%14;%16;%12;%17;
% y_n = [y_n1, y_n2, y_n3, y_n4];

% 500
       
% y_n1 = 50;%54;%53;%50;%49;%53;
% y_n2 = 44;%49;%46;%42;%42;%46;
% y_n3 = 31;%28;%30;%22;%25;%30;
% y_n4 = 21;%23;%14;%16;%12;%17;
% y_n = [y_n1, y_n2, y_n3, y_n4];

%% plot

hold on;
%plot(x_t, y_t,'or');
plot(x_n, y_n,'ob');
xlabel('\Delta f / f0');
ylabel('Target threshold (dB SPL)');
legend('notched noise');
title(name);

