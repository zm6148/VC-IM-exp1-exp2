load census
plot(cdate,pop,'o')
hold on

s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0],...
               'Upper',[Inf,max(cdate)],...
               'Startpoint',[1 1]);
		   
f = fittype('a*(x-b)^n','problem','n','options',s);

[c2,gof2] = fit(cdate,pop,f,'problem',2);

plot(c2,'m');
