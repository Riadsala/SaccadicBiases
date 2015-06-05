disp(' ')
disp(' ')
load AUC_CI95
disp(' & isotropic & aspect ratio & dataset fit & subject fit & baseline \\')

auc = mean(AUC.clarke2013);
ci = CI95.clarke2013;
disp(['\cite{clarke2013} & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);
auc = AUC.yun2013sun;
disp(['\cite{yun2013} - SUN & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

auc = mean(AUC.tatler2005);
disp(['\cite{tatler2005} & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

auc = mean(AUC.einhauser2008);
disp(['\cite{einhauser2008} & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);
disp('\hline')
auc = mean(AUC.tatler2007freeview);
disp(['\cite{tatler2007} - free & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

auc = mean(AUC.judd2009);
disp(['\cite{judd2012} & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

auc = mean(AUC.yun2013pascal);
disp(['\cite{yun2013} - PASCAL & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

disp('\hline')
auc = mean(AUC.ehinger2009);
disp(['\cite{ehinger2009} & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

auc = mean(AUC.tatler2007search);
disp(['\cite{tatler2007} - search & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

auc = mean(AUC.asher2013);
disp(['\cite{asher2013} & ' num2str(auc(1),3) ' & ' num2str(auc(2),3) ' & ' num2str(auc(3),3) ' & ' num2str(auc(5),3) ' & ' num2str(auc(4),3) '\\']);

clear auc
auc(:,1) = mean(AUC.asher2013);
auc(:,2) = mean(AUC.clarke2013);
auc(:,3) = mean(AUC.ehinger2009);
auc(:,4) = mean(AUC.einhauser2008);
auc(:,5) = mean(AUC.judd2009);
auc(:,6) = mean(AUC.tatler2005);
auc(:,7) = mean(AUC.tatler2007freeview);
auc(:,8) = mean(AUC.tatler2007search);
auc(:,9) = mean(AUC.yun2013pascal);
auc(:,10) = mean(AUC.yun2013sun);

auc = mean(auc,2);
disp(['improvement over isotropic & - & ' num2str(auc(2)-auc(1),3) ' & ' num2str(auc(3)-auc(1),3) ' & ' num2str(auc(5)-auc(1),3) ' & ' num2str(auc(4)-auc(1),3) ' \\ '])
% 
% 
% fout = fopen('aucForR.txt', 'w');
% auc = AUC.clarke2013;
% for n = 1:100
% fprintf(fout, 'clarke2013 ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'clarke2013 ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'clarke2013 ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'clarke2013 ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'clarke2013 ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.yun2013sun;
% for n = 1:100
% fprintf(fout, 'yun2013-sun ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'yun2013-sun ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'yun2013-sun ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'yun2013-sun ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'yun2013-sun ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.tatler2005;
% for n = 1:100
% fprintf(fout, 'tatler2005 ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'tatler2005 ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'tatler2005 ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'tatler2005 ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'tatler2005 ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.einhauser2008;
% for n = 1:100
% fprintf(fout, 'einhauser2008 ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'einhauser2008 ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'einhauser2008 ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'einhauser2008 ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'einhauser2008 ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.tatler2007freeview;
% for n = 1:100
% fprintf(fout, 'tatler2007freeview ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'tatler2007freeview ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'tatler2007freeview ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'tatler2007freeview ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'tatler2007freeview ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.judd2009;
% for n = 1:100
% fprintf(fout, 'judd2009 ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'judd2009 ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'judd2009 ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'judd2009 ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'judd2009 ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.yun2013pascal;
% for n = 1:100
% fprintf(fout, 'yun2013pascal ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'yun2013pascal ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'yun2013pascal ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'yun2013pascal ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'yun2013pascal ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.ehinger2009;
% for n = 1:100
% fprintf(fout, 'ehinger2009 ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'ehinger2009 ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'ehinger2009 ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'ehinger2009 ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'ehinger2009 ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.tatler2007search;
% for n = 1:100
% fprintf(fout, 'tatler2007search ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'tatler2007search ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'tatler2007search ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'tatler2007search ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'tatler2007search ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% 
% auc = AUC.asher2013;
% for n = 1:100
% fprintf(fout, 'asher2013 ');
% fprintf(fout, 'isotropic ');
% fprintf(fout, '%f \n\r', auc(n,1));
% fprintf(fout, 'asher2013 ');
% fprintf(fout, 'aspect.ratio ');
% fprintf(fout, '%f \n\r', auc(n,2));
% fprintf(fout, 'asher2013 ');
% fprintf(fout, 'dataset.fitted ');
% fprintf(fout, '%f \n\r', auc(n,3));
% fprintf(fout, 'asher2013 ');
% fprintf(fout, 'subject.fitted ');
% fprintf(fout, '%f \n\r', auc(n,5));
% fprintf(fout, 'asher2013 ');
% fprintf(fout, 'baseline ');
% fprintf(fout, '%f \n\r', auc(n,4));
% end
% fclose(fout);
