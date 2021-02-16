%Monirul  05/29/2020
clear all;close all;clc; set(0,'defaultfigurecolor',[1 1 1]);

%% control parameters
xRange=1300:1700;
yRange=1800:2200;

%% load cal matrix
load("C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\RS7_24MP.mat")


%% load background noise
% load the file corresponding to exposure time.
FileNameOfBackgroundData='C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\RS7\Validation data\Dark\Capture_00001 17_58_54.tif';
Background=double(imread(FileNameOfBackgroundData));
disp(FileNameOfBackgroundData)

Rd=Background(1:2:end,1:2:end);
Bd=Background(2:2:end,2:2:end);
% Gd1=Background(1:2:end,2:2:end);
% Gd2=Background(2:2:end,1:2:end);
% Gd=(Gd1+Gd2)/2;
Gd=Background(1:2:end,2:2:end);
clear Background FileNameOfBackgroundData 
%% Load data for collected files

RawImageFolder='C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\RS7\Validation data\Green_25%\';
Filelist= dir([RawImageFolder,'*.tif']);
nImageCount=2;
RawImageFile = sprintf('%s%s',RawImageFolder,Filelist(nImageCount).name);
RawImage=double(imread(RawImageFile));
clear Filelist;
disp(RawImageFile)

Rr=RawImage(1:2:end,1:2:end);
Gr=RawImage(1:2:end,2:2:end);
Br=RawImage(2:2:end,2:2:end);

% figure,imagesc(Rr);
% keyboard;
    DarkCorrectedRedImage=Rr- Rd;
    DarkCorrectedGreenImage=Gr- Gd;
    DarkCorrectedBlueImage=Br- Bd;
clear Rr Rd Gr Gd Br Bd RawImage RawImageFolder RawImageFile ;
RedCollected=mean2(DarkCorrectedRedImage(xRange,yRange));
GreenCollected=mean2(DarkCorrectedGreenImage(xRange,yRange));
BlueCollected=mean2(DarkCorrectedBlueImage(xRange,yRange));
clear DarkCorrectedRedImage DarkCorrectedGreenImage DarkCorrectedBlueImage xRange yRange;
RGB(1,1)=RedCollected;RGB(1,2)=GreenCollected;RGB(1,3)=BlueCollected;
if((RedCollected ||GreenCollected||BlueCollected) > 60000 )
 disp("Saturated!!!")   
end
X=CalMatrix(1,1)*RedCollected +CalMatrix(2,1)*GreenCollected+CalMatrix(3,1)*BlueCollected;
Y=CalMatrix(1,2)*RedCollected +CalMatrix(2,2)*GreenCollected+CalMatrix(3,2)*BlueCollected;
Z=CalMatrix(1,3)*RedCollected +CalMatrix(2,3)*GreenCollected+CalMatrix(3,3)*BlueCollected;
clear CalMatrix;
clear RedCollected GreenCollected BlueCollected;
x=X/(X+Y+Z);
y=Y/(X+Y+Z);

Results(1,1)=x;
Results(1,2)=y;
clear x y;




