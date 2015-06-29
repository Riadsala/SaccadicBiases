%% Check data-sets are paresed properly!!
close all
clear all

dsets = {'Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview',...
    'Tatler2007search', 'Asher2013'};

for ds = dsets
    fix = grabFixations(ds);
    disp(ds)
    disp(strcat(num2str(nanmedian(fix.x),3), ' , ', num2str(nanmedian(fix.y),3)))
    disp(strcat(num2str(nanvar(fix.x),3), ' , ', num2str(nanvar(fix.y),3)))
%     figure;
%     subplot(1,2,1);
%     hist(fix.x,20);
%     subplot(1,2,2);
%     hist(fix.y,20);
end
    
    