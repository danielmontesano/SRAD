
MatrizEntrada = MatrizIntegrada;
m = 4;
g = 2;
% Matriz= zeros(3, size(MatrizEntrada,2));
% Matriz2= [Matriz;MatrizEntrada];
% Matriz2=MatrizEntrada(4:end,:);
% Vec = zeros(1,15)';
% Vec(8) = 1;
CA_CFAR_filter = [ones(1,m/2) zeros(1,g/2) 0 zeros(1,g/2) ones(1,m/2)];

Umbral = filter(CA_CFAR_filter,1,MatrizEntrada,[],1);
Umbral = Umbral(7:end,:); %Se recorta 6 muestras iniciales
MatrizEntrada = MatrizEntrada(4:end-3,:); %Se recortan 3 por cada lado

%%

FactorDeEscala = 1

if(FactorDeEscala)
k = 0;
for T=.1:.01:4
   k = k+1;
   Pfa(k) = mean(mean(MatrizEntrada>T*Umbral));
   T_vec(k) = T;
  
end

figure(10)
plot(T_vec,log10(Pfa),'LineWidth',2)
grid
xlabel('Factor de escala')
ylabel('Log1(Pfa)')

end
%%
figure(11)
imagesc((MatrizEntrada>0.5*Umbral))
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('CAFR')
xlabel('Slot')
ylabel('Distancia (m)')
% shading flat