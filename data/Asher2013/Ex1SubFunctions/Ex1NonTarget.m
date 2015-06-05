function [ImOut] = Ex1NonTarget(SceneID)

% This function returns the 90x90 image that is the Absent-Target 

global AllSceneDir 

if isempty(AllSceneDir)
    [FileName,AllSceneDir,FilterIndex] = uigetfile({'.mat'},'Global Variable (SceneDir) Scene Directory not defined: Please select the Scene Data File');
end
load(strcat(AllSceneDir,'set120.mat')); %SceneList

SInf = SceneList(SceneID);

Img = imread(strcat(AllSceneDir,SInf.SourceFile));
ImOut = Img(SInf.NonTarg(1):SInf.NonTarg(1)+89,SInf.NonTarg(2):SInf.NonTarg(2)+89,:);