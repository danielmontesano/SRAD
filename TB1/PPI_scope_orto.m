PPIscope; %Funcion que carga la matriz radar
close all; %Cerramos la figura ya que generaremos otra nueva con offsets de la ortofoto
cargaPintaOrtofoto; %Funcion que carga la ortofoto

Xo=ortofoto.PosicionRadar(1); %Se saca la posicion del radar
Yo=ortofoto.PosicionRadar(2);
%El offset de escala y rango ya se ha corregido antes
%pasamos a coordenadas polares
X = r'*cos(theta-Azimut)+Xo;%Se le suma el offset de la posicion del radar y se corrige el offset en azimut
Y = r'*sin(theta-Azimut)+Yo;%Se le suma el offset de la posicion del radar y se corrige el offset en azimut
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
