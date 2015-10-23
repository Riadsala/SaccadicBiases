clear all
close all

addpath('../helperfunctions');

%
% datasets = {
%     'Asher2013',...
%     'Clarke2013', ...
%     'Einhauser2008', ...
%     'Tatler2005', ...
%     'Tatler2007freeview', ...
%     'Tatler2007search', ...
%     'Judd2009',...
%     'Yun2013SUN',...
%     'Yun2013PASCAL',...
%     'Clarke2009', ...
%     'Ehinger2007'.}

%  datasets = {'Borji2015'};

datasets = {'Jiang2014'};


for (d = datasets)
    d
    if strcmp(d, 'Asher2013')
        aspectRatio=0.8;
    elseif strcmp(d, 'Borji2015')
        aspectRatio = 0.5625;
    else
        aspectRatio=0.75;
    end
    
    % import fixations
    fix = grabFixations(d{1});
    
    if strcmp(d, 'Borji2015')
        % This is a multi class dataset
        % get class names
         sets = dir('../../data/Borji2015/*.txt');
        for cls = 1:length(fix)
            classname = regexp(sets(cls).name, '[\w]*(?=Fix)', 'match')
            saccs1 = convertFixToSacc(fix(cls), aspectRatio);
            
            dlmwrite(['../../data/saccs/' d{1} '_' classname{1} 'saccs.txt'], saccs1);
            clear saccs1
        end
        
    else
        
        
        saccs1 = convertFixToSacc(fix, aspectRatio);        
        dlmwrite(['../../data/saccs/' d{1} 'saccs.txt'], saccs1);     
        fixF = fix;
        fixF.x = -fixF.x;
        saccs2 = convertFixToSacc(fixF, aspectRatio);
        fixF = fix;
        fixF.y = -fixF.y;
        saccs3 = convertFixToSacc(fixF, aspectRatio);
        fixF = fix;
        fixF.x = -fixF.x;
        fixF.y = -fixF.y;
        saccs4 = convertFixToSacc(fixF, aspectRatio);
        saccs = [saccs1; saccs2;saccs3;saccs4];
        dlmwrite(['../../data/saccs/' d{1} 'saccsMirrored.txt'], saccs);
    end
    
    
end


