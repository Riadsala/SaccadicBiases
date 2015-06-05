%% Alasdair's edited version to get data for analysis

function showEyeDataAcrossUsers(folder)

% Tilke Judd June 26, 2008
% ShowEyeDataForImage should show the eyetracking data for all users in
% 'users' on a specified image.
folder = '../ALLSTIMULI';
users = {'CNG', 'ajs', 'emb', 'ems', 'ff', 'hp', 'jcw', 'jw', 'kae', 'krl', 'po', 'tmj', 'tu', 'ya', 'zb'};


% Cycle through all images
files = dir(strcat(folder, '/*.jpeg'));
R = [];
negctr = 0;
for i = 1:length(files)
    filename = files(i).name;
    % Get image
         img = imread(fullfile(folder, filename));
    %     figure;
          imshow(img); hold on;
    
    i
    for j = 1:length(users)
        user = users{j};
        
        % Get eyetracking data for this image
        datafolder = ['../DATA/' user];
        
        datafile = strcat(filename(1:end-4), 'mat');
        load(fullfile(datafolder, datafile));
        stimFile = eval([datafile(1:end-4)]);
        eyeData = stimFile.DATA(1).eyeData;
        [eyeData Fix Sac] = checkFixations(eyeData);
        
        Fix.medianXY(Fix.medianXY(:,1) < 1, :) = [];
        Fix.medianXY(Fix.medianXY(:,2) < 1, :) = [];
        Fix.medianXY(Fix.medianXY(:,1) > size(img,2), :) = [];
        Fix.medianXY(Fix.medianXY(:,2) > size(img,1), :) = [];
        
        for f = 1:size(Fix.medianXY,1)
            R = [R; i j f Fix.medianXY(f,1)-size(img,2)/2 Fix.medianXY(f,2)-size(img,1)/2,...
                size(img,2), size(img,1)];

        end
        
        
    end
    
end

dlmwrite('juddFixData_TrialSubjFixNXY.txt', R);