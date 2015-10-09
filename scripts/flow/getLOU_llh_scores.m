clear all
close all
addpath('../helperfunctions');


sigma = 1;
B = fspecial('gaussian', [15,15], sigma);



datasets = {
    'Asher2013',...
    'Clarke2013', ...
    'Einhauser2008', ...
    'Tatler2005', ...
    'Tatler2007freeview', ...
    'Tatler2007search', ...
    'Judd2009',...
    'Yun2013SUN',...
    'Yun2013PASCAL',...
    'Clarke2009', ...
    'Ehinger2007'}

aspectRatio = 0.75;

fid = fopen('LOU_Results.txt', 'w');
fprintf(fid, 'dataset, score\n');
for (d=datasets)
    d
    if strcmp(d, 'Asher2013')
        aspectRatio=0.8;
    elseif strcmp(d, 'Borji2015')
        aspectRatio = 0.5625;
    else
        aspectRatio=0.75;
    end
    
    
    % import fixations
    fix = grabFixations(d{1});
    fix.x(fix.x<=-1) = NaN;
    fix.x(fix.x>1) = NaN;
    fix.y(fix.y<-1*aspectRatio) = NaN;
    fix.y(fix.y>1*aspectRatio) = NaN;
    fix.x = ceil(20*fix.x)+20;
    fix.y = ceil(20*fix.y*aspectRatio)+20*aspectRatio;
    fix.x(fix.x==0)=1;
    fix.y(fix.y==0)=1;
    
    results = [];
    % for each trial
    for tr = unique(fix.trial)'
        
        % for each person
        for pp = unique(fix.person(fix.trial==tr))'
            % get fixations of everybody else
            
            % make pdf
            z = 0.01*ones(40, 40*aspectRatio);
            
            for np =  unique(fix.person(fix.trial==tr))'
                if np~=pp
                    idx = fix.person==np & fix.trial==tr & isfinite(fix.x) & isfinite(fix.y);
                    lou_fix = [fix.x(idx), fix.y(idx)];
                    for f = 2:size(lou_fix,1)
                        z(lou_fix(f,1), lou_fix(f,2)) = z(lou_fix(f,1), lou_fix(f,2)) + 1;
                    end
                end
            end
                z = imfilter(z, B);
                z = size(z,1)* size(z,2) * z./sum(z(:));
                
                % now compute the llh of person pp's fixations given z
                idx = fix.person==pp & fix.trial==tr & isfinite(fix.x) & isfinite(fix.y);
                pp_fix = [fix.x(idx), fix.y(idx)];
                
                % calc llh
                llh = 0;
                for f = 2:size(pp_fix,1)
                    if z(pp_fix(f,1), pp_fix(f,2)) == 0
                        
                    end
                    llh = llh + log(z(pp_fix(f,1), pp_fix(f,2)));
                    
                end
                results = [results; tr, pp, llh];
                
            end
        end
        fprintf(fid, '%s, %d\n', d{1}, sum(results(:,3)));
    end
    
    
