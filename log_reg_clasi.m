clc 
clear 
close all

load('smoking.mat');
Y = categorical(smoking.Smoker);
X = [smoking.Sex smoking.Age smoking.Weight...
    smoking.SystolicBP smoking.DiastolicBP];
[B,dev,stats] = mnrfit(X,Y,'model','hierarchical');

figure()
gscatter(smoking.Age,smoking.Weight,smoking.Sex)
legend('Hombre','Female')
xlabel('Age')
ylabel('Weight')