function saccs = convertFixToSacc(fix)

%% convert fixations to saccades
saccs = [];
P = unique(fix.person);
T = unique(fix.trial);
for p = 1:length(P)
    for t = 1:length(T)
        idx = find((fix.person==P(p)).*(fix.trial==T(t)));
        if length(idx)>1
            
            tfix = [fix.x(idx), fix.y(idx)];
            
            for f = 2:length(tfix)
                saccs = [ saccs;  f-1, tfix(f-1,:), tfix(f,:)];
            end
            clear tfix
        end
    end
end

for r  = 2:5
    saccs(saccs(:,r)<= -1,:) = [];
    saccs(saccs(:,r)>=  1,:) = [];
    %     remove missing data
    saccs(isnan(saccs(:,r)),:) = [];
end
