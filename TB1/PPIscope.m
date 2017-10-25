clear all
close all
%%
%Cargamos los datos
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

N = length(canal1(:,1));%Numero de muestras

%%
%Primera representacion para corregir el offset de distancia

Rmax = (N/fs)*3e8/2;
theta = pi*(linspace(-1,1,length(canal1(1,:)))); %Se crea un vector de longitud el numero de pulsos que recorra los 360 grados
r = linspace(0,Rmax,N); %se crea un vector de longitud el numero de muestras por periodo y de valor maximo el fondo de escala

%pasamos a coordenadas polares
X = r'*cos(theta);
Y = r'*sin(theta);
C = -flip(canal1')';

figure(4);
h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');
colorbar;
zoom on;
zoom(30);


%correccion offset distancia
disp('Seleccionar distancia 0')
[XoffsetD, YoffsetD] = ginput(1);
offsetD = sqrt(YoffsetD^2+XoffsetD^2);%Calculamos la distancia a la que se corresponde el offset
aux = find(r>offsetD);%Averiguamos el indice de ese ofset
indexD = aux(1);

canal1 = canal1(indexD:end,:);%Recortamos la matriz radar
N = length(canal1(:,1));%Numero de muestras
Rmax = (N/fs)*3e8/2;

%%
%Segunda representacion para corregir offset de azimut
theta = pi*(linspace(-1,1,length(canal1(1,:)))); %Se crea un vector de longitud el numero de pulsos que recorra los 360 grados
r = linspace(0,Rmax,N); %se crea un vector de longitud el numero de muestras por periodo y de valor maximo el fondo de escala

%pasamos a coordenadas polares
X = r'*cos(theta);
Y = r'*sin(theta);
C = -flip(canal1')';

h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');
colorbar;

%Seleccionamos las cordenadas cartesianas de un blanco conocido
disp('Seleccionar blanco conocido')
[Xoffset, Yoffset] = ginput(1);
%Las pasamos  a coordenadas polares
AzOffset = -atan(Yoffset/Xoffset)+pi/2;%Mas 90grad por donde esta colocado el 0.

%Obtenemos las coordenadas polares de un blanco conocido
AzTarget = deg2rad(input('Azimut del blanco conocido (deg) '));

Azimut = AzTarget - AzOffset;

%pasamos a coordenadas polares
X = r'*cos(theta-Azimut);%Se corrige el offset de azimut
Y = r'*sin(theta-Azimut);
C = -flip(canal1')';
%%
%Representacion final
h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');
colorbar;