clear all
close all

addpath('../helperfunctions');


datasets = {
    'Clarke2013', ...
    'Einhauser2008', ...
    'Tatler2005', ...
    'Tatler2007freeview', ...
    'Tatler2007search', ...
    'Judd2009',...
     'Yun2013SUN',...
     'Yun2013PASCAL' }
%     'Asher2014', ... 
%    

for (d = datasets)
    d
    fix = grabFixations(d{1});
    saccs1 = convertFixToSacc(fix);
    figure
    
    dlmwrite(['../flow/saccs/' d{1} 'saccs.txt'], saccs1);
    
    fixF = fix;
    fixF.x = -fixF.x;
    saccs2 = convertFixToSacc(fixF);
    fixF = fix;
    fixF.y = -fixF.y;
    saccs3 = convertFixToSacc(fixF);
    fixF = fix;
    fixF.x = -fixF.x;
    fixF.y = -fixF.y;
    saccs4 = convertFixToSacc(fixF);
    saccs = [saccs1; saccs2;saccs3;saccs4];
    dlmwrite(['saccs/' d{1} 'saccsMirrored.txt'], saccs);
    
    plot(saccs(:,3), saccs(:,4), '.')
    
end


