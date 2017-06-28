close all
clear all


load 120Set/set120
load Ex1_AllResults

F = [];
for t = 1:120
    for s = 1:25
        trial = Ex1CollectedResults(s).TrialOrder(t).SaccadeList;
        X = [trial.XPos]' - (Ex1CollectedResults(s).ScreenWidth-Ex1CollectedResults(s).SceneWidth)/2; 
        Y = [trial.YPos]' - (Ex1CollectedResults(s).ScreenHeight-Ex1CollectedResults(s).SceneHeight)/2;
        F = [F; repmat([s], [length(X) 1]), [1:length(X)]' X, Y];
    end
end

dlmwrite('asherFixations.txt', F);