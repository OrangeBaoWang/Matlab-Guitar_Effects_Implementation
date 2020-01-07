%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt flanger
%   Efekt flanger sygna�u audio
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       delay- bazowa warto�� op�znienia sygna�u
%       rate- czestotliwosc "przemiatania" sygna�u oscylatorem LFO
%       gain- stosunek sygna�u op�nianego do oryginalnego
%       version- wersja efektu FIR lub IIR
%   Opis dzia�ania:
%       Struktura podobna do struktury efektu delay. Sygna� wej�ciowy
%       zostaje wst�pnie op�zniony o ma�� warto�� a nast�pnie zmodulowany
%       sygna�em sinusoidalnym. Op�nienie ka�dej pr�bki jest zmienne i
%       zale�ne od cz�stotliwo�ci "przemiatania" oscylatorem
%       LFO. Stosunek sygna�u op�znionego do oryginalnego mo�e by�
%       modyfikowany.
%       
%   Przyk�adowe wywo�anie
%       output = flanger(sygnal_audio, 44100, 15, 0.5, 0.3, 'FIR');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = flanger(input, Fs, delay, rate, gain, version)

% Obliczenie liczby probek opoznienia sygnalu audio
max_delay = floor(delay*Fs/1000);

% Obliczenie cz�stotliwo�ci unormowanej sygna�u moduluj�cego
frequency_change= rate/Fs;

output = zeros(length(input),1);

for i = 1:max_delay
    output(i) = input(i);
end

if(strcmp(version,'FIR'))
    for i = max_delay:length(input)
        % Realizacja efektu Flanger w wersji SOI 
        delayTime = 1 + round(max_delay/2*(1-cos(2*pi*frequency_change*i)));
        output(i) = (1/(1+gain)) * (input(i) + gain*input(i-delayTime));
    end
else
     for i = max_delay:length(input)
         % Realizacja efektu Flanger w wersji NOI 
         delayTime = 1 + round(max_delay/2*(1-cos(2*pi*frequency_change*i)));
        output(i) = (1/(1+gain)) * (input(i) + gain*output(i-delayTime));
     end
end
