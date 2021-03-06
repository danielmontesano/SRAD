
% Programa para la formaci?n de Matrices Radar para el Radar FMCW Coherente
% MUIT 2017/18 TB3
% Sistemas Radar
% SSR
% Grupo de Microondas y Radar


clear all
close all

% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos la moduladora');
load ('G_C/CANAL1_2GHZ_FM_5.mat'); Yoffset = -0; Ni = 11;escala = 0.44;% 0.36 asc los datos de plots
 %load ('G_C/CANAL1_2GHz_FM_SCAN_6.mat'); Yoffset = -0; Ni = 7;escala = 0.62;% 0.62 desc 
 %load ('G_C/CANAL1_2GHZ_FM_SCANTRACK_7'); Yoffset = -0; Ni = 5; escala = 0.72;% 0.7 desc



A=src1.Data;
A=double(A);
Sincro=diff(filter(ones(1,50),1,(A>5))>10);
Do=find(Sincro==1);    %rampa ascendente
% Do=find(Sincro==-1);     %rampa descendente
if Do(1)<1000
    D1=Do(2:end);
    Do=[];
    Do=D1;
end
Do=Do;                 %retardo del filtro rampa ascendente   
% Do=Do-40;                %retardo del filtro rampa descendente

NPER=max(size(Do))-1;
% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos de la se?al de batido');

  load ('G_C/CANAL2_2GHZ_FM_5.mat');
 %load ('G_C/CANAL2_2GHz_FM_SCAN_6.mat');
 %load ('G_C/CANAL2_2GHZ_FM_SCANTRACK_7');

B=src1.Data;
B=double(B);

N=max(size(A));                    % N?mero total de muestras del fichero

fs=src1.SampleFrequency
fm=43.1;                          %Medida en el laboratorio de la frecuencia de la moduladora
FG=abs(fft(A));FG(1)=0;
fm=fs/N*(find(FG==max(FG),1)-1);%Frecuencia de la moduladora 
                                %Estimada con los datos, la FFT y tomando como referencia fs
Np=floor(fs/fm)+2;

 Tm1=0.01;                       % Tiempo de barrido, Medida en el Lab, pero se puede extraer de los datos
                                % Rampa Ascendente, este par?metro lo puede
                                % ajustar
% Tm1=0.003;                      % Tiempo de barrido, Medida en el Lab, pero se puede extraer de los datos
                                % Rampa Descendente, este par?metro lo puede
                                % ajustar                  
Nfft=round(fs*Tm1);             % N?mero  de muestras en tiempo r?pido


M=round(max(size(A))/Np)-10;   % N?mero de celdas en tiempo lento que se procesan (quito 10)


%B = randn(size(B));
%   figure(1)
 
 
  NPER=floor(M);
for k=1:NPER
  
      Moduladora(k,:)=A(Do(k)-Nfft/2+1:Do(k)+Nfft/2); %Quitamos muestras iniciales y finales de CW
      MatrizRadar(k,:)=B(Do(k)-Nfft/2+1:Do(k)+Nfft/2);
      MatrizRadarfft(k,:)=fft((MatrizRadar(k,:)),4*Nfft); %fft con mas puntos para meter zero padding
% figure(1)
%     subplot(211),plot(1:Nfft,Moduladora(k,:),...
%         1:Nfft,(MatrizRadar(k,:)),'k')
%     grid
%   title('Modulo AZUL MODULADORA    NEGRO se�al de batido')
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft -2 12 ])
%     subplot(212),plot(1:Nfft*4,20*log10(abs(MatrizRadarfft(k,1:Nfft*4))))
%     grid
%   title('Perfil de distancias')
%     xlabel('muestras')
%     ylabel('dB')
%     axis([1 Nfft*4 0 40 ])
%     
%  pause(.01)
   
end

% Se han  calculado los perfiles de distancia sin ventana pero con interpolaci?n
% Este proceso lo tiene que modificar seg?n enunciado del trabajo TB3

MatrizRadar=[];
MatrizRadar=MatrizRadarfft(:,1:4*Nfft/2);
MatrizRadar=MatrizRadar';

BW = 2e9;
Rmax = (fs/2)*Tm1*3e8/(BW*2);
distancias = linspace(0,Rmax,size(MatrizRadar,1));
pared = find(distancias>8.15);
pared = pared(1);
MatrizRadar = circshift(MatrizRadar,-round(Yoffset),1);
ejex= linspace(1,1,Np);

deltaR = 3e8/(BW*2);
Nceldas = Rmax/deltaR;


%% C�lculo Ti y n

deltaR = 7.5;
v = 30;
fm = 43.5;
rpm_360 = 12;
rpm_120 = 16;

theta_antena = 6;
theta_blanco = 4.77;

n_estatico = round((deltaR/v)*fm);
n_360 = round(((theta_blanco+theta_antena)*fm)/(6*rpm_360));
n_120 = round(((theta_blanco+theta_antena)*fm)/(6*rpm_120));



%% Cancelador + enventanado


%enventanado
ventana= hamming(size(MatrizRadar,1));


for i=1:size(MatrizRadar,2)
   
    Matriz_enventanada(:,i)= ifft(MatrizRadar(:,i)).*ventana;
%     MatrizCancelada(:,i)= cancelador(1,MatrizRadar_hann(:,i));
%     MatrizRadar_h_fft(:,i)=(fft(MatrizRadar_hann(:,i)));
%     MatrizRadar_h_fft(:,i)=(abs(fft(MatrizRadar_hann(:,i))).^2)/((sum(wh_mat)^2)/sum(wh_mat.^2));
end

Matriz_enventanada = fft(Matriz_enventanada);

%% Diezmado

Ndiez=round(size(Matriz_enventanada,1)/Nceldas);
 for i=1:size(Matriz_enventanada,2)
         MatrizRadar_diez(:,i) = filter((1/Ndiez)*ones(1,Ndiez),1,Matriz_enventanada(:,i),[],1);
 end
    
 matrizDiezmada = MatrizRadar_diez((Ndiez:Ndiez:end),:);
 
figure(7)
imagesc(ejex,distancias,(20*log10(abs(matrizDiezmada))))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
caxis([-10 30])
c.Label.String = 'Amplitud (dB)';
c.Label.FontSize = 11;
xlabel('Slot')
ylabel('Distancia(m)')
title('Diezmada')
grid
shading flat 

ScanceladorIN=19; %dB
CcanceladorIN_1=14.69;
CcanceladorIN_2=20.53;
NcanceladorIN = rms(matrizDiezmada(72,:));
 
%% Cancelador



%Cancelador simple
matrizCancelador1 = cancelador(1,matrizDiezmada); 

ScanceladorOUT_1=18.2;
CcanceladorOUT_1=11.24;
CcanceladorOUT_1_2=8.86;
NcanceladorOUT_1 = rms(matrizCancelador1(72,:));

%Cancelador doble
matrizCancelador2 = cancelador(2,matrizDiezmada);

ScanceladorOUT_2=18.2;
CcanceladorOUT_2=15.31;
CcanceladorOUT_2_2=6.037;
NcanceladorOUT_2 = rms(matrizCancelador1(72,:));

%Cancelador triple
matrizCancelador3 = cancelador(3,matrizDiezmada);

ScanceladorOUT_3=17.96;
CcanceladorOUT_3=8.052;
CcanceladorOUT_3_2=10.98;
NcanceladorOUT_3 = rms(matrizCancelador1(72,:));


%Comparacion comparador
figure(300); hold on;
plot(abs(matrizDiezmada(:,200)))

plot(abs(matrizCancelador1(:,200)))

plot(abs(matrizCancelador2(:,200)))

plot(abs(matrizCancelador3(:,200)))
legend('Sin cancelador', 'Cancelador simple', 'Cancelador doble', 'Cancelador triple');

    
%% Integrador

MatrizIntegrada = integrador(2,matrizCancelador2,Ni);

SintegradorOUT=16.77;
CintegradorOUT_1=5.85;
CintegradorOUT_2=6.432;
NintegradorOUT = rms(MatrizIntegrada(24,:));

%% Calculo de potencias medidas y relaciones

% Relacion de cancelacion
RC1=CcanceladorOUT_1-CcanceladorIN_1;
RC2=CcanceladorOUT_2-CcanceladorIN_1;
RC3=CcanceladorOUT_3-CcanceladorIN_1;

RC4=CcanceladorOUT_1_2-CcanceladorIN_2;
RC5=CcanceladorOUT_2_2-CcanceladorIN_2;
RC6=CcanceladorOUT_3_2-CcanceladorIN_2;

% Relacion se�al a cluter
SC_in=ScanceladorIN-CcanceladorIN_1;
SC_in_2=ScanceladorIN-CcanceladorIN_2;

SC_cancelador1_out_1=ScanceladorOUT_1-CcanceladorOUT_1;
SC_cancelador1_out_2=ScanceladorOUT_1-CcanceladorOUT_1_2;

SC_cancelador2_out_1=ScanceladorOUT_2-CcanceladorOUT_2;
SC_cancelador2_out_2=ScanceladorOUT_2-CcanceladorOUT_2_2;

SC_cancelador3_out_1=ScanceladorOUT_3-CcanceladorOUT_3;
SC_cancelador3_out_2=ScanceladorOUT_3-CcanceladorOUT_3_2;

SC_integrador_out_1=SintegradorOUT-CintegradorOUT_1;
SC_integrador_out_2=SintegradorOUT-CintegradorOUT_2;

% IMTI
Imti_cancelador1= SC_cancelador1_out_1-SC_in;
Imti_cancelador1_2= SC_cancelador1_out_2-SC_in_2;

Imti_cancelador2= SC_cancelador2_out_1-SC_in;
Imti_cancelador2_2= SC_cancelador2_out_2-SC_in_2;

Imti_cancelador3= SC_cancelador3_out_1-SC_in;
Imti_cancelador3_2= SC_cancelador3_out_2-SC_in_2;

% Relacion se�al a ruido
SN_diezmada=ScanceladorIN-20*log10(NcanceladorIN);
SN_cancelador1=ScanceladorOUT_1-20*log10(NcanceladorOUT_1);
SN_cancelador2=ScanceladorOUT_2-20*log10(NcanceladorOUT_2);
SN_cancelador3=ScanceladorOUT_3-20*log10(NcanceladorOUT_3);
SN_integrador=SintegradorOUT-20*log10(NintegradorOUT);

I=SN_integrador-SN_cancelador2;
%% CA_CFAR
CA_CFAR(escala, MatrizIntegrada, distancias, ejex, Ni);


%% Representaci�n Matriz recibida (en crudo)


figure(2)
imagesc(ejex,distancias,20*log10(abs(filter([1 0 ],1,MatrizRadar))))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
caxis([-10 30])

c.Label.String = 'Amplitud (dB)';
c.Label.FontSize = 11;
xlabel('Slot')
ylabel('Distancia(m)')

title('VENTANA RECTANGULAR')
grid
shading flat 

%% Representaci�n Matriz Cancelada

%Cancelador simple
figure(3)
imagesc(ejex,distancias,20*log10(abs(matrizCancelador1)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
caxis([-20 10])
c.Label.String = 'Amplitud (dB)';
c.Label.FontSize = 11;
xlabel('Slot')
ylabel('Distancia(m)')
grid
shading flat 
title('Matriz con enventanado Hamming + cancelador simple')

%Cancelador doble
figure(4)
imagesc(ejex,distancias,20*log10(abs(matrizCancelador2)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
caxis([-20 10])
c.Label.String = 'Amplitud (dB)';
c.Label.FontSize = 11;
xlabel('Slot')
ylabel('Distancia(m)')
grid
shading flat 
title('Matriz con enventanado Hamming + cancelador doble')

%Cancelador triple
figure(5)
imagesc(ejex,distancias,20*log10(abs(matrizCancelador3)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
caxis([-20 10])
c.Label.String = 'Amplitud (dB)';
c.Label.FontSize = 11;
xlabel('Slot')
ylabel('Distancia(m)')
grid
shading flat 
title('Matriz con enventanado Hamming + cancelador triple')

%Pantalla tipo A
% figure(4)
% for k=1:size(MatrizCancelada,2)
%   
%   subplot(211), plot((abs(MatrizRadar(:,k))))
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft*2 0 30 ])
%     
%     subplot(212),plot((abs(MatrizRadar_h_fft(:,k))))
%     grid
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft*2 0 30 ])
%     
%  pause(.01)
% end

%% Representaci�n Cancelador + Integrador

figure(6)
imagesc(ejex,distancias,20*log10(abs(MatrizIntegrada)))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
caxis([-20 10])

c.Label.String = 'Amplitud (dB)';
c.Label.FontSize = 11;
xlabel('Slot')
ylabel('Distancia(m)')

grid
shading flat 
title('Matriz con enventanado Hamming + cancelador+ integrador')






% figure(6)
% for k=1:size(MatrizIntegrada,2)
%   
%   subplot(211), plot((abs(MatrizIntegrada(:,k))))
%     grid
%     title('Matriz integrada')
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft*2 0 10 ])
%     
%     subplot(212),plot((abs(MatrizRadar_h_fft(:,k))))
%     grid
%      title('Matriz cancelada')
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft*2 0 10 ])
%     
%  pause(.01)
% end