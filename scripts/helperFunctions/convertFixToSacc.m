function saccs = convertFixToSacc(fix)

%% convert fixations to saccades
saccs = [];
P = unique(fix(:,1));
T = unique(fix(:,2));
for p = 1:length(P)
    for t = 1:length(T)
        tfix = fix(find((fix(:,1)==P(p)).*(fix(:,2)==T(t))),:);
        for f = 3:length(tfix)
           saccs = [saccs;  tfix(f-1,4:5), tfix(f,4:5)];
        end
        clear tfix
    end
end
