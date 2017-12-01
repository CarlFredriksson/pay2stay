clc
g=GameGrid(9);
g.populateRandomly();
g.run(20)

%%
implay(g.movie,2)

%%
clc
h=sum(sum(g.strategyGrid,1),2);
h=squeeze(h);
h=h./sum(h);
bar(0:length(h)-1,h)
