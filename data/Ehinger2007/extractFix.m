%% extract fixes to my simple format
clear all
close all

files = dir('eyeData/*.mat');
ctrTP = 0;
ctrTA = 0;
for t = 1:length(files)
    load(['eyeData/' files(t).name]);
    fixations = eval(files(t).name(1:(end-4)));
    clear(files(t).name(1:(end-4)));
     num_subjects = length(fixations.subdata);
    if strcmp(fixations.target, 'TP');      
       
        for s = 1:num_subjects
            for f = 1: size(fixations.subdata(s).fixXY,1)
                ctrTP = ctrTP + 1;
                Rtp(ctrTP,:) = [t s f ...
                    fixations.subdata(s).fixXY(f,1)...
                    fixations.subdata(s).fixXY(f,2)];
            end
        end
    else
         for s = 1:num_subjects
            for f = 1: size(fixations.subdata(s).fixXY,1)
                ctrTA = ctrTA + 1;
                Rta(ctrTA,:) = [t s f ...
                    fixations.subdata(s).fixXY(f,1)...
                    fixations.subdata(s).fixXY(f,2)];
            end
        end
        
        
    end
end
dlmwrite('ehinger2007fixationsTP.txt', Rtp);
dlmwrite('ehinger2007fixationsTA.txt', Rta);