clear all
close all

addpath('../helperfunctions');


datasets = {'Clarke2013', 'Einhauser2008'}

for (d = datasets)
    fix = grabFixations(d{1});
saccs1 = convertFixToSacc(fix);
dlmwrite(['saccs/' d{1} 'saccs.txt'], saccs1);

fixF = fix;
fixF.x = -fixF.x;
saccs2 = convertFixToSacc(fixF);
fixF = fix;
fixF.x = -fixF.y;
saccs3 = convertFixToSacc(fixF);
fixF = fix;
fixF.x = -fixF.x;
fixF.x = -fixF.y;
saccs4 = convertFixToSacc(fixF);
dlmwrite(['saccs/' d{1} 'saccsMirrored.txt'], [saccs1; saccs2;saccs3;saccs4]);
end


