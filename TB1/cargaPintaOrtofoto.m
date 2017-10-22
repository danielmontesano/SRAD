% Ubicacion de la ETSIT 
% Autora: Ana Martín Ayuso
ETSIT_C={...	 % Parametros para la ETSIT edif C
	'latInput', 40.453436111111110;...
	'lonInput',  -3.726647222222222;...
	'AlturaRadar', 680 + 4.5;  % Altura en ETSIT
	};
ETSIT_A={...	 % Parametros para la ETSIT edif A
	'latInput',40.451964;...
	'lonInput',  -3.726642;...
	'AlturaRadar', 675;  % Altura en ETSIT
	};
radar_pos=ETSIT_A;

transparencia=false;

% cargaOrtofoto apannao
PathNameOrtofoto=pwd;
[FileNameOrtofoto,PathNameOrtofoto,FilterIndex] = uigetfile(fullfile(PathNameOrtofoto,'*.tif'),'Fichero GEOTIFF...');
[ortofoto.foto, ortofoto.C ,ortofoto.R, ortofoto.bbox] = geotiffread(fullfile(PathNameOrtofoto,FileNameOrtofoto));

metadatosGeoTIFF = geotiffinfo(fullfile(PathNameOrtofoto,FileNameOrtofoto));
[latInput lonInput]=radar_pos{1:2,2};

[posRadarX, posRadarY] = projfwd(metadatosGeoTIFF, latInput, lonInput);
ortofoto.PosicionRadar = [posRadarX posRadarY]; %Posicion del radar en cartesianas
ortofoto.PosicionRadar_LonLat = [lonInput latInput]; %Posicion del radar en geograficas

% representarOrtofoto apañao
figure (1);
hold on;
transparencia=1;
% esto es para el tema de las transparencia, miro si la ortofoto tiene
% transparencia y si la tiene la pinto o no dependiendo de lo que tenga
% arriba
if size(ortofoto.foto,3)==4
	if transparencia
% 		alfa={'AlphaData'; ortofoto.foto(:,:,4)};
alfa={'AlphaData'; ortofoto.foto(:,:,4)};
	else
		alfa={};
	end
	fin=3;
elseif length(size(ortofoto.foto))==2
	alfa={};
	fin=1;
else
	alfa={};
	fin=3;
end

if isfield(ortofoto,'colormap')
		color=ortofoto.colormap;
	else
		color=ortofoto.C;
	end

% h_ortofoto=mapshow(ortofoto.foto(:,:,1:fin),color,ortofoto.R, alfa{:}, 'DisplayType', 'image');
% radar_h=plot(ortofoto.PosicionRadar(1), ortofoto.PosicionRadar(2),'r+','MarkerSize',10);
% axis tight

% uistack(h_ortofoto,'bottom');
% plot ppi
% plot ortofoto
% plot posRadar
