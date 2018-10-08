clear all close all
fs=100e6;%frecuencia de muestreo
dt=1/fs;%intervalo temporal de la simulaci�n
taut=100e-6;%duraci�n del pulso transmitido
t=0:dt:taut;%eje de tiempos simulado
DF=1e6;%excursi�n en frecuencia 
s=exp(j*pi*DF/taut*t.^2);%se�al chirp 
ceros=zeros(1,10000);%se a�aden ceros al pulso para siular un periodo T de la se�al
S=[s ceros];
figure(1)
title('pulso transmitido') 
plot(real(S))
grid
% %coeficientes del filtro adaptado
% N=max(size(t)); 
% b=conj(s(N:-1:1));
% %fitrado digital fir FILTRO ADAPTADO DIGITAL METODO 1 
% y=filter(b,1,S);
% figure(2)
% subplot(211),plot(real(S))
% title('pulso a la entrada METODO 1') 
% grid
% subplot(212),plot(abs(y))
% title('pulso comprimido')
% grid
   %fitrado digital FILTRO ADAPTADO DIGITAL METODO 2
Hfa=conj(fft(S));%CONJUGADO DE LA TRANSFORMADA DE FOURIER DE LA SE�AL
yn=ifft(fft(S).*Hfa);
yn=fftshift(yn);
figure(3)
subplot(211),plot(real(S))
title('pulso a la entrada METODO2') 
grid
subplot(212),plot(abs(yn))

title('pulso comprimido') 
grid