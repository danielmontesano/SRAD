PPIscope; %Funcion que carga la matriz radar
close all;
cargaPintaOrtofoto; %Funcion que carga la ortofoto

Xo=ortofoto.PosicionRadar(1); %Se saca la posicion del radar
Yo=ortofoto.PosicionRadar(2);

% radius = geocradius(Yo); %Calculamos el radio en la latitud dada
% degX = km2deg(escala*1852,radius); %Convertimos nuestra distancia maxima en grados

% Rx = linspace(0,degX,length(canal1(:,1)));
% Ry = linspace(0,degX,length(canal1(:,1)));



%pasamos a coordenadas polares
X = r'*cos(theta-Azimut)+Xo;%Se le suma el offset de la posicion del radar
Y = r'*sin(theta-Azimut)+Yo;%Se le suma el offset de la posicion del radar
C = -flip(canal1')';
h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');

hold on
%superponemos la ortofoto
h_ortofoto=mapshow(ortofoto.foto(:,:,1:fin),color,ortofoto.R, alfa{:}, 'DisplayType', 'image');
radar_h=plot(ortofoto.PosicionRadar(1), ortofoto.PosicionRadar(2),'r+','MarkerSize',10);
axis tight equal
colorbar
