clear all; clc;
g=GameGrid();
g.setCoins(10);
g.populateRandomly();
g.setMutate(true);
g.setGenerations(3);

N_ITERS = 1;
tic;
for i=1:N_ITERS
    g.run();
end
runningTime = toc;
fprintf('Avg running time: %f\n', runningTime/N_ITERS);

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

%% Create gif
clear all; clc;
g=GameGrid();
g.setCoins(10);
g.payoffType = 'non-linear';
g.eliminationType = 'random';
g.populateRandomly();

g.setMutate(true);
g.setGenerations(100);
g.run();

g.setMutate(false);
g.setGenerations(100);
g.run();

%%
filename = 'movie.gif';
for i = [1:75 100:125]
    [A,map] = rgb2ind(imresize(g.movie(:,:,:,i),40,'nearest'),256);
    if i == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.05);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.05);
    end
end