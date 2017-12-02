clear all
close all
% [DatosPlotsI, directorio] = uigetfile('*mat', 'Escoja el fichero I');
% load (cat(2, directorio, DatosPlotsI)); % los datos de plots
load('G_C/TB2_PRG_9_I_SCAN5_C');



I=src1.Data;
I=double(I);
I=I-mean(I);

% [DatosPlotsI, directorio] = uigetfile('*mat', 'Escoja el fichero Q');
% load (cat(2, directorio, DatosPlotsI)); % los datos de plots
load('G_C/TB2_PRG_9_Q_SCAN5_C');


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
% n ?mero de medidas (sin solapamiento si paso=np), 
% n?mero de slots


fdop=linspace(-fs/2,fs/2,zp);
% eje de frecuencias de la FFT

t=(0:(N-1))/fs;
%eje de tiempos


A = I + j.*Q;


cont=0;
for k=1:paso:floor(N-1.5*np)
    cont=cont+1;
    Yfft=fft(A(1,1+(k-1):np+(k-1)),zp);
    Matriz(cont,:)=Yfft;
   [Amax(cont), Imax(cont)] = max(Yfft);
end
amplitudes = abs(Amax);
halfMax = (min(amplitudes) + max(amplitudes)) / 2;
figure;
plot(amplitudes)
hold on
plot(ones(1,length(amplitudes))*halfMax)

disp('Seleccione primer punto')
x1 = ginput(1);
disp('Seleccione segundo punto')
x2 = ginput(1);
vr = input('Velocidad radial')

ancho = ((x2(1)-x1(1))/fs)*vr;