clear all
close all
[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar');
load (cat(2, directorio, DatosPlots)); % los datos de plots
%load('./muestras/C1_2017.mat');

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



theta = pi*(linspace(-1,1,length(canal1(1,:)))); %Se crea un vector de longitud el numero de pulsos que recorra los 360 grados
r = linspace(0,escala*1851,length(canal1(:,1))); %se crea un vector de longitud el numero de muestras por periodo y de valor maximo el fondo de escala

%pasamos a coordenadas polares
X = r'*cos(theta);
Y = r'*sin(theta);
C = -canal1;

figure(4);
h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');
colorbar
