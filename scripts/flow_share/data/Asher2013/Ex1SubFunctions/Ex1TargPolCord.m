function [TargEcc,TargAng] = Ex1TargPolCord(SceneID)

%Function that extracts the Eccentricity of the center of target (from 
%center of Scene) axial orientation from the Left horizontal.

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

TargEcc = sqrt((512-(SInf.Targ(1)+45)).^2 + (640-(SInf.Targ(2)+45)).^2);
TargAng = atan((512-(SInf.Targ(1)+45))/(640-(SInf.Targ(2)+45)));



