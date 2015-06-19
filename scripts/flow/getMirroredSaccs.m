clear all
close all

addpath('../helperfunctions');

fix = grabFixations('Clarke2013');
saccs1 = convertFixToSacc(fix);
dlmwrite('clarke2013saccs.txt', saccs1);
fixL = fix;
fixL(:,4) = -fixL(:,4);
saccs2 = convertFixToSacc(fixL);
fixU = fix;
fixU(:,5) = -fixU(:,5);
saccs3 = convertFixToSacc(fixU);
fixLU = fix;
fixLU(:,4) = -fixLU(:,4);
fixLU(:,5) = -fixLU(:,5);
saccs4 = convertFixToSacc(fixLU);


dlmwrite('clarke2013saccsMirrored.txt', [saccs1; saccs2;saccs3;saccs4]);





