function [ImOut] = Ex1Target(SceneID)

% This function returns the 90x90 image that is the Present-Target 

global AllSceneDir 

if isempty(AllSceneDir)
    [FileName,AllSceneDir,FilterIndex] = uigetfile({'.mat'},'Global Variable (SceneDir) Scene Directory not defined: Please select the Scene Data File');
end
load(strcat(AllSceneDir,'set120.mat')); %SceneList

SInf = SceneList(SceneID);

Img = imread(strcat(AllSceneDir,SInf.SourceFile));
Scene = Img(SInf.SceneRect(1):SInf.SceneRect(3),SInf.SceneRect(2):SInf.SceneRect(4),:);
ImOut = Scene(SInf.Targ(1):SInf.Targ(1)+89,SInf.Targ(2):SInf.Targ(2)+89,:);