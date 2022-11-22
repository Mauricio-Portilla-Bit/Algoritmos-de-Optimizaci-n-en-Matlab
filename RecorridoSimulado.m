
% - - - RECOCIDO SIMULADO - - - 

% ALEGORÍA DEL ALGORÍTMO: 
% Simula el recocido análogo a la termodinámica 
% Calentar el sistema implica relajar el criterio de aceptación 

% - Estado Fundamental  : Solución Óptima Global 
% - Estado Metaestable  : Óptimo Local 
% - Energía             : Función Objetivo 
% - Temperatura         : Parámetro de Control 
% - Recocido Cuidadoso  : Recocido Simulado 
% - Posición Molecular  : Variables de Decisión 
% - Enfriamiento Rápido : Búsqueda Local 

% OBJETIVO DEL ALGORÍTMO: 
% Este algoritmo pretende encontrar el mínimo de una función 
% escapando en determinados casos de los mínimos locales que 
% se pueden presentar en situaciones de optimización  

% DESCRIPCIÓN DEL ALGORÍSMO: 
% Algorítmo estocástico y no hace uso de memoria 
% Se parte de una solución inicial 
% Se genera un vecino aleatorio en cada iteración 
% Los movimientos que mejoran la función objetivo siempre se aceptan 
% Los movimientos que empeoran la función objetivo no siempre: 
% - - Se selecciona una probabilidad de selección dependiente:
% - - - - La Temperatura (Temp) en dicho momento 
% - - - - La Degradación (Delta) de la función objetivo 
% - - - - La Probabilidad se modela con la "Distribución de Boltzmann"
% Probabilidad de Aceptación = e.^(-Delta / Temp)
% El control de temperatura será: 
% - Se mantiene un rato en cada nivel 
% - Una vez se alcance cierto equilibrio se va descendiendo 


clear all, clc; close all;

% FUNCIÓN OBJETIVO 
step = 0.01; 
x = 0:step:2; % Dominio en X
y = 0:step:2; % Dominio en Y 
[X, Y] = meshgrid(x,y); 

Z = cos(pi*X) + sin(pi*Y); % Función 
f = @(x,y) cos(pi*x) + sin(pi*y);

surf(X,Y,Z, 'displayName', 'Función');
hold on;
title("Mapa de la Función Bidimensional");
xlabel("X");
ylabel("Y");
zlabel("Z");

% CONDICIONES DEL PROBLEMA   
Temp = 500;  % temperatura inicial 
alfa = 0.5;    % mecanismo de descenso 
L = 1000;      % determina las iteraciones dentro de cada nivel 
Tempf = 0;  % temperatura final 
Delta = 0;   % error que genera el cambio de solución 

% current position
x_curr = rand(1)*2; 
y_curr = rand(1)*2; 

% possible position
x_pos = 0; 
y_pos = 0; 

Solution_curr = f(x_curr, y_curr); % Current Solution 
Solution_pos = 0;                  % Possible Solution

% ALGORITMO

while Temp >= Tempf
    
    % Iterar un determinado número de veces por cada nivel de temp
    for i = 1:L

        % Generar un vecino aleatorio para una solución posible
        x_pos = rand(1)*2; 
        y_pos = rand(1)*2; 
        Solution_pos = f(x_pos, y_pos);
        
        % Evalar el error del cambio de solución 
        % - Si Delta es positivo la solución empeoró 
        % - Si Delta es negativo la solución mejoró 
        Delta = Solution_pos - Solution_curr; 
        
        % Si mejora la función hacer un cambio de vecino 
        % Si no mejora la función, aplicar regla estocástica
        if Delta < 0 || rand(1) < exp(-Delta/Temp)
            Solution_curr = Solution_pos; 
            x_curr = x_pos; 
            y_curr = y_pos; 

        end
        
    end
    
    % Reducir la temperatura del sistema 
    Temp = Temp - alfa; 
    
end

% COMPARACIÓN DE LA SOLUCIÓN: 

% Obtención de Valores en Matlab 
minMatrix = min(Z(:));
[row,col] = find(Z==minMatrix);


% Impresión de Resultados de la función objetivo 
disp(['Solución de Recocido Simulado: ', num2str(Solution_curr)]);
disp(['Solución de Obtenida por Matlab: ', num2str(minMatrix)]);
disp(['Diferencia Absoluta: ', num2str(abs(Solution_curr - minMatrix))]);

% Impresión de Resultados de las coordenadas 
disp('- - - - - - - - - - - - - - - - - - - - - - ');
disp('Coordenadas del Recocido Simulado:');
disp(['x:', num2str(x_curr), '   y:', num2str(y_curr) ])
disp('Coordenadas de Matlab: ');
disp(['x:', num2str(col*step - step), '   y:', num2str(row*step - step)])

% INCORPORAR PUNTOS A LA GRÁFICA 
plot3(x_curr, y_curr, Solution_curr, 'r*', 'displayName', 'Recocido Simulado');
plot3(x_curr, y_curr, Solution_curr, 'bo', 'displayName', 'Mínimo de Matlab');
legend(); 
