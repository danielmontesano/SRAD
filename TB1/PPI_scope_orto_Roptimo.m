PPIscope; %Funcion que carga la matriz radar
close all; %Cerramos la figura ya que generaremos otra nueva con offsets de la ortofoto
cargaPintaOrtofoto; %Funcion que carga la ortofoto

fprintf('Tiempo: %s .\n', time);
fprintf('Frecuencia de muestreo: %s Hz .\n', fs);
fprintf('Celdas Azimut: %d .\n' , (celdasAz));
fprintf('Celdas Distancia: %d .\n' ,celdasDis);
fprintf('Resolución: %d .\n' ,bits);
fprintf('Escala: %d mn .\n' ,escala);
fprintf('Tau: %s s .\n' ,tau);
fprintf('Rpm: %d rpm .\n' ,rpm);
fprintf('PRF: %d Hz .\n' ,PRF);

res = 3e8*tau/2;
Ncel = Rmax/res;

%radar_opt=zeros(Ncel,celdasAz);
paso=N/Ncel;

aux = movsum(canal1, paso, 2);
radar_opt = aux(1:round(paso):end,:);
r_opt = linspace(0,Rmax,length(radar_opt(:,1)));

% for j=1:celdasAz
%     for i=0:Ncel-1
%         radar_opt(i+1,j) = sum(canal1(1+i*4:i*4+4,j))/floor(paso);
%     end
% end
r = r_opt;
theta = pi*(linspace(-1,1,length(radar_opt(1,:))));
 
Xo = ortofoto.PosicionRadar(1); %Se saca la posicion del radar
Yo = ortofoto.PosicionRadar(2);
%El offset de escala y rango ya se ha corregido antes
%pasamos a coordenadas polares
X = r'*cos(theta-Azimut)+Xo;%Se le suma el offset de la posicion del radar y se corrige el offset en azimut
Y = r'*sin(theta-Azimut)+Yo;%Se le suma el offset de la posicion del radar y se corrige el offset en azimut
C = -flip(radar_opt')';
h=pcolor(X,Y,C);
axis equal;
set(h, 'EdgeColor', 'none');

hold on
%superponemos la ortofoto
h_ortofoto=mapshow(ortofoto.foto(:,:,1:fin),color,ortofoto.R, alfa{:}, 'DisplayType', 'image');
radar_h=plot(ortofoto.PosicionRadar(1), ortofoto.PosicionRadar(2),'r+','MarkerSize',10);
axis tight equal
colorbar
xlabel('Longitud')
ylabel('Latitud')