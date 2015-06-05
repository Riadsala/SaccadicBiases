clear all
close all

files = dir('allEyeData/*.mat');
F = [];
t = 0;
for s = 1:length(files)
    load(['allEyeData/' files(s).name]);
    
    
    for i = 1:10
        for j = 1:10
            
            fix = [xFix{i,j}, yFix{i,j}];
            if isfinite(imgNum(i,j))
                if imgNum(i,j) < 100
                    filename = ['img0' int2str(imgNum(i,j)) 'small.png'];
                else
                    filename = ['img' int2str(imgNum(i,j)) 'small.png'];
                end
                im = imread(['images/' filename]);
                
                for f = 1:size(fix,1)
                    t = t + 1;
                    F(t,:) = [imgNum(i,j), s, f, fix(f,1), fix(f,2) size(im,1), size(im,2)];
                end
                clear fix
            end
        end
    end
end
dlmwrite('fixations.txt', F);