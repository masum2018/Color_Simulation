%Monirul  05/29/2020
clear all;close all;clc; set(0,'defaultfigurecolor',[1 1 1]);
% set(0,'defaultAxesXLimSpec', 'tight')
%% control parameters
ROIx=16;
ROIy=16;
xRange=600:1300;
yRange=1300:1700;
bApplyFlatfieldCal=0;
%% load background noise
% load the file corresponding to exposure time.
FileNameOfBackgroundData='C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\Monochrometer\Dark\Capture_00001 15_02_22.tif';
Background=double(imread(FileNameOfBackgroundData));
disp(FileNameOfBackgroundData)

Rd=Background(1:2:end,1:2:end);
Bd=Background(2:2:end,2:2:end);
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
nCount=0;
RawImageFolder='C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\Monochrometer\';
for(nfolder=400:10:830)
    nCount=nCount+1;
    DataFolder=sprintf('%s%s%s',RawImageFolder,num2str(nfolder),'\');
    Filelist= dir([DataFolder,'*.tif']);
%     keyboard;
    for(nImageCount=1:1) %length(Filelist)
        RawImageFile = sprintf('%s%s',DataFolder,Filelist(nImageCount).name);
        RawImage=double(imread(RawImageFile));
        
        disp(RawImageFile)
        Rr=RawImage(1:2:end,1:2:end);
        Br=RawImage(2:2:end,2:2:end);
        Gr=RawImage(1:2:end,2:2:end);
        %         figure,imagesc(Rr);title("Red: Raw data");drawnow;
        %         keyboard;
        
        %         DarkCorrectedRedImage=Rr- Rd;
        %         DarkCorrectedGreenImage=Gr- Gd;
        %         DarkCorrectedBlueImage=Br- Bd;
        
        DarkCorrectedRedImage=Rr;
        DarkCorrectedGreenImage=Gr;
        DarkCorrectedBlueImage=Br;
        
        SaveRGB(nCount,1)=mean2(DarkCorrectedRedImage(xRange,yRange));
        SaveRGB(nCount,2)=mean2(DarkCorrectedGreenImage(xRange,yRange));
        SaveRGB(nCount,3)=mean2(DarkCorrectedBlueImage(xRange,yRange));        
            
    end
end
%% save data in xls
WaveLength=400:10:830;
figure,
plot(WaveLength,SaveRGB(:,1),'r');hold on;
plot(WaveLength,SaveRGB(:,2),'g');hold on;
plot(WaveLength,SaveRGB(:,3),'b');hold off;
legend("Red","Green","Blue");
title("Spectral response: Before Normalization");
xlabel("Wavelength(nm)");ylabel("#count")

%% load mochrometer's light source response

fileName='C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\Monochrometer\Data_monochro_light\Modified.DAT';
A=readmatrix(fileName);
A=abs(A);
ResponseOfDetector=A(6:49,4);  % unit A
UnitUnderTestCurrent=A(6:49,3); % unit A/W
ResponseSivity=UnitUnderTestCurrent./ResponseOfDetector; % unit W
SpectralResponse_LS(:,1)=A(6:49,1);
SpectralResponse_LS(:,2)=ResponseSivity;
figure,plot(SpectralResponse_LS(:,1),SpectralResponse_LS(:,2));
title(" [Wavelength(nm)] vs [DUT Current(A)/ Response of Detector(A/W)] ")
xlabel("Wavelength(nm)"); ylabel(" Spectral power(W)");

%% Normalization

NormFactor=SpectralResponse_LS(:,2);
NormFactor_3Color(:,1)=NormFactor;
NormFactor_3Color(:,2)=NormFactor;
NormFactor_3Color(:,3)=NormFactor;

NormalizationRGB=SaveRGB./NormFactor_3Color;

figure,
plot(WaveLength,NormalizationRGB(:,1),'r');hold on;
plot(WaveLength,NormalizationRGB(:,2),'g');hold on;
plot(WaveLength,NormalizationRGB(:,3),'b');hold off;
legend("Red","Green","Blue");
title("Spectral response: After Normalization with LS");
xlabel("Wavelength(nm)");ylabel("#count")

NormalizationRGB=NormalizationRGB/max(max(NormalizationRGB));

figure,
plot(WaveLength,NormalizationRGB(:,1),'r');hold on;
plot(WaveLength,NormalizationRGB(:,2),'g');hold on;
plot(WaveLength,NormalizationRGB(:,3),'b');hold off;
legend("Red","Green","Blue");
title("Spectral response: Final normalization");
xlabel("Wavelength[nm]");ylabel("Spectral Response[A.U.]");




