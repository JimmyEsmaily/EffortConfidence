clc;
clear;
close all;
%%
load psych_data.mat

%%
badsub=[]; % more than 15% of rejected trials

AllData = psych_data;
AllData(:,:,badsub) = [];
TCohs = [3.2, 6.4, 12.8, 25.6 51.2]/100;
NewData = [];
for i=1:size(AllData,3)
    NewData = [NewData; [squeeze(AllData(:,:,i)), i*ones(size(AllData,1),1)]];
    
end
NewData(isnan(NewData(:,1)),:) = [];
NewData(:,3) = NewData(:,3)/7;  % Conf
NewData(:,4) = NewData(:,4)/1000; % Rt

% For Direction Positive is 1 negative is 0
NumForce = unique(NewData(:,end-1));
for j=1:length(NumForce)
    TmpNewData = NewData(NewData(:,end-1)==NumForce(j),:);
    for i=1:length(TCohs) % One Cohs
        TmpData = TmpNewData(abs(TmpNewData(:,1)) == TCohs(i), :);
        tmpNumTr = length(find(abs(TmpNewData(:,1)) == TCohs(i)));
        TmpDir = sign(TmpData(:,1));
        TmpDir(TmpDir==-1) = 0;
        ACC(j,i) = mean(TmpData(:,2) == TmpDir);
        ACC_SEM(j,i) = std(TmpData(:,2) == TmpDir)/sqrt(tmpNumTr);
        Conf(j,i) = mean(TmpData(:,3));
        Conf_SEM(j,i) = std(TmpData(:,3))/sqrt(tmpNumTr);
        RT(j,i) = mean(TmpData(:,4));
        RT_SEM(j,i) = std(TmpData(:,4))/sqrt(tmpNumTr);
        
        
    end
end
figure(1), hold on;
figure(2), hold on;
figure(3), hold on;

Color = ['r', 'b'];
for i=1:length(NumForce)
    figure(1)
    P1{i} = plot(1:length(TCohs), Conf(i,:), [Color(i),'.-'],'MarkerSize',25,'LineWidth',2);
    MyErrorBar(1:length(TCohs),Conf(i,:),Conf_SEM(i,:),Color(i));
    ylabel('Confidence (a.u.)');
    SetPlot
    figure(2)
    P2{i} = plot(1:length(TCohs), RT(i,:), [Color(i),'.-'],'MarkerSize',25,'LineWidth',2);
    MyErrorBar(1:length(TCohs),RT(i,:),RT_SEM(i,:),Color(i));
    ylabel('RT (s)');
    SetPlot
    figure(3)
    P3{i}=MyWeibull(ACC(i,:),ACC_SEM,Color(i));
    ylabel('Accuracy(%)');
end


figure(1)
legend([P3{1} P3{2}],'Force 0','Force 6')
legend boxoff
figure(2)
legend boxoff
figure(3)
legend boxoff
ylim([.5 1+eps])




%% Test
TmpDir = sign(NewData(:,1));
TmpDir(TmpDir==-1) = 0;
Acctest = NewData(:,2) == TmpDir;
Cohtest = abs(NewData(:,1));
RTtest = NewData(:,4);
Conftest = round(NewData(:,3)*7)-1;
Condition = NewData(:,end-1);
Subs = NewData(:,end);

MyTable = table(Subs,Cohtest,Acctest,Condition);
glme = fitglme(MyTable,...
		'Acctest ~ 1 + Condition + Cohtest + (1|Subs)',...
		'Distribution','Poisson', 'link','log');
Res_ACC = [glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)];
% RT
MyTable = table(Subs,Cohtest,RTtest,Condition);
glme = fitglme(MyTable,...
		'RTtest ~ 1 + Condition + Cohtest + (1|Subs)',...
		'Distribution','gamma','Link', -1);
Res_RT = [glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)];
% Conf
MyTable = table(Subs,Cohtest,Conftest,Condition);
glme = fitglme(MyTable,...
		'Conftest ~ 1 + Condition + Cohtest + (1|Subs)',...
		'Distribution','Poisson', 'link','log')
Res_Conf = [glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)];


