
clear all
close all
[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar');
load (cat(2, directorio, DatosPlots)); % los datos de plots


canal1=Data.Channel1;
canal1=double(canal1);

canal2=Data.Channel2;
canal2=double(canal2);

celdasAz=Data.SegmentCount;
celdasDis=Data.RecordLength;
bits=Data.Resolution;
escala=Data.Escala;
tau=Data.Tau;
rpm=Data.Rpm;
PRF=Data.PRF;
fs=Data.SampleFrequency;

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
info(1) = {'Frecuencia de muestreo:'};
info(2)= {fs};
info(3) = {'Celdas Azimut:'};
info(4) ={celdasAz};
info(5) = {'Celdas Distancia:'};
info(6)={celdasDis};
info(7) = {'Escala:'};
info(8)={escala};
annotation('textbox', [.8 .5 .3 .3], 'String', info,'FitBoxToText','on');

% figure(3)
% x=linspace(0,360,length(canal1(1,:)));
% y=linspace(0,escala*1852,length(canal1(:,1)));
% z=-canal1;
% h=pcolor(x,y,z)
% set(h, 'EdgeColor', 'none');
% colorbar