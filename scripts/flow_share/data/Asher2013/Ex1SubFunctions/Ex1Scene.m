function Scene = Ex1Scene(SceneID,Mark,TAShow)

% This function Extracts the whole image scenes for Experiment 2. 
% SceneID - Is the identification number of the Scene
% Mark - allows the Target patch to be highlighted within the Scene. Is a
% number that spesifes the thickness of the line round the patch. 
% TAShow - set to 1 to include a copy of the Absent Target as an insert
global AllSceneDir 

if nargin < 2; Mark = 0; end;
if nargin < 3; TAShow = 0; end;

if isempty(AllSceneDir)
    [FileName,AllSceneDir,FilterIndex] = uigetfile({'.mat'},'Global Variable (SceneDir) Scene Directory not defined: Please select the Scene Data File');
end
load(strcat(AllSceneDir,'set120.mat')); %SceneList

SInf = SceneList(SceneID);

Image = imread(strcat(AllSceneDir,SInf.SourceFile));
Scene = Image(SInf.SceneRect(1):SInf.SceneRect(3),SInf.SceneRect(2):SInf.SceneRect(4),:);


if TAShow 
    Scene(1:90,1:90,:) = Ex1NonTarget(SceneID);
    Scene = pixelbox(Scene,[1 1 90 90],[0 255 0],4);
end

if Mark
    Scene = pixelbox(Scene,[SInf.Targ(1),SInf.Targ(2),SInf.Targ(1)+90,SInf.Targ(2)+90],[255 0 0],Mark);
end

