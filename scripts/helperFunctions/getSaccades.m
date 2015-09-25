clear all
close all

addpath('../helperfunctions');


datasets = {
    'Asher2013',...
    'Clarke2013', ...
    'Einhauser2008', ...
    'Tatler2005', ...
    'Tatler2007freeview', ...
    'Tatler2007search', ...
    'Judd2009',...
    'Yun2013SUN',...
    'Yun2013PASCAL',...
    'Clarke2009'}



for (d = datasets)
    d
    if strcmp(d, 'Asher2013')
        aspectRatio=0.8;
    else
        aspectRatio=0.75;
    end
        
    fix = grabFixations(d{1});
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


