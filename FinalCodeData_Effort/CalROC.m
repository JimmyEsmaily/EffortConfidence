clc;
clear;
close all;
%%
load ('./psych_data.mat')

badsub=[]; % more than 15% of rejected trials

AllData = psych_data;
AllData(:,:,badsub) = [];
TCohs = [3.2, 6.4, 12.8, 25.6 51.2]/100;
NewData = [];
for i=1:size(AllData,3)
    NewData = [NewData; [squeeze(AllData(:,:,i)), i*ones(size(AllData,1),1)]];
    
end
NewData(isnan(NewData(:,1)),:) = [];
NewData(:,3) = NewData(:,3)/7;
NewData(:,4) = NewData(:,4)/1000;



ConfLevels = [0 ;unique(NewData(:,3))];
% For Direction Positive is 1 negative is 0
NumForce = unique(NewData(:,end-1));
for si=1:size(AllData,3) % Subs
    SubData = NewData(NewData(:,end)== si,:);
    for j=1:length(NumForce)
%         return
        TmpNewData = SubData(SubData(:,end-1)==NumForce(j),:);
        TmpConf = TmpNewData(:,3);
        TmpDir = sign(TmpNewData(:,1));
        TmpDir(TmpDir==-1) = 0;
        ACC = TmpNewData(:,2) == TmpDir;
        cBins = find(ACC==1);
        eBins = find(ACC==0);
        totalCorrect = length(cBins);
        totalIncorrect = length(eBins);
        ConfCorrect = TmpConf(cBins);
        ConfIncorrect = TmpConf(eBins);
        for ci = 1:length(ConfLevels)
            Hits(si,j,ci)=sum(ConfCorrect  >= ConfLevels(ci))./ totalCorrect;        %hits: high confidence in correct trials
            FAs(si,j,ci)=sum(ConfIncorrect >= ConfLevels(ci))./ totalIncorrect;       %false alarm: high confidence in incorrect trials
%             plot(FAs(si,j,ci), Hits(si,j,ci),'k.', 'MarkerSize',20)

        end
        Hits(si,j,ci+1)=0; %hits: high confidence in correct trials
        FAs(si,j,ci+1)=0;
        Surfs(si,j) = -trapz(squeeze(FAs(si,j,:)), squeeze(Hits(si,j,:)));
%         Diff(si,j,:) = ACC(si,j,:) - Conf(si,j,:);
    end
end

Color = ['r', 'b'];
figure, hold on
for i=1:length(NumForce)
    P1{i} = plot(squeeze(mean(FAs(:,i,:),1)),...
        squeeze(mean(Hits(:,i,:),1)),[Color(i),'.-'],'MarkerSize',25,'LineWidth',2);
    MyErrorBar(squeeze(mean(FAs(:,i,:),1)),...
        squeeze(mean(Hits(:,i,:),1)), squeeze(std(Hits(:,i,:),1))/ sqrt(size(Hits, 1)),...
        Color(i));
    MyErrorBar_H(squeeze(mean(FAs(:,i,:),1)),...
        squeeze(mean(Hits(:,i,:),1)), squeeze(std(FAs(:,i,:),1))/ sqrt(size(FAs, 1)),...
        Color(i));
end
xBin = linspace(0, 1, 100);
plot(xBin, xBin, 'k--', 'LineWidth', 1)
SetPlot_ROC
xlabel('False Alarms');
ylabel('Hits');


figure, hold on
[~,res,tt,stats025] = ttest(Surfs(:,1)',Surfs(:,2)')


for i=1:length(NumForce)
    I = bar(i, mean(Surfs(:,i)),.4);
    I.FaceColor = 'w';
    I.EdgeColor = Color(i);
    I.LineWidth = 2;
end
for si=1:size(AllData,3)
    P = plot([1,2],[Surfs(si,1), Surfs(si,2)],'k-','LineWidth',2);
    P.Color(4)=0.2;
    plot(1,Surfs(si,1),'r.','MarkerSize',20);
    plot(2,Surfs(si,2),'b.','MarkerSize',20);
    
end
ylim([.5, 1])
set(gcf,'Color','w');
xlabel('Force')
ylabel('ROC');
xtick = [1:2];
xticklabe={'0 N','6 N'};
set(gca,'XTick',xtick,'XTickLabel',xticklabe,'FontSize',12);
legend boxoff;
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
figure(1)
legend([P1{1} P1{2}],'Force 0','Force 6')
legend boxoff


%%


