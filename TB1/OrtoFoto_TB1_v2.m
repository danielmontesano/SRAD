clear all
close all


cargaPintaOrtofoto

Xo=ortofoto.PosicionRadar(1);
Yo=ortofoto.PosicionRadar(2);
% Calculo de la Matriz Radar 


figure(1)
% Incluir la representación PPI
%hold
h_ortofoto=mapshow(ortofoto.foto(:,:,1:fin),color,ortofoto.R, alfa{:}, 'DisplayType', 'image');
radar_h=plot(ortofoto.PosicionRadar(1), ortofoto.PosicionRadar(2),'r+','MarkerSize',10);
axis tight equal

