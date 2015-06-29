function fix = grabFixations2(dataset)

% Should return a data structure called fix with the following fields:
% fix.person = person id number
% fix.trial = tiral id number
% fix.x, fix.y = fixation coordinates relative to [-1,1]x[-a,a] where
%     a is the aspect ration (ie, usually 0.75]

% as we are interested in calculating saccades (done later) we should not
% remove NAs, out of bound fixations, etc, as this will result in false
% saccades being calcualted.

% also, intitla fixation is NOT removed at this stage.

% datasets to use:
% Einhauser2008

% % datasets no logner being used:
% clarke2009 (square, noise, hard search, so not so useful for this type of analysis)
%     ehringer2009 (pedestrian street scenes, Clarke & Tatler 2014 showed this dataset doesn't follow the others


if iscell(dataset)
    dataset = dataset{1};
end
switch dataset
    
    case 'Einhauser2008'
        
        R = dlmread('../../data/Einhauser2008/fixations.txt');
        R(:,4:5) = centreAndScale(R(:, 4:5),[1024, 768]);
        fix = fixArrayToStruct(R, 1,2, 4,5);
        fix = setOutBoundsToNA(fix, 768/1024);
        
    case 'Tatler2005'
        
        R = dlmread('../../data/Tatler/Tatler2005.txt');
        R(:,6:7) = centreAndScale(R(:, 6:7),[800,600]);
        fix = fixArrayToStruct(R, 1,2,6,7);
        
    case 'Tatler2007freeview'
        
        R = dlmread('../../data/Tatler/Tatler2007freeview.txt');
        R(:,6:7) = centreAndScale(R(:, 6:7),[1600,1200]);
        fix = fixArrayToStruct(R, 1,2,6,7);
        
    case 'Tatler2007search'
        
        R = dlmread('../../data/Tatler/Tatler2007search_TA.txt');
        R(:,6:7) = centreAndScale(R(:, 6:7),[1600,1200]);
        fix = fixArrayToStruct(R, 1,2,6,7);

    case 'Clarke2013'
        
        R = dlmread('../../data/Clarke2013/ProcessedFixations.txt');
        R(:,6:7) = centreAndScale(R(:, 6:7),[800,600]);
        fix = fixArrayToStruct(R, 1,2,6,7);
        
    case 'Asher2013'
        
        % Scene ID,Participant ID,Fixation ID,Fix X,Fix Y,Target Present,Response
        R = dlmread('../../data/Asher2013/MFA_FixationDataNOV_2013.csv');
        R(:,4:5) = centreAndScale(R(:, 4:6),[1280,1024]);
        fix = fixArrayToStruct(R, 1,2,4,5);
        
    case 'Judd2009'
        
        R = dlmread('../../data/Judd2009/DatabaseCode/juddFixData_TrialSubjFixNXY.txt');
        % get fixations from most common aspect ratio only
        idx = find(~((R(:,6)==1024).*(R(:,7)==768)));
        size(idx)
        R(idx,:) = [];
        R(:,6:7) = centreAndScale(R(:, 6:7),[1024, 768]);        
        fix = fixArrayToStrut(R, 2,1,6,7);
        
    case 'Yun2013SUN'
        
        R = dlmread('../../data/SBUGazeDetectionDescriptionDataset/sun09fixations.txt');
        % get fixations from most common aspect ratio only
        idx = find(~((R(:,6)==1280).*(R(:,7)==960)));
        R(idx,:) = [];
         R(:,6:7) = centreAndScale(R(:, 6:7),[1280, 960]);    
        fix = fixArrayToStrut(R, 2,1,6,7);
        
    case 'Yun2013PASCAL'
        
        R = dlmread('../../data/SBUGazeDetectionDescriptionDataset/pascalfixations.txt')        
        % get fixations from most common aspect ratio only
        idx = find(~((R(:,6)==500).*(R(:,7)==333)));
        R(idx,:) = [];
        R(:,6:7) = centreAndScale(R(:, 6:7),[500, 333]);    
        fix = fixArrayToStrut(R, 2,1,6,7);
end

end

function fix = setOutBoundsToNA(fix, ap)
fix.x(fix.x <=-1) = NaN;
fix.y(fix.x <=-1) = NaN;

fix.x(fix.x >= 1) = NaN;
fix.y(fix.x >= 1) = NaN;

fix.x(fix.y <=-ap) = NaN;
fix.y(fix.y <=-ap) = NaN;

fix.x(fix.x >= ap) = NaN;
fix.y(fix.x >= ap) = NaN;

end



function out = centreAndScale(in, asprat)
% centre of image should = [0,0], and transform to a square of width 2
%  but due to images generally being 3x2, we end up with
% [-1,1]x[-0.75,0.75]
z = asprat/2;
out(:,1) = (in(:,1)-z(1))/z(1);
out(:,2) = (in(:,2)-z(2))/z(1); % note this should be z(1), as we are NOT normalising to (-1,1)x(-1,1).
end

function fix = fixArrayToStruct(R, a,b,d,c)
fix.person = R(:,a);
fix.trial = R(:,b);
fix.y = R(:,c);
fix.x = R(:,d);
end