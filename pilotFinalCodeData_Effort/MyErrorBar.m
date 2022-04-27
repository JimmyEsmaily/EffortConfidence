function MyErrorBar(X,Y,Error,ColorCode,Tikness)
if nargin<5
    Tikness=1;
end
for i=1:length(X)
    plot([X(i),X(i)],[(Y(i)-Error(i)),(Y(i)+Error(i))],...
        'Color',ColorCode,'LineWidth',Tikness)
end
end

% errorbar(1:i,LowConf,SEMConfLow,'r-','LineWidth',2);