function [Center] = Ex1TargLoc(SceneID)

%Function that extracts the X Y location of the Target Center for teh
%Scenee at SceneID

global AllSceneDir 

if isempty(AllSceneDir)
    [FileName,AllSceneDir,FilterIndex] = uigetfile({'.mat'},'Global Variable (SceneDir) Scene Directory not defined: Please select the Scene Data File');
end
load(strcat(AllSceneDir,'set120.mat')); %SceneList

SInf = SceneList(SceneID);

Center = SInf.Targ(1:2)+45;