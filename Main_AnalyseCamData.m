%Monirul  05/29/2020
clear all;close all;clc; set(0,'defaultfigurecolor',[1 1 1]);
set(0,'defaultAxesXLimSpec', 'tight')
%% control parameters
ROIx=16;
ROIy=16;
xRange=1300:1700;
yRange=1800:2200;
bApplyFlatfieldCal=0;
%% load background noise
% load the file corresponding to exposure time.
FileNameOfBackgroundData='C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\RS7\Calibration data\Dark\Capture_00001 17_44_43.tif';
Background=double(imread(FileNameOfBackgroundData));
disp(FileNameOfBackgroundData)

Rd=Background(1:2:end,1:2:end);
Bd=Background(2:2:end,2:2:end);
% Gd1=Background(1:2:end,2:2:end);
% Gd2=Background(2:2:end,1:2:end);
% Gd=(Gd1+Gd2)/2;
Gd=Background(1:2:end,2:2:end);
nImageCount=1;
SaveRGBNoise(nImageCount,1)=mean2(Rd(xRange,yRange));
SaveRGBNoise(nImageCount,2)=mean2(Gd(xRange,yRange));
SaveRGBNoise(nImageCount,3)=mean2(Bd(xRange,yRange));

% figure,surf(Rd(xRange,yRange))
% 
% figure,
% subplot(1,3,1), imagesc(Rd);title("Red:Dark");colorbar;
% subplot(1,3,2),imagesc(Gd);title("Green:Dark");colorbar;
% subplot(1,3,3),imagesc(Bd);title("Blue:Dark");colorbar;
% keyboard;

%% Load data for collected files
SaveRGB=[];
RawImageFolder='C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\RS7\Calibration data\Data_single\';

Filelist= dir([RawImageFolder,'*.tif']);
%  f=figure();
for(nImageCount=1:length(Filelist))
    RawImageFile = sprintf('%s%s',RawImageFolder,Filelist(nImageCount).name);
    RawImage=double(imread(RawImageFile));
    
    disp(RawImageFile)
    Rr=RawImage(1:2:end,1:2:end);
    Br=RawImage(2:2:end,2:2:end);
%     Gr1=RawImage(1:2:end,2:2:end);
%     Gr2=RawImage(2:2:end,2:2:end);
%     Gr=(Gr1+Gr2)/2;
   Gr=RawImage(1:2:end,2:2:end);
%     figure,imagesc(Rr);title("Red: Raw data");drawnow;
%     keyboard;
    
    DarkCorrectedRedImage=Rr- Rd;
    DarkCorrectedGreenImage=Gr- Gd;
    DarkCorrectedBlueImage=Br- Bd;
    
    %         DarkCorrectedRedImage=Rr;
    %         DarkCorrectedGreenImage=Gr;
    %         DarkCorrectedBlueImage=Br;
    
    SaveRGB(nImageCount,1)=mean2(DarkCorrectedRedImage(xRange,yRange));
    SaveRGB(nImageCount,2)=mean2(DarkCorrectedGreenImage(xRange,yRange));
    SaveRGB(nImageCount,3)=mean2(DarkCorrectedBlueImage(xRange,yRange));
    
    
    % figure,
    % subplot(1,3,1), imagesc(CorrectedRedImage);title("Red:FF Corrected");colorbar;
    % subplot(1,3,2),imagesc(CorrectedGreenImage);title("Green:FF Corrected");colorbar;
    % subplot(1,3,3),imagesc(CorrectedBlueImage);title("Blue:FF Corrected");colorbar;
    %
    
    
    % figure,
    % subplot(2,3,1), imagesc(Rr);title("Red: Raw");colorbar;
    % subplot(2,3,2),imagesc(Gr);title("Green:Raw");colorbar;
    % subplot(2,3,3),imagesc(Br);title("Blue:Raw");colorbar;
    %
    % subplot(2,3,4),imagesc(Background(:,:,1));title("Red: Dark");colorbar;
    % subplot(2,3,5), imagesc(Background(:,:,2));title("Green: Dark");colorbar;
    % subplot(2,3,6), imagesc(Background(:,:,3));title("Blue: Dark");colorbar;
    
end

%% save data in xls
% writematrix(SaveRGB,'RGB_RS7_onlyG.xlsx')




