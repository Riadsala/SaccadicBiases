%%  reads in Annotations and processes them.
%   Uses LabelFreq.txt as the master label list

close all
clear all

folder = '/afs/inf.ed.ac.uk/group/synproc/Alasdair/NamingExperiment/';

% load in naming data, not including mistakes
fid = fopen([folder 'results/NamingData/LabelData/LabelFreq.txt']);
T = textscan(fid, '%d%q%d', 'headerlines', 1);
filenums   = T{1};
labels      = regexprep(T{2}, ' ', '');
freq        = T{3};
fclose(fid);
clear fid T

% get list of annotations and images
annotations = dir([folder 'annotations/*.xml']);
images = dir([folder 'stimuli/images/*.jpg']);

%% now parse annotation data. We will be saving everything into Trial
Trial = struct('objects',{}, 'labels',[]);
numberNoMatchPolygonLabels = 0;

% add in xml toolbox, available from http://www.mathworks.co.uk/matlabcentral/fileexchange/4278-xml-toolbox
addpath('/afs/inf.ed.ac.uk/user/a/aclark11/Documents/MATLAB/My Toolboxes/xml_toolbox');
for t = 1:length(images)
    Trial(t).imageName = images(t).name(1:(end-4));
    
    anno = xml_load([folder 'stimuli/annotations/' Trial(t).imageName '.xml']);
    
    objCtr = 0;
    z=0;
    for o = 1:length(anno)
        % if polygon isn't marked as deleted in annotation file
        if strcmp(anno(o).object.deleted, '0')
            % extract name from anno and parse a little
            name = char(regexp(anno(o).object.name, '[ \w-'']*', 'match'));
            name = regexprep(name, ' ', '');
            name = regexprep(name, '''', '');
            
            % check name is in list or labels!
            labelmatches = find((filenums == t) & strcmp(labels, name));
            
            if ~isempty(labelmatches)
                % if we have found a match, then save data in Trial(t).object
                objCtr = objCtr + 1;
                Trial(t).objects.name{objCtr} = name;
                
                % get polygon points
                points = zeros(size(anno(o).object.polygon, 2), 2);
                for pt = 1:size(anno(o).object.polygon,2)
                    points(pt,:)= [str2num(anno(o).object.polygon(pt).pt.x), str2num(anno(o).object.polygon(pt).pt.y)]; %#ok<ST2NM>
                end
                Trial(t).objects.obj(objCtr).points = points;
                
            else
                % Polygon's named not found in Label list
                z=z+1;
                numberNoMatchPolygonLabels = numberNoMatchPolygonLabels+1;
                Trial(t).objects.noMatch{z} = name;
            end
        end
    end %% finish stepping through annotated objects
    Trial(t).Npolygons = objCtr;
end

disp(['We failed to find labels for ' int2str(numberNoMatchPolygonLabels) ' polygons'])
save ImageData Trial
clear all

%%  Part II
%   Now go through and map labels to polygons!

load ImageData
folder = '/afs/inf.ed.ac.uk/group/synproc/Alasdair/NamingExperiment/';

% load in parent/child mapping
fid = fopen('/afs/inf.ed.ac.uk/group/synproc/Alasdair/NamingExperiment/results/NamingData/LabelData/ParentChildMap.txt');
PCmap = textscan(fid, '%q%q%q', 'headerlines', 1);
fclose(fid);
clear fid

% load in naming data, not including mistakes
fid = fopen([folder 'results/NamingData/LabelData/LabelFreq.txt']);
T = textscan(fid, '%d%q%d', 'headerlines', 1);
filenums   = T{1};
labels      = regexprep(T{2}, ' ', '');
freq        = T{3};
fclose(fid);
clear fid T

missingLabels = 0;
for t = 1:100
    % now for each object from the labels list, count occurances in image
    trialLabels = labels(filenums == t);
    PCidx = find(strcmp(PCmap{1}, [Trial(t).imageName '.jpg']));
    parentObjs = PCmap{2}(PCidx);
    childObjs  = PCmap{3}(PCidx);
    
    for c = 1:length(trialLabels)
        
        Trial(t).labels.name{c} = trialLabels{c};
        
        % count occurances and collect poly IDs for label
        Trial(t).labels.polyIDs{c} = find(strcmp(Trial(t).labels.name{c}, Trial(t).objects.name));
        
        
        % if there are child objects, also map them onto the label
        if sum(strcmp(trialLabels{c}, parentObjs))>0
            children = regexp(childObjs(strcmp(trialLabels{c}, parentObjs)), '\w+', 'match');
            for child = 1:length(children{1})
                % count occurances and collect poly IDs for label
                Trial(t).labels.polyIDs{c} = ...
                    [Trial(t).labels.polyIDs{c}, find(strcmp(children{1}(child), Trial(t).objects.name))];
                
            end
        end
        Trial(t).labels.imfreq(c) = length(Trial(t).labels.polyIDs{c});
        if Trial(t).labels.imfreq(c) == 0
            missingLabels = missingLabels  + 1;
        end
    end
end
missingLabels

save ImageData Trial

clear all
