function AnalyseGazeMaps

clear all
close all

load ImageData
load Sequences
t = 1;

gazeLandscape = rand([600,800]);
nLabels = length(Trial(t).labels.name);
labelAttScores = zeros(nLabels,1);
% for each label, get list of polygons associated with it
for ii = 1:nLabels
    labelObjects = Trial(t).labels.polyIDs{ii};
    % for each associated polygon, get a mask
    labelMask = zeros(600,800);
    for jj = labelObjects
        poly = Trial(t).objects.obj(jj).points;
        mask = poly2mask(poly(:,1), poly(:,2), 600, 800);
        labelMask = max(labelMask, mask);
    end
    labelAttScores(ii) = max(gazeLandscape(labelMask==1));
end
labelAttScores

% get naming frequency
labelNamingScores = zeros(nLabels,1);
for pp = 1:24
    namedObjs = SeqID(t,pp).lab;
    labelNamingScores(namedObjs) = labelNamingScores(namedObjs) + 1;
end
labelNamingScores   
end
