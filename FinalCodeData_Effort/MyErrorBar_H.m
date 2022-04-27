function MyErrorBar_H(X,Y,Error,ColorCode,Tikness)
if nargin<5
    Tikness=1;
end
for i=1:length(X)
    plot([(X(i)-Error(i)),(X(i)+Error(i))], [Y(i),Y(i)],...
        'Color',ColorCode,'LineWidth',Tikness)
end
end

% errorbar(1:i,LowConf,SEMConfLow,'r-','LineWidth',2);