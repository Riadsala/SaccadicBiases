%% extract fixes to my simple format
clear all
close all

files = dir('data/sun09/fixations/*.mat');
ctr = 0;
for t = 1:length(files)
    load(['data/sun09/fixations/' files(t).name]);
    for s = 1:length(fixations.sub_fixation)
        for f = 1:length(fixations.sub_fixation{s}.fix_X)
            ctr = ctr+1;
            R(ctr,:) = [t s f ...
                fixations.sub_fixation{s}.fix_X(f)...
                fixations.sub_fixation{s}.fix_Y(f)...
                fixations.image_width fixations.image_height];
        end
    end
end
dlmwrite('sun09fixations.txt', R);

files = dir('data/pascal_sentence/fixations/*.mat');
ctr = 0;
for t = 1:length(files)
    load(['data/pascal_sentence/fixations/' files(t).name]);
     I = imread(['data/pascal_sentence/images/' fixations.filename]);
    for s = 1:length(fixations.fixation)
        for f = 1:length(fixations.fixation{s}.fix_X)
            
            % get image dimensions
            
           
            dims = size(I);
            
            ctr = ctr+1;
            R(ctr,:) = [t s f ...
                fixations.fixation{s}.fix_X(f)...
                fixations.fixation{s}.fix_Y(f)...
                dims(2) dims(1)];
        end
    end
end
dlmwrite('pascalfixations.txt', R);