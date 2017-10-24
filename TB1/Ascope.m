warning ('off','all');
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
% numero de muestras

figure(1)

Rmax = (N/fs)*3e8/2;
distancia = linspace(0,Rmax,N);
tiempos = linspace(0,N/fs,N);
radar = canal1(:,1);
sync = canal2(:,1);


ax1 = axes('Position',[0 0 2 2],'Visible','off');

subplot (2,1,1)
h_1 = plot(tiempos, radar);
title('Pantalla tipo A')
grid
xlabel('Distancia (m)')
ylabel('V')
subplot (2,1,2)
h_2 = plot(tiempos,sync);
grid
xlabel('Tiempo (s)')
ylabel('V')

% ax2 = axes('Position',[.3 .1 .6 .8]);
% ax1 = axes('Position',[0 0 1 1],'Visible','off');
% str(1) = {'Celda de azimut:'};
% % str(2) = {k};
% str(3) = {'Grados:'};
% str(4) = {k*(360/(length(canal1(1,:))))};
% axes(ax1)
% info(1) = {'Frecuencia de muestreo:'};
% info(2)= {fs};
% info(3) = {'Celdas Azimut:'};
% info(4) ={celdasAz};
% info(5) = {'Celdas Distancia:'};
% info(6)={celdasDis};
% info(7) = {'Escala:'};
% info(8)={escala};
% annotation('textbox', [.6 .4 .3 .3], 'String', info,'FitBoxToText','on');

%text(.025,.6,str,'FontSize',12)


h_1.XDataSource = 'tiempos';
h_1.YDataSource = 'radar';

h_2.XDataSource = 'tiempos';
h_2.YDataSource = 'sync';



paso=1;
%eje de tiempos
k=1;
for k=1:paso:N
radar = canal1(:,k);
sync = canal2(:,k);

% str(2) = {k};
% str(4) = {k*(360/(length(canal1(1,:))))};
% text(.025,.6,str,'FontSize',12);
refreshdata;
pause(0.001);
end


