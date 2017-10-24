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
offsetD = sqrt(YoffsetD^2+XoffsetD^2);
aux = find(r>offsetD);
indexD = aux(1);

canal1 = canal1(indexD:end,:);

theta = pi*(linspace(-1,1,length(canal1(1,:)))); %Se crea un vector de longitud el numero de pulsos que recorra los 360 grados
r = linspace(0,escala*1851,length(canal1(:,1))); %se crea un vector de longitud el numero de muestras por periodo y de valor maximo el fondo de escala

%pasamos a coordenadas polares
X = r'*cos(theta);
Y = r'*sin(theta);
C = -flip(canal1')';

h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');
colorbar;

disp('Seleccionar blanco conocido')
[Xoffset, Yoffset] = ginput(1);

AzTarget = deg2rad(input('Azimut del blanco conocido (deg)'));
DTarget = input('Distancia del blanco conocido (km)')*1000;


AzOffset = -atan(Yoffset/Xoffset)+pi/2;
DOffset = sqrt(Yoffset^2 + Xoffset^2);

offsetEscala = DTarget/DOffset;
escala = escala*offsetEscala;

Azimut = AzTarget - AzOffset;


theta = pi*(linspace(-1,1,length(canal1(1,:)))); %Se crea un vector de longitud el numero de pulsos que recorra los 360 grados
r = linspace(0,escala*1851,length(canal1(:,1))); %se crea un vector de longitud el numero de muestras por periodo y de valor maximo el fondo de escala

%pasamos a coordenadas polares
X = r'*cos(theta-Azimut);
Y = r'*sin(theta-Azimut);
C = -flip(canal1')';

h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');
colorbar;