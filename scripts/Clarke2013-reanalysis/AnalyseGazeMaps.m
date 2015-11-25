function AnalyseGazeMaps
% needs edited so we output, per person, per trial:
% TrialNum, PersonNum, LabelNum, DidName?(0 or 1), max(gazelandscapes)


clear all
close all

load ImageData
load Sequences


cd ..
cd heatmaps
cd SaccadicFlowMaps
cd CSVs
trial_data=[];
for t = 1:100
    sprintf('running image %d this %d',t,100)
    
    for sizer = [50 100 200];
        i1=csvread(['image',num2str(t),'_fixmap_',num2str(sizer),'.csv'],2);
        
        
        
        gazeLandscape=imresize(i1,[600,800]);
        
        
        
        %gazeLandscape = rand([600,800]);
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
        
        trial_data.trial(t).size(sizer).labelAttScoress=labelAttScores;
        
        % get naming frequency
        labelNamingScores = zeros(nLabels,1);
        for pp = 1:24
            namedObjs = SeqID(t,pp).lab;
            labelNamingScores(namedObjs) = labelNamingScores(namedObjs) + 1;
        end
        
        trial_data.trial(t).size(sizer).labelNamingScores=labelNamingScores;
        %labelNamingScores
    end
    
end

cd ..
cd ..
cd ..
cd Clarke2013-reanalysis/
save trial_data trial_data


%%trial_data.trial(TRIAL NUMBER, 1-100).size(50, 100 and 200)