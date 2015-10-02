clear all
close all

load allFixData
allDat = [];
K = keys(allData);

for scn=1:length(K);
    k = K{scn};
    dat = allData(k);
    for ii = 1:length(dat)
        if size(dat{ii}.data,1) > 1
            allDat = [allDat; [repmat(scn, [length(dat{ii}.data), 1]), repmat(ii, [length(dat{ii}.data), 1]), dat{ii}.data]];
        end
    end
end

dlmwrite('allFixations.txt', allDat);
