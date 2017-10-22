clear all
 close all
% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
load('./muestras/C1_2017.mat');

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

cargaPintaOrtofoto

Xo=ortofoto.PosicionRadar(1);
Yo=ortofoto.PosicionRadar(2);
% Calculo de la Matriz Radar 


radius = geocradius(Yo); %Calculamos el radio en la latitud dada
degX = km2deg(escala*1852,radius); %Convertimos nuestra distancia maxima en grados

Rx = linspace(0,degX,length(canal1(:,1)));
Ry = linspace(0,degX,length(canal1(:,1)));


hold on

theta = pi*(linspace(-1,1,length(canal1(1,:))));
r = linspace(0,escala*1851,length(canal1(:,1)));



X = r'*cos(theta)+Xo;
Y = r'*sin(theta)+Yo;
C = -canal1;
figure(4);
h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');
% Incluir la representación PPI
hold on
%hold
h_ortofoto=mapshow(ortofoto.foto(:,:,1:fin),color,ortofoto.R, alfa{:}, 'DisplayType', 'image');
radar_h=plot(ortofoto.PosicionRadar(1), ortofoto.PosicionRadar(2),'r+','MarkerSize',10);
axis tight equal

