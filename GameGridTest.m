clear all; clc;
g=GameGrid();
g.setCoins(10);
g.populateRandomly();
g.setMutate(true);
g.setGenerations(100);
g.run();

%%
implay(g.movie,10)

%%
clc;clf
strategies = reshape(g.strategyGrid,[],g.nCoins+1);

subplot(1,2,1)
plot(0:g.nCoins,strategies,'*')
axis([-0.5, g.nCoins+0.5, -inf, inf])

subplot(1,2,2)
hold on
bar(0:g.nCoins,mean(strategies))
errorbar(0:g.nCoins,mean(strategies),std(strategies),'.','LineWidth',2)
xticks(0:g.nCoins)