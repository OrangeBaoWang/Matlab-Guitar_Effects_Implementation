%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt delay
%   Efekt symuluj�cy echo sygna�u poprzez dodanie do orygina�u sygna�u
%   op�nionego i st�umionego
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       delay_value- op�nienie sygna�u w ms
%       gain- przyrost sygna�u op�nionego wzgl�dem orygina�u
%       version - okre�la wersj� FIR lub IIR u�ywanego efektu
%   Opis dzia�ania:
%       Dodanie do obecnej pr�bki warto�ci pr�bki z przed "delayTime"
%       pr�bek temu, uwzgl�dniajac zysk sygna�u op�nionego do orygina�u.
%
%   Przyk�adowe wywo�anie
%       output = delay(sygnal_audio, 44100, 200, 0.5, 'FIR');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = delay(input, fs, delay_value, gain, version)

% Obliczenie liczby probek opoznienia sygnalu audio
delay_time = floor(delay_value*fs/1000);

output = input(:,1);
n = delay_time+1:length(input);
 
if(strcmp(version, 'FIR'))
    % Dodanie opoznionej probki do bie��cej w wersji SOI efektu
    output(n) = (1/(1+gain))*(input(n, 1) + gain*input(n-delay_time, 1));              
else
    % Dodanie opoznionej probki do bie��cej w wersji NOI efektu
    for n = delay_time+1:length(input)
        output(n) = (1/(1+gain))*(input(n, 1) + gain*output(n-delay_time));
    end                       
end

