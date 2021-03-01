
%%
close all
U=Entrada;
Y=Salida;
Phi=[Y(1:end-1),U(1:end-1)]';%el negativo del ARX no se tiene en cuenta. 
                             %Phi debe estar traspuesta porque para la red en matlab las entradas deben ser filas.
YReal=[Y(2:end)]';%Para la red en matlab la salida debe presentarse como fila.
%%
%Parameters stimation
Red=newff(Phi,YReal,[12],{'tansig','purelin'},'trainlm');
%Red.dividefcn='';
Red.Trainparam.epochs=500;
Red=train(Red,Phi,YReal);
%%
gensim(Red,0.01)% se simula la red con el tiempo de muestreo de la planta. con gensim se exporta la red a simulink

%%
% Extracci�n de los pesos para copiar a Arduino
%WCO=[Red.iw{1} Red.b{1}]
%WCS=[Red.lw{2,1} Red.b{2}]

%%
%simulacion pura: funciona con su propia salida.
%Simulacion de un paso: la red solo va a predecir la siguiente entrada

%%
%visualizacion de la superficie del modelo
plot3(Y(1:end-1),U(1:end-1),Y(2:end),'or')
xlabel('Salida (k-1)')
ylabel('Entrada (k-1)')
zlabel('Salida Real (k)')
hold on

RangoU=0:0.5:5;
RangoY=-0.25:0.25:2.5;
[U3d,Y3d]=meshgrid(RangoU,RangoY);
[f,c]=size(Y3d);
N=f*c;
Xred=[reshape(Y3d,1,N);
      reshape(U3d,1,N)];%entrada de la red neuronal


SalidaRed=sim(Red,Xred);%vector fila
Yest3d=reshape(SalidaRed,f,c);%Salida de la red en forma de matriz

surf(Y3d,U3d,Yest3d);
view(125,25)
hold off
