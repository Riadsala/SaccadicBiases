function [R trs] = grabFixations2(dataset)

% want to return
% [subject - nFix - fixX - fixY]
trs = [];
switch dataset
    case 'Ehinger2009TA'
        R = dlmread('../../data/Ehinger2007/ehinger2007fixationsTA.txt');
        imX = 800;
        imY = 600;
        % remove NaNs
        R(isnan(R(:,4)),:) = [];
        R(isnan(R(:,5)),:) = [];
        R(R(:,4)<0,:) = [];
        R(R(:,5)<0,:) = [];
        R(R(:,4)>imX,:) = [];
        R(R(:,5)>imY,:) = [];
        
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,4) = (R(:,4) - imX/2)/(imX/2);
        R(:,5) = (R(:,5) - (imY/2))/(imX/2);
        trs = R(:,1);
        R(:,1) = [];
        
    case 'Ehinger2009TP'
        R = dlmread('../../data/Ehinger2007/ehinger2007fixationsTP.txt');
        
        imX = 800;
        imY = 600;
        % remove NaNs
        R(isnan(R(:,4)),:) = [];
        R(isnan(R(:,5)),:) = [];
        R(R(:,4)<0,:) = [];
        R(R(:,5)<0,:) = [];
        R(R(:,4)>imX,:) = [];
        R(R(:,5)>imY,:) = [];
        
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,4) = (R(:,4) - imX/2)/(imX/2);
        R(:,5) = (R(:,5) - (imY/2))/(imX/2);
        trs = R(:,1);
        R(:,1) = [];
        
    case 'Einhauser2008'
        R = dlmread('../../data/Einhauser2008/fixations.txt');
        % remove NaNs
        R(isnan(R(:,4)),:) = [];
        R(isnan(R(:,5)),:) = [];
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,4) = (R(:,4) - 1024/2)/512;
        R(:,5) = (R(:,5) - 768/2)/512;
        % remove trial, onset and offset info
        trs = R(:,1);
        R(:,1) = [];
    case 'Tatler2005'
        R = dlmread('../../data/Tatler/Tatler2005.txt');
        
        % remove NaNs
        R(isnan(R(:,6)),:) = [];
        R(isnan(R(:,7)),:) = [];
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,6) = (R(:,6) - 400)/400;
        R(:,7) = (R(:,7) - 300)/400;
        % remove trial, onset and offset info
        trs = R(:,2);
        R(:,[2  4 5]) = [];
    case 'Tatler2007freeview'
        R = dlmread('../../data/Tatler/Tatler2007freeview.txt');
        
        % remove NaNs
        R(isnan(R(:,6)),:) = [];
        R(isnan(R(:,7)),:) = [];
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,6) = (R(:,6) - 800)/800;
        R(:,7) = (R(:,7) - 600)/800;
        % remove trial, onset and offset info
        trs = R(:,2);
        R(:,[2  4 5]) = [];
    case 'Tatler2007searchTA'
        R = dlmread('../../data/Tatler/Tatler2007search_TA.txt');
        
        % remove NaNs
        R(isnan(R(:,6)),:) = [];
        R(isnan(R(:,7)),:) = [];
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,6) = (R(:,6) - 800)/800;
        R(:,7) = (R(:,7) - 600)/800;
        % remove trial, onset and offset info
         trs = R(:,2);
        R(:,[2  4 5]) = [];
     case 'Tatler2007searchTP'
        R = dlmread('../../data/Tatler/Tatler2007search_TP.txt');
        
        % remove NaNs
        R(isnan(R(:,6)),:) = [];
        R(isnan(R(:,7)),:) = [];
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,6) = (R(:,6) - 800)/800;
        R(:,7) = (R(:,7) - 600)/800;
        % remove trial, onset and offset info
        trs = R(:,2);
        R(:,[2  4 5]) = [];
    case 'Clarke2013'
        R = dlmread('../../data/Clarke2013/ProcessedFixations.txt');
        
        % remove NaNs
        R(isnan(R(:,6)),:) = [];
        R(isnan(R(:,7)),:) = [];
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,6) = (R(:,6) - 400)/400;
        R(:,7) = (R(:,7) - 300)/400;
        % remove trial, onset and offset info
        trs = R(:,2);
        R(:,[4 5]) = [];
        R(:,1:2) = R(:,2:-1:1);
    case 'Clarke2009'
        R = dlmread('../../data/Clarke2009/clarke2009Fixations.txt');
        R(:,2) = [];
        R(:,3) = (R(:,3)-512)/512;
        R(:,4) = (R(:,4)-512)/512;
        R(:,3:4) = R(:,4:-1:3);
        R(R(:,3)<-1,:)=[];
        R(R(:,4)<-1,:)=[];
        R(R(:,3)>1,:)=[];
        R(R(:,4)>1,:)=[];
    case 'Asher2013TP'
        % Scene ID,Participant ID,Fixation ID,Fix X,Fix Y,Target Present,Response
        R = dlmread('../../data/Asher2013/MFA_FixationDataNOV_2013.csv');        
      R(R(:,6)==0,:) = [];
      trs = R(:,1);
        R(:,1) = [];
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,3) = (R(:,3) - 640)/640;
        R(:,4) = (R(:,4) - 512)/640;
  case 'Asher2013TA'
        % Scene ID,Participant ID,Fixation ID,Fix X,Fix Y,Target Present,Response
        R = dlmread('../../data/Asher2013/MFA_FixationDataNOV_2013.csv');        
      R(R(:,6)==1,:) = [];
      trs = R(:,1);
    
        % centre of image should = [0,0], and transform to a square of width 2
        R(:,4) = (R(:,4) - 640)/640;
        R(:,5) = (R(:,5) - 512)/640;
        
    case 'Judd2009'
        R = dlmread('../../data/Judd2009/DatabaseCode/juddFixData_TrialSubjFixNXY.txt');
        % remove NaNs
        R(R(:,4)<(-R(:,6)/2),:) = [];
        R(R(:,5)<(-R(:,7)/2),:) = [];
        R(R(:,4)>(R(:,6)/2),:) = [];
        R(R(:,5)>(R(:,7)/2),:) = [];
        
        R(isnan(R(:,4)),:) = [];
        R(isnan(R(:,5)),:) = [];
        
        % centre of image should = [0,0], and transform to a square of width 2
        
        % get fixations from most common aspect ratio only
        idx = find(~((R(:,6)==1024).*(R(:,7)==768)));
        R(idx,:) = [];
        R(:,4) = R(:,4)/512;
        R(:,5) = R(:,5)/512;
        trs = R(:,1);
        R(:,[6 7]) = [];
        
    case 'Yun2013SUN'
        R = dlmread('../../data/SBUGazeDetectionDescriptionDataset/sun09fixations.txt');
        % remove NaNs
        R(R(:,4)<0,:) = [];
        R(R(:,5)<0,:) = [];
        R(R(:,4)>(R(:,6)),:) = [];
        R(R(:,5)>(R(:,7)),:) = [];
        
        R(isnan(R(:,4)),:) = [];
        R(isnan(R(:,5)),:) = [];
        
        % centre of image should = [0,0], and transform to a square of width 2
        
        % get fixations from most common aspect ratio only
        idx = find(~((R(:,6)==1280).*(R(:,7)==960)));
        R(idx,:) = [];
        R(:,4) = (R(:,4)-640)/640;
        R(:,5) = (R(:,5)-480)/640;
        trs = R(:,1);
        R(:,[6 7]) = [];
        
    case 'Yun2013PASCAL'
        R = dlmread('../../data/SBUGazeDetectionDescriptionDataset/pascalfixations.txt');
        % remove NaNs
        R(R(:,4)<0,:) = [];
        R(R(:,5)<0,:) = [];
        R(R(:,4)>(R(:,6)),:) = [];
        R(R(:,5)>(R(:,7)),:) = [];
        
        R(isnan(R(:,4)),:) = [];
        R(isnan(R(:,5)),:) = [];
        
        % centre of image should = [0,0], and transform to a square of width 2
        
        % get fixations from most common aspect ratio only
        idx = find(~((R(:,6)==500).*(R(:,7)==333)));

        R(idx,:) = [];
        R(:,4) = (R(:,4)-250)/250;
        R(:,5) = (R(:,5)-167)/250;
        trs = R(:,1);
        R(:,[6 7]) = [];
end

% remove initial fixation
if ~isempty(trs)
trs(R(:,3)==1,:) = [];
end
R(R(:,3)==1,:) = [];