% do everything script
clear all;
close all

addpath('../helperFunctions/')

nRep = 1;
Sig2 = 0.22;


figure('position', [0 0 900 900]);
z = 0.12;
w = 0.1

axes('position', [w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
ylabel('log(likelihood)', 'fontsize', 12);
title('Yun 2013 - SUN', 'fontsize', 14)
% 
axes('position', [(1-w)/4+w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
title('Yun 2013 - SUN', 'fontsize', 14)


axes('position', [((1-w)*2)/4+w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
title('Tatler 2005', 'fontsize', 14)


axes('position', [((1-w)*3)/4+w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
title('Einhauser 2008', 'fontsize', 14)


axes('position', [w, (1-z)/3+z, (1-2*w)/3, (1-2*z)/3]);
title('Tatler 2007 freeview', 'fontsize', 14)
ylabel('log(likelihood)', 'fontsize', 12);

axes('position', [(1-w)/3+w, (1-z)/3+z, (1-2*w)/3, (1-2*z)/3]);
 title('Judd 2009')
% 
axes('position', [((1-w)*2)/3+w, (1-z)/3+z, (1-2*w)/3, (1-2*z)/3]);
 title('Yun 2013 - PASCAL', 'fontsize', 14)

axes('position', [w, z, (1-2*w)/3, (1-2*z)/3]);
title('Ehinger 2009', 'fontsize', 14)
ylabel('log(likelihood)', 'fontsize', 12);
% 
axes('position', [((1-w))/3+w, z, (1-2*w)/3, (1-2*z)/3]);
 title('Tatler 2007 Search', 'fontsize', 14)
% 
axes('position', [((1-w)*2)/3+w, z, (1-2*w)/3, (1-2*z)/3]);
 title('Asher 2013', 'fontsize', 14)

