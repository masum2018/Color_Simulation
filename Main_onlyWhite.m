%Monirul  06/17/2020
clear all;close all;clc; set(0,'defaultfigurecolor',[1 1 1]);
%% parameter
bAnalyzeNonShiftedSpectrum=0;
bAnalyzeShiftedSpectrum=1;
IRCut_wavelength=380:780;

%% Input data
% load CIE standard data
CIE1931xyzFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\CIE Standard 1931xyz.xlsx";
CIE1931Standardxyz = readmatrix(CIE1931xyzFilename);clear CIE1931xyzFilename;

% load spectral response of the sensor
SensorSpectralResponseFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\50MP\Sensor Spectral Response.xlsx";
SensorSpectralResponse= readmatrix(SensorSpectralResponseFilename);clear SensorSpectralResponseFilename;

%load Spectrum@ 0 degree(Load RGB  spectrum in xlsx file)
DUTSpectrumNoShiftFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\Spectrum_NoShift.xlsx";
DUTSpectrumNoShift= readmatrix(DUTSpectrumNoShiftFilename);clear DUTSpectrumNoShiftFilename;
%load Shifted SpectrumPut all the combination of the spectrum in xlsx file)
DUTSpectrumShiftedFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\Spectrum_Shift.xlsx";
DUTSpectrumShifted= readmatrix(DUTSpectrumShiftedFilename);clear DUTSpectrumShiftedFilename;

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
%  keyboard;
%% pre-process the data
WaveLength=DUTSpectrumNoShift(:,1);
nStartWaveLength=WaveLength(1);
nIncrementWavelength=WaveLength(2)-WaveLength(1);
nEndWaveLength=WaveLength(end);

IRCutFilter=WaveLength*0;
IRCutFilter(1:length(IRCut_wavelength))=1;

% figure,plot(WaveLength,IRCutFilter);title("IR cut filter");
% keyboard;
nMultipyingFactor=100;
%interpolation
SensorSpectralResponseInterpolated(:,1)=WaveLength;
SensorSpectralResponseInterpolated(:,2)=interp1(SensorSpectralResponse(:,1),SensorSpectralResponse(:,2),WaveLength);
SensorSpectralResponseInterpolated(:,3)=interp1(SensorSpectralResponse(:,1),SensorSpectralResponse(:,3),WaveLength);
SensorSpectralResponseInterpolated(:,4)=interp1(SensorSpectralResponse(:,1),SensorSpectralResponse(:,4),WaveLength);

CIE1931StandardxyzInterpolated(:,1)=WaveLength;
CIE1931StandardxyzInterpolated(:,2)=interp1(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,2),WaveLength);
CIE1931StandardxyzInterpolated(:,3)=interp1(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,3),WaveLength);
CIE1931StandardxyzInterpolated(:,4)=interp1(CIE1931Standardxyz(:,1),CIE1931Standardxyz(:,4),WaveLength);


%% Apply IR cut filter's effect

DUTSpectrumNoShift(:,2)=DUTSpectrumNoShift(:,2).*IRCutFilter;
DUTSpectrumNoShift(:,3)=DUTSpectrumNoShift(:,3).*IRCutFilter;
DUTSpectrumNoShift(:,4)=DUTSpectrumNoShift(:,4).*IRCutFilter;

DUTSpectrumShifted(:,2)=DUTSpectrumShifted(:,2).*IRCutFilter;
DUTSpectrumShifted(:,3)=DUTSpectrumShifted(:,3).*IRCutFilter;
DUTSpectrumShifted(:,4)=DUTSpectrumShifted(:,4).*IRCutFilter;

if(bAnalyzeShiftedSpectrum)
    
    % load calibration matrix
    CalMatrixFilename="C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\50MP\Calibration Matrix.xlsx";
    CalMatrix = readmatrix(CalMatrixFilename);clear CalMatrixFilename;
    %generate spectrum
    R=DUTSpectrumShifted(:,2);G=DUTSpectrumShifted(:,3);
    B=DUTSpectrumShifted(:,4);W=DUTSpectrumShifted(:,5);
    SpectrumWarehouse(:,1)=W*nMultipyingFactor;

    for(nColor=1:1)
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
    
    FolderPath = 'C:\Monirul\Matlab world\WFOV_24MP_ColorCalibration\ColorSimulation_data\50MP\Results\';
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
