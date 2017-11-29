
clear all
% close all
%%
% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar del ruido en fase I ');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
%% quitar
load('G_C/TB2_ruido_Q_C.mat')
%%
I = src1.Data;
I = double(I);
I = I-mean(I);
Inorm = I/std(I);

% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar del ruido en cuadratura Q');
% load (cat(2, directorio, DatosPlots)); % los datos de plots
%% quitar
load('G_C/TB2_ruido_I_C.mat')
fc = 9;
%%
Q = src1.Data;
Q = double(Q);
Q =Q-mean(Q);
Qnorm = Q/std(Q);
% fc=input('Frecuencia de la portadora (GHz)=')
%%
fc=fc*1e9;

IQ = I + 1i.*Q;
modulo = abs(IQ);
fase = angle(IQ);

IQnorm = Inorm + 1i*Qnorm;
modulonorm = abs(IQnorm);
fasenorm = angle(IQnorm);

%%
figure(1)
subplot(211)
histfit(I,40,'normal'), axis([-0.01 0.01 0 2200])
title('FDP componente I')
xlabel('Valores (V)'),ylabel('Muestras');
subplot(212)
histfit(Q,40,'normal'), axis([-0.01 0.01 0 4000])
title('FDP componente Q')
xlabel('Valores (V)'),ylabel('Muestras');

figure(2)
subplot(211)
histfit(Inorm,40,'normal'), axis([-5 5 0 2200])
title('FDP componente I normalizada')
xlabel('Valores (V)'),ylabel('Muestras');
subplot(212)
histfit(Qnorm,40,'normal'), axis([-5 5 0 4000])
title('FDP componente Q normalizada')
xlabel('Valores (V)'),ylabel('Muestras');
%%
figure(3)
subplot(211)
histogram(modulo,50);title('FDP Envolvente o módulo V_{N}')
xlabel('Valores (V)'),ylabel('Muestras');
subplot(212)
histogram(modulonorm,50);title('FDP Envolvente o módulo V_{N} normalizada')
xlabel('Valores (V)'),ylabel('Muestras');

figure(4)
subplot(211)
histogram(fase,50);title('FDP fase \Phi_{N}')
xlabel('Radianes'),ylabel('Muestras');
subplot(212)
histogram(fasenorm,50);title('FDP fase \Phi_{N} normalizada')
xlabel('Radianes'),ylabel('Muestras');


