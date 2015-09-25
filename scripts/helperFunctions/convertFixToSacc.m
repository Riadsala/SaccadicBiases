function saccs = convertFixToSacc(fix, aspectRatio)

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
    
    %     remove missing data
    saccs(isnan(saccs(:,r)),:) = [];
end
saccs(saccs(:,2)<= -1,:) = [];
saccs(saccs(:,2)>=  1,:) = [];
saccs(saccs(:,4)<= -1,:) = [];
saccs(saccs(:,4)>=  1,:) = [];
saccs(saccs(:,3)<= -aspectRatio,:) = [];
saccs(saccs(:,3)>=  aspectRatio,:) = [];
saccs(saccs(:,5)<= -aspectRatio,:) = [];
saccs(saccs(:,5)>=  aspectRatio,:) = [];