function P = MyWeibull(Means, ACC_SEM, Color)
%% 1- 1/2e-(c/a)^b
% figure;
coh = [3.2 6.4 12.8 25.6 51.2];
coh=log(coh)/log(2);
modelFun =  @(p,x) 1- 1/2*(exp(-(x./p(1)).^p(2)));
startingVals = [4 3];
coefEsts = nlinfit(coh(1:5), Means, modelFun, startingVals);
% xgrid = linspace(1.6,10,100);
xgrid = linspace(1.6,10,100);


plot(xgrid,modelFun(coefEsts, xgrid),[Color,'-'],'LineWidth',2);
P = plot(coh, Means, [Color,'.'],'MarkerSize',25,'LineWidth',2);
MyErrorBar(coh,Means,ACC_SEM,Color);
ZeroCor = .6781;
Bin = [ZeroCor-.15,ZeroCor+.15];
xlim([0.8 max(coh)+0.2]);
ylim([0.41 1]);
xtick=[coh];
set(gca,'xtick',xtick);
xticklabel={'3.2%';'';'12.8%';'';'51.2%'};
set(gca,'xticklabel',xticklabel,'FontSize',12);
ylabel('Probability Correct','FontSize',12);
xlabel('Stimulus Strength (%Coh)','FontSize',12);
set(gca,'Box','off');
set(gcf,'color','w');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
end

%%