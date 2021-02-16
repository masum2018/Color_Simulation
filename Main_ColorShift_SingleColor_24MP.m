%Monirul  06/17/2020
clear all;close all;clc; set(0,'defaultfigurecolor',[1 1 1]);
%% parameter
bAnalyzeNonShiftedSpectrum=0;
bAnalyzeShiftedSpectrum=1;

%% Input data
% load CIE standard data
CIE1931xyzFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\CIE Standard 1931xyz.xlsx";
CIE1931Standardxyz = readmatrix(CIE1931xyzFilename);clear CIE1931xyzFilename;

% load spectral response of the sensor
SensorSpectralResponseFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\24MP\Sensor Spectral Response.xlsx";
SensorSpectralResponse= readmatrix(SensorSpectralResponseFilename);clear SensorSpectralResponseFilename;

%load Spectrum@ 0 degree(Load RGB  spectrum in xlsx file)
DUTSpectrumNoShiftFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\Spectrum_NoShift.xlsx";
DUTSpectrumNoShift= readmatrix(DUTSpectrumNoShiftFilename);clear DUTSpectrumNoShiftFilename;
%load Shifted SpectrumPut all the combination of the spectrum in xlsx file)
DUTSpectrumShiftedFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\Spectrum_Shift.xlsx";
DUTSpectrumShifted= readmatrix(DUTSpectrumShiftedFilename);clear DUTSpectrumShiftedFilename;

%loaded input signal
% figure,
% subplot(3,1,1),plot(SensorSpectralResponse(:,1),SensorSpectralResponse(:,2),'r');hold on;
% plot(SensorSpectralResponse(:,1),SensorSpectralResponse(:,3),'g');hold on;
% plot(SensorSpectralResponse(:,1),SensorSpectralResponse(:,4),'b');hold off;
% xlabel("Wavelength[nm]");legend("Red","Green","Blue");
% title("Input 1:Spectral Response of the sensor");
% 
% subplot(3,1,2),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,2),'r');hold on;
% plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,3),'g');hold on;
% plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,4),'b');hold off;
% xlabel("Wavelength[nm]");legend("Red","Green","Blue");
% title("Input 2:DUT spectrum@ 0 degree(No Shift)");
% 
% subplot(3,1,3),plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,2),'r');hold on;
% plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,3),'g');hold on;
% plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,4),'b');hold off;
% xlabel("Wavelength[nm]");legend("Red","Green","Blue");
% title("Input 3:DUT spectrum@extreme angle(Shifted)");
% 
figure,
subplot(3,1,1),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,2),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,2),'r');hold off;
xlabel("Wavelength[nm]");legend("Red(No Shift)","Red(Shifted)" );
title("Comparision of the Input Spectrum");

subplot(3,1,2),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,3),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,3),'g');hold off;
xlabel("Wavelength[nm]");legend("Green(No Shift)","Green(Shifted)" );
title("Comparision of the Input Spectrum");

subplot(3,1,3),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,4),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,4),'b');hold off;
xlabel("Wavelength[nm]");legend("Blue(No Shift)","Blue(Shifted)" );
title("Comparision of the Input Spectrum");
% keyboard;
%% pre-process the data
WaveLength=DUTSpectrumNoShift(:,1);
nStartWaveLength=WaveLength(1);
nIncrementWavelength=WaveLength(2)-WaveLength(1);
nEndWaveLength=WaveLength(end);
nMultipyingFactor=100;

%interpolation
SensorSpectralResponseInterpolated(:,1)=WaveLength;
SensorSpectralResponseInterpolated(:,2)=interp1(SensorSpectralResponse(:,1),SensorSpectralResponse(:,2),WaveLength);
SensorSpectralResponseInterpolated(:,3)=interp1(SensorSpectralResponse(:,1),SensorSpectralResponse(:,3),WaveLength);
SensorSpectralResponseInterpolated(:,4)=interp1(SensorSpectralResponse(:,1),SensorSpectralResponse(:,4),WaveLength);

% figure,
% subplot(3,1,1),plot(SensorSpectralResponse(:,1),SensorSpectralResponse(:,2),'k');hold on;
% plot(WaveLength,SensorSpectralResponseInterpolated(:,2),'or');hold off;title("Red");
% subplot(3,1,2),plot(SensorSpectralResponse(:,1),SensorSpectralResponse(:,3),'k');hold on;
% plot(WaveLength,SensorSpectralResponseInterpolated(:,3),'og');hold off;title("Green");
% subplot(3,1,3),plot(SensorSpectralResponse(:,1),SensorSpectralResponse(:,4),'k');hold on;
% plot(WaveLength,SensorSpectralResponseInterpolated(:,4),'ob');hold off;title("Blue");
% 
CIE1931StandardxyzInterpolated(:,1)=WaveLength;
CIE1931StandardxyzInterpolated(:,2)=interp1(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,2),WaveLength);
CIE1931StandardxyzInterpolated(:,3)=interp1(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,3),WaveLength);
CIE1931StandardxyzInterpolated(:,4)=interp1(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,4),WaveLength);
% 
% figure,
% subplot(3,1,1),plot(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,2),'k');hold on;
% plot(WaveLength,CIE1931StandardxyzInterpolated(:,2),'or');hold off;title("Red");
% subplot(3,1,2),plot(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,3),'k');hold on;
% plot(WaveLength,CIE1931StandardxyzInterpolated(:,3),'or');hold off;title("Green");
% subplot(3,1,3),plot(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,4),'k');hold on;
% plot(WaveLength,CIE1931StandardxyzInterpolated(:,4),'or');hold off;title("Blue");

% keyboard;
%% overlapping graph
% for RGB

MaxR=max(DUTSpectrumNoShift(:,2));
MaxSR_red=max(SensorSpectralResponseInterpolated(:,2));

MaxG=max(DUTSpectrumNoShift(:,3));
MaxSR_green=max(SensorSpectralResponseInterpolated(:,3));

MaxB=max(DUTSpectrumNoShift(:,4));
MaxSR_blue=max(SensorSpectralResponseInterpolated(:,4));



figure,
subplot(3,1,1),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,2),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,2),'r');hold on;
plot(DUTSpectrumShifted(:,1),SensorSpectralResponseInterpolated(:,2)*MaxR/MaxSR_red,'m');
hold off;
xlabel("Wavelength[nm]");legend("Red(No Shift)","Red(Shifted)","SR" );
title("Comparision of the Input Spectrum");

subplot(3,1,2),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,3),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,3),'g');hold on;
plot(DUTSpectrumShifted(:,1),SensorSpectralResponseInterpolated(:,3)*MaxG/MaxSR_green,'m');
hold off;
xlabel("Wavelength[nm]");legend("Green(No Shift)","Green(Shifted)","SR" );
title("Comparision of the Input Spectrum");

subplot(3,1,3),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,4),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,4),'b');hold on;
plot(DUTSpectrumShifted(:,1),SensorSpectralResponseInterpolated(:,4)*MaxB/MaxSR_blue,'m');
hold off;
xlabel("Wavelength[nm]");legend("Blue(No Shift)","Blue(Shifted)","SR" );
title("Comparision of the Input Spectrum");


figure,
subplot(3,1,1),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,2),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,2),'r');hold on;
plot(DUTSpectrumShifted(:,1),SensorSpectralResponseInterpolated(:,2),'m');
hold off;
xlabel("Wavelength[nm]");legend("Red(No Shift)","Red(Shifted)","SR" );
title("Comparision of the Input Spectrum");

subplot(3,1,2),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,3),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,3),'g');hold on;
plot(DUTSpectrumShifted(:,1),SensorSpectralResponseInterpolated(:,3),'m');
hold off;
xlabel("Wavelength[nm]");legend("Green(No Shift)","Green(Shifted)","SR" );
title("Comparision of the Input Spectrum");

subplot(3,1,3),plot(DUTSpectrumNoShift(:,1),DUTSpectrumNoShift(:,4),'k');hold on;
plot(DUTSpectrumShifted(:,1),DUTSpectrumShifted(:,4),'b');hold on;
plot(DUTSpectrumShifted(:,1),SensorSpectralResponseInterpolated(:,4),'m');
hold off;
xlabel("Wavelength[nm]");legend("Blue(No Shift)","Blue(Shifted)","SR" );
title("Comparision of the Input Spectrum");

keyboard;


%% Process the data
if(bAnalyzeNonShiftedSpectrum)
    %create a mix of spectrum(7 colors)
    R=DUTSpectrumNoShift(:,2);G=DUTSpectrumNoShift(:,3);B=DUTSpectrumNoShift(:,4);
    SpectrumWarehouse(:,1)=R*nMultipyingFactor;
    SpectrumWarehouse(:,2)=G*nMultipyingFactor;
    SpectrumWarehouse(:,3)=B*nMultipyingFactor;
    SpectrumWarehouse(:,4)=(R+G)*nMultipyingFactor;
    SpectrumWarehouse(:,5)=(R+B)*nMultipyingFactor;
    SpectrumWarehouse(:,6)=(G+B)*nMultipyingFactor;
    SpectrumWarehouse(:,7)=(R+G+B)*nMultipyingFactor;
    
    PatternCombination(1,:)=[255,0,0];PatternCombination(2,:)=[0,255,0];PatternCombination(3,:)=[0,0,255];
    PatternCombination(4,:)=[255,255,0];PatternCombination(5,:)=[255,0,255];PatternCombination(6,:)=[0,255,255];
    PatternCombination(7,:)=[255,255,255];
    for(nColor=1:7)
        % calculate tristimulus XYZ
        % create a function for this
        
        X=trapz(WaveLength,SpectrumWarehouse(:,nColor).*CIE1931StandardxyzInterpolated(:,2) );
        Y=trapz(WaveLength,SpectrumWarehouse(:,nColor).*CIE1931StandardxyzInterpolated(:,3) );
        Z=trapz(WaveLength,SpectrumWarehouse(:,nColor).*CIE1931StandardxyzInterpolated(:,4) );
        
        %calculate RGB value
        % create a function for this
        R=trapz(WaveLength,SpectrumWarehouse(:,nColor).*SensorSpectralResponseInterpolated(:,2) );
        G=trapz(WaveLength,SpectrumWarehouse(:,nColor).*SensorSpectralResponseInterpolated(:,3) );
        B=trapz(WaveLength,SpectrumWarehouse(:,nColor).*SensorSpectralResponseInterpolated(:,4) );
        
        XYZ_RGB(nColor,1)=PatternCombination(nColor,1); XYZ_RGB(nColor,2)=PatternCombination(nColor,2);XYZ_RGB(nColor,3)=PatternCombination(nColor,3);
        XYZ_RGB(nColor,4)=X; XYZ_RGB(nColor,5)=Y;XYZ_RGB(nColor,6)=Z;
        XYZ_RGB(nColor,7)=R; XYZ_RGB(nColor,8)=G;XYZ_RGB(nColor,9)=B;
    end
    
    % save XYZ and RGB data to generate Calibration Matrix
    
   
    FolderPath = 'C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\24MP\Calibration data\';
    FileName="Simulated Calibration Data_";
    CurrentTime=datestr(now,'mm-dd-yyyy HH-MM');    
    ResultFileName = sprintf('%s%s%s%s',FolderPath,FileName,CurrentTime,'.xlsx');   
    
    col_header={'Red Color','Green Color','Blue Color','X','Y','Z','R Counts ','G Counts','B Counts'};     %Row cell array (for column labels)
    xlswrite(ResultFileName,XYZ_RGB,'Sheet1','A2');     %Write data
    xlswrite(ResultFileName,col_header,'Sheet1','A1');     %Write column header
    disp("Simulated calibration data saved here:")
    disp(ResultFileName)
end

if(bAnalyzeShiftedSpectrum)
    
    % load calibration matrix
    CalMatrixFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\24MP\Calibration Matrix.xlsx";
    CalMatrix = readmatrix(CalMatrixFilename);clear CalMatrixFilename;
    %generate spectrum
    R=DUTSpectrumShifted(:,2);G=DUTSpectrumShifted(:,3);B=DUTSpectrumShifted(:,4);
    SpectrumWarehouse(:,1)=R*nMultipyingFactor;
    SpectrumWarehouse(:,2)=G*nMultipyingFactor;
    SpectrumWarehouse(:,3)=B*nMultipyingFactor;
    SpectrumWarehouse(:,4)=(R+G)*nMultipyingFactor;
    SpectrumWarehouse(:,5)=(R+B)*nMultipyingFactor;
    SpectrumWarehouse(:,6)=(G+B)*nMultipyingFactor;
    SpectrumWarehouse(:,7)=(R+G+B)*nMultipyingFactor;
    for(nColor=1:3)
        % calculate tristimulus XYZ
        % create a function for this
        Xs=trapz(WaveLength,SpectrumWarehouse(:,nColor).*CIE1931StandardxyzInterpolated(:,2) );
        Ys=trapz(WaveLength,SpectrumWarehouse(:,nColor).*CIE1931StandardxyzInterpolated(:,3) );
        Zs=trapz(WaveLength,SpectrumWarehouse(:,nColor).*CIE1931StandardxyzInterpolated(:,4) );
        xs=Xs/(Xs+Ys+Zs);
        ys=Ys/(Xs+Ys+Zs);
        %calculate RGB value
        % create a function for this
        Rs=trapz(WaveLength,SpectrumWarehouse(:,nColor).*SensorSpectralResponseInterpolated(:,2) );
        Gs=trapz(WaveLength,SpectrumWarehouse(:,nColor).*SensorSpectralResponseInterpolated(:,3) );
        Bs=trapz(WaveLength,SpectrumWarehouse(:,nColor).*SensorSpectralResponseInterpolated(:,4) );
        % Apply cal matrix on Rs,Gs and Bs
        Xm=CalMatrix(1,1)*Rs +CalMatrix(2,1)*Gs+CalMatrix(3,1)*Bs;
        Ym=CalMatrix(1,2)*Rs +CalMatrix(2,2)*Gs+CalMatrix(3,2)*Bs;
        Zm=CalMatrix(1,3)*Rs +CalMatrix(2,3)*Gs+CalMatrix(3,3)*Bs;
        xm=Xm/(Xm+Ym+Zm);
        ym=Ym/(Xm+Ym+Zm);
        
        Result(nColor,1)=Xs; Result(nColor,2)=Ys;Result(nColor,3)=Zs;Result(nColor,4)=xs;Result(nColor,5)=ys;
        Result(nColor,6)=Rs; Result(nColor,7)=Gs;Result(nColor,8)=Bs;
        Result(nColor,9)=Xm; Result(nColor,10)=Ym;Result(nColor,11)=Zm;Result(nColor,12)=xm;Result(nColor,13)=ym;
        Result(nColor,14)=xs-xm; Result(nColor,15)=ys-ym;
        
    end
    
    FolderPath = 'C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\24MP\Results\';
    FileName="Results_";
    CurrentTime=datestr(now,'mm-dd-yyyy HH-MM');    
    ResultFileName = sprintf('%s%s%s%s',FolderPath,FileName,CurrentTime,'.xlsx');    
     
    col_header={'X_shifted','Y_shifted','Z_shifted','1931 x','1931 y','Simulated R','Simulated G','Simulated B','X_Calculated','Y_Calculated','Z_Calculated','1931 x','1931 y','dx','dy'};     %Row cell array (for column labels)
    row_header(1:4,1)={'Pattern Colors','Red','Green','Blue'};   
   
    xlswrite(ResultFileName,Result,'Sheet1','B2');         %Write data
    xlswrite(ResultFileName,col_header,'Sheet1','B1');     %Write column header
    xlswrite(ResultFileName,row_header,'Sheet1','A1');     %Write column header
    disp("Simulated Error data saved here:");
    disp(ResultFileName);
end
