
clear all
close all
[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar');
load (cat(2, directorio, DatosPlots)); % los datos de plots

canal1=Data.Channel1;
canal1=double(canal1);

canal2=Data.Channel2;
canal2=double(canal2);

time=Data.Time;
celdasAz=Data.SegmentCount;
celdasDis=Data.RecordLength;
bits=Data.Resolution;
escala=Data.Escala;
tau=Data.Tau;
rpm=Data.Rpm;
PRF=Data.PRF;
fs=Data.SampleFrequency;


fprintf('Tiempo: %s .\n', time);
fprintf('Frecuencia de muestreo: %s Hz .\n', fs);
fprintf('Celdas Azimut: %d .\n' , (celdasAz));
fprintf('Celdas Distancia: %d .\n' ,celdasDis);
fprintf('Resolución: %d .\n' ,bits);
fprintf('Escala: %d mn .\n' ,escala);
fprintf('Tau: %s s .\n' ,tau);
fprintf('Rpm: %d rpm .\n' ,rpm);
fprintf('PRF: %d Hz .\n' ,PRF);

N=length(canal1(:,1));
% n?mero de muestras

Rmax = (N/fs)*3e8/2;
y = linspace(0,Rmax,N); %se crea un vector de longitud el numero de muestras por periodo y de valor maximo el fondo de escala
x = linspace(0,360,celdasAz);


figure(1)
imagesc(x,y,(-1*canal1));
set(gca,'Ydir','Normal')
axis([0 inf 0 inf])
xlabel('Grados')
ylabel('Distancia (m)')
colorbar
