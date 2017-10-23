
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

N=max(size(canal1));
% n?mero de muestras

paso=1;
%eje de tiempos
k=1;
for k=1:paso:length(canal1(1,:))

figure(1)
ax1 = axes('Position',[0 0 2 2],'Visible','off');

subplot (2,1,1)
plot(canal1(:,k))
title('Pantalla tipo A')
grid
xlabel('Distancia (m)')
ylabel('V')
subplot (2,1,2)
plot( canal2(:,k))
grid
xlabel('Distancia (m)')
ylabel('V')
k=k+1;

% ax2 = axes('Position',[.3 .1 .6 .8]);
ax1 = axes('Position',[0 0 1 1],'Visible','off');
str(1) = {'Celda de azimut:'};
str(2) = {k};
str(3) = {'Grados:'};
str(4) = {k*(360/(length(canal1(1,:))))};
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

text(.025,.6,str,'FontSize',12)

pause(.06)
end


