clear all
close all

load allFixData
allFixDat = containers.Map('KeyType','char','ValueType','any');

K = keys(allData);
class = cell(1,2000);
ii = 0;
for scn=1:length(K);
    ii = ii + 1;
    k = K{scn};
    tmp = regexp(k, '[\w]*(?=/)', 'match');
    class{ii} = tmp{1};
end
clear k ii tmp
classes = unique(class);
clear class

for cls = 1:length(classes)
    class = classes{cls};
    allFixDat(class) = [];
end


for scn=1:length(K);
    k = K{scn};
    dat = allData(k);
    tmp = regexp(k, '[\w]*(?=/)', 'match');
    class = tmp{1};
    clear tmp
    for ii = 1:length(dat)
        if size(dat{ii}.data,1) > 1
            
            allFixDat(class) = [allFixDat(class); [repmat(scn, [length(dat{ii}.data), 1]), repmat(ii, [length(dat{ii}.data), 1]), dat{ii}.data]];
        end
    end
end

for cls = 1:length(classes)
    class = classes{cls};
    classFixDat = allFixDat(class);
    dlmwrite([class 'Fixations.txt'], classFixDat);
end
