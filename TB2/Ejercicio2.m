
%
%               SISTEMAS RADAR MUIT  2017/18
%                  GMR  SSR  ETSIT  UPM
%
% Programa basico de procesado de un CW-RADAR
% Un solo canal
%
% Datos de entrada: capturas HST5
%
clear all
close all
% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar');
% load (cat(2, directorio, DatosPlots)); % los datos de plots

% fc_input=input('Frecuencia de la portadora (GHz)=') 
load('G_C/TB2_PRG_8_C.mat')
fc_input = 8;


A=src1.Data;
A=double(A);
A=A-mean(A);
% Quitamos las partes donde el blanco se mueve
% Guarado archivo PRG_8.gif y PRG_9.gif para buscar los indices
if(fc_input==8)
    load('Partes8GHz.mat');
    Ap=[];
    Ap = [Ap,A(Partes8GHz(1,1):Partes8GHz(1,2))];
    Ap = [Ap,A(Partes8GHz(2,1):Partes8GHz(2,2))];
    Ap = [Ap,A(Partes8GHz(3,1):Partes8GHz(3,2))];
    Ap = [Ap,A(Partes8GHz(4,1):Partes8GHz(4,2))];
    Ap = [Ap,A(Partes8GHz(5,1):Partes8GHz(5,2))];
elseif(fc_input==9)
    load('Partes9GHz.mat');
    Ap =[];
    Ap = [Ap,A(Partes9GHz(1,1):Partes9GHz(1,2))];
    Ap = [Ap,A(Partes9GHz(2,1):Partes9GHz(2,2))];
    Ap = [Ap,A(Partes9GHz(3,1):Partes9GHz(3,2))];
    Ap = [Ap,A(Partes9GHz(4,1):Partes9GHz(4,2))];
    Ap = [Ap,A(Partes9GHz(5,1):Partes9GHz(5,2))];
end

%Comparativa
figure(1),plot(Ap)
figure(2),plot(A)

fc=fc_input*1e9;

fs=src1.SampleFrequency % frecuencia de muestreo
N=max(size(Ap)); % n?mero de muestras

%% Variacion del numero de muestras
vec_np = 32:8:512;

for i = 1:length(vec_np)
    
np=vec_np(i);% % n?mero de muestras de STFT
zp=np*10; % n?mero de muestras de la FFT, entre np y zp se rellenan con ceros Zero-Padding
paso=32;
M=N/paso;
fdop=(0:(zp-1))*fs/zp; % eje de frecuencias de la FFT
t=(0:(N-1))/fs; %eje de tiempos
cont=0;
    for k=1:paso:floor(N-1.5*np)
       cont=cont+1;
       Yfft=fft(Ap(1,1+(k-1):np+(k-1)),zp);%FFT en el slot k
       Amax(cont)=max(abs(Yfft));
       fmed(cont)=(find(abs(Yfft)==Amax(cont), 1 )-1)*fs/zp;
       vel(cont) = (fmed(cont)*((3e8)/fc)/2)*100;
    end

%     figure(3)
%     plot(vel); 
%     grid
%     title (['Frecuencia Doppler Medida. Numero de Muestras: ',num2str(np)])
%     xlabel('Número de medida')
%     ylabel('Velocidad (cm/sg) slots')
%     ylim([0 40])
%      pause
    std_vel_np(i) = std(vel);
    vel = [];
end

figure(4)
plot(vec_np, std_vel_np)
title(['Desviacion tipica de la velocidad. ' num2str(fc_input) 'GHz'])
xlabel('Numero de muestras')
ylabel('Desviacion Tipica')


%% Variacion del Zero Padding

vec_zp = 4:2:128;

for i = 1:length(vec_zp)
    
np=256;% % n?mero de muestras de STFT
zp=np*vec_zp(i); % n?mero de muestras de la FFT, entre np y zp se rellenan con ceros Zero-Padding
paso=32;
M=N/paso;
fdop=(0:(zp-1))*fs/zp; % eje de frecuencias de la FFT
t=(0:(N-1))/fs; %eje de tiempos
cont=0;
    for k=1:paso:floor(N-1.5*np)
       cont=cont+1;
       Yfft=fft(Ap(1,1+(k-1):np+(k-1)),zp);%FFT en el slot k
       Amax(cont)=max(abs(Yfft));
       fmed(cont)=(find(abs(Yfft)==Amax(cont), 1 )-1)*fs/zp;
       vel(cont) = (fmed(cont)*((3e8)/fc)/2)*100;
    end

%     figure(5)
%     plot(vel); 
%     grid
%     title (['Frecuencia Doppler Medida. Numero de Muestras: ',num2str(np)])
%     xlabel('Número de medida')
%     ylabel('Velocidad (cm/sg) slots')
%     ylim([0 40])
%      pause
    std_vel_zp(i) = std(vel);
    vel = [];
end

figure(6)
plot(vec_zp, std_vel_zp)
title(['Desviacion tipica de la velocidad. ' num2str(fc_input) 'GHz'])
xlabel('Multiplicador de Zero Padding')
ylabel('Desviacion Tipica')

%%


%% 
% Sin cortes
N=max(size(A));
vec_np_entera = 32:8:512;

for i = 1:length(vec_np_entera)
    
np=vec_np_entera(i);% % n?mero de muestras de STFT
zp=np*10; % n?mero de muestras de la FFT, entre np y zp se rellenan con ceros Zero-Padding
paso=32;
M=N/paso;
fdop=(0:(zp-1))*fs/zp; % eje de frecuencias de la FFT
t=(0:(N-1))/fs; %eje de tiempos
cont=0;
    for k=1:paso:floor(N-1.5*np)
       cont=cont+1;
       Yfft=fft(A(1,1+(k-1):np+(k-1)),zp);%FFT en el slot k
       Amax(cont)=max(abs(Yfft));
       fmed(cont)=(find(abs(Yfft)==Amax(cont), 1 )-1)*fs/zp;
       vel(cont) = (fmed(cont)*((3e8)/fc)/2)*100;
    end

%     figure(7)
%     plot(vel); 
%     grid
%     title (['Frecuencia Doppler Medida. Numero de Muestras: ',num2str(np)])
%     xlabel('Número de medida')
%     ylabel('Velocidad (cm/sg) slots')
%     ylim([0 40])
%      pause
    std_vel_np_entera(i) = std(vel);
    vel = [];
end

figure(8)
plot(vec_np_entera, std_vel_np_entera)
title(['Señal sin cortes: Desviacion tipica de la velocidad. ' num2str(fc_input) 'GHz'])
xlabel('Numero de muestras')
ylabel('Error (cm/s)')
    