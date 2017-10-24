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

cargaPintaOrtofoto %Funcion que carga la ortofoto

Xo=ortofoto.PosicionRadar(1); %Se saca la posicion del radar
Yo=ortofoto.PosicionRadar(2);

% radius = geocradius(Yo); %Calculamos el radio en la latitud dada
% degX = km2deg(escala*1852,radius); %Convertimos nuestra distancia maxima en grados

% Rx = linspace(0,degX,length(canal1(:,1)));
% Ry = linspace(0,degX,length(canal1(:,1)));

%filtro ideal iir
f = [0 0.6 0.6 1];
m = [1 1 0 0];
[b,a] = yulewalk(8,f,m);
[h,w] = freqz(b,a,length(canal1(:,1)));


theta = pi*(linspace(-1,1,length(canal1(1,:)))); %Se crea un vector de longitud el numero de pulsos que recorra los 360 grados
r = linspace(0,escala*1851,length(canal1(:,1))); %se crea un vector de longitud el numero de muestras por periodo y de valor maximo el fondo de escala

%pasamos a coordenadas polares
X = r'*cos(theta)+Xo;%Se le suma el offset de la posicion del radar
Y = r'*sin(theta)+Yo;%Se le suma el offset de la posicion del radar
C = -canal1;
figure(4);
h=pcolor(X,Y,C.*abs(h));
axis equal;
set(h, 'EdgeColor', 'none');

hold on
%superponemos la ortofoto
h_ortofoto=mapshow(ortofoto.foto(:,:,1:fin),color,ortofoto.R, alfa{:}, 'DisplayType', 'image');
radar_h=plot(ortofoto.PosicionRadar(1), ortofoto.PosicionRadar(2),'r+','MarkerSize',10);
axis tight equal
colorbar
