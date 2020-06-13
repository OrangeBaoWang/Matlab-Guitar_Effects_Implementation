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
function output = flanger(input, fs, delay, rate, gain, version)

% Obliczenie liczby probek opoznienia sygnalu audio
max_delay = floor(delay*fs/1000);

% Obliczenie cz�stotliwo�ci unormowanej sygna�u moduluj�cego
frequency_change= rate/fs;

output = input(:, 1);
n = max_delay+1:length(input);
delay_time = floor(max_delay*abs(sin(2*pi*frequency_change*n)));

if(strcmp(version,'FIR'))
    % Realizacja efektu Flanger w wersji SOI 
    output(n) =  (1/(1+gain)) * (input(n, 1) + gain*input(n-delay_time, 1));
else
     for n = max_delay+1:length(input)
         % Realizacja efektu Flanger w wersji NOI 
         output(n) =  (1/(1+gain)) * (input(n, 1) + gain*output(n-delay_time(n-max_delay)));
     end
end
