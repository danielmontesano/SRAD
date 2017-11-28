clear all
close all
% [DatosPlotsI, directorio] = uigetfile('*mat', 'Escoja el fichero I');
% load (cat(2, directorio, DatosPlotsI)); % los datos de plots
load('G_C/TB2_PRG_9_I_C');



I=src1.Data;
I=double(I);
I=I-mean(I);

% [DatosPlotsI, directorio] = uigetfile('*mat', 'Escoja el fichero Q');
% load (cat(2, directorio, DatosPlotsI)); % los datos de plots
load('G_C/TB2_PRG_9_Q_C');


Q=src1.Data;
Q=double(Q);
Q=Q-mean(Q);

% fc=input('Frecuencia de la portadora (GHz)=') 
fc = 9;
fc=fc*1e9;

%Se almacenan los datos en la Matriz A y se elimina la continua de los
%datos, valor medio

fs=src1.SampleFrequency;
% frecuencia de muestreo
N=max(size(I));
% n?mero de muestras
np=256;
% n?mero de muestras de STFT
zp=np*10;
% n?mero de muestras de la FFT, entre np y zp se rellenan con ceros
% Zero-Padding
paso=32;
M=N/paso;
% n?mero de medidas (sin solapamiento si paso=np), 
% n?mero de slots


fdop=linspace(-fs,fs,zp);
% eje de frecuencias de la FFT

t=(0:(N-1))/fs;
%eje de tiempos


A = I + j.*Q;

%Se saca la fase del numero complejo. Saca radianes
fase = phase(A);
lambda = 3e8/fc;
%Cada 2pi avanza la longitud de onda. Es distancia relativa.
distancia = fase*lambda/(2*2*pi);

subplot(211);
plot(t,distancia);
xlabel('Tiempo (s)')
ylabel('Variacion distancia (m)')
%Maxima variacion de distancia. La mesa tiene 90cm
fprintf('Variacion maxima: %1.2f cm\n',peak2peak(distancia))

%La velocidad es la derivada de la posicion. Se hace la diferencia entre
%muestras y se divide entre el tiempo de una muestra (1/fs)
velocidad = diff(distancia).*fs;

subplot(212);
plot(t(1:(end-1)),velocidad);
xlabel('Tiempo (s)')
ylabel('Velocidad instantanea (m/s)')



