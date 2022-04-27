set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Stimulus Strength (%coh)')
% ylabel('Confidence');
% lg = legend([P{1} P{2}],'Social','Isolated');
% lg.FontSize=12;
xtick = [1:5];
xticklabe={'3.2%','','12.8%','','51.2%'};
set(gca,'XTick',xtick,'XTickLabel',xticklabe,'FontSize',12);
legend boxoff;
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
xlim([0 5.5]);