function saccs = convertFixToSacc(fix)

%% convert fixations to saccades
saccs = [];
P = unique(fix.person);
T = unique(fix.trial);
for p = 1:length(P)
    for t = 1:length(T)
        idx = find((fix.person==P(p)).*(fix.trial==T(t)));
        tfix = [fix.x(idx), fix.y(idx)];
        % calculating from fixation 3 = endpoint of second saccade as we're
        % ignoring inital fixation and first saccade.
        for f = 3:length(tfix)
            saccs = [saccs;  tfix(f-1,:), tfix(f,:)];
        end
        clear tfix
    end
end

for r  = 1:4
    saccs(saccs(:,r)<= -1,:) = [];
    saccs(saccs(:,r)>=  1,:) = [];
%     remove missing data
    saccs(isnan(saccs(:,r)),:) = [];
end
