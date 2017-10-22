
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

t=(0:(N-1))/fs;
paso=1;
%eje de tiempos
x=360/length(canal1(1,:))*(1:1:length(canal1(1,:)));
y=(escala*1852/length(canal1(:,1)))*(1:1:length(canal1(:,1)));

% thetaX = pi*(0:length(canal1(1,:))-1)/length(canal1(1,:));
% thetaY = pi*(0:length(canal1(:,1))-1)/length(canal1(:,1));
% 
% x1=x.*cos(thetaX);
% y1=y.*sin(thetaY);

% figure(1)
% pcolor(x,y,canal1);
% set(gca,'Ydir','reverse')
% colorbar

figure(2)
imagesc(x,y,(-1*canal1));
set(gca,'Ydir','Normal')
axis([0 inf 0 inf])
xlabel('Grados')
ylabel('Distancia (m)')
colorbar
% 
figure(3)
x=linspace(0,360,length(canal1(1,:)));
y=linspace(0,escala*1852,length(canal1(:,1)));
z=-canal1;
h=pcolor(x,y,z)
set(h, 'EdgeColor', 'none');
colorbar