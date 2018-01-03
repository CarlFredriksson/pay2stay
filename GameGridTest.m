clear all; clc;
g=GameGrid2();
g.nCoins = 10;
g.payoffType = 'simple';
g.eliminationType = 'full';
g.populateRandomly();
%g.populateCustom([0.5 0.3 0.2 0 0 0 0 0 0 0 0])
%g.populateUniformly()
g.shouldMutate = true;
g.run(100);
g.shouldMutate = false;
g.run(100);



%%
implay(g.movie,10)

%%
clc;clf
strategies = reshape(g.strategyGrid,[],g.nCoins+1);
 
subplot(1,2,1)
plot(0:g.nCoins,strategies,'*')
axis([-0.5, g.nCoins+0.5, -inf, inf])
xlabel('Coins')
ylabel('Probability')
title('All strategies')

subplot(1,2,2)
hold on
bar(0:g.nCoins,mean(strategies))
errorbar(0:g.nCoins,mean(strategies),std(strategies),'.','LineWidth',2)
xticks(0:g.nCoins)
xlabel('Coins')
ylabel('Probability')
title('Mean strategy')


