%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt tremolo
%   Efekt tremolo sygna�u audio
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       rate- czestotliwosc sygnalu modulujacego
%       depth- amplituda sygnalu modulujacego   
%       shape- kszta�t sygna�u moduluj�cego(SIN, TRIangle lub SQUare)
%   Opis dzia�ania:
%       Efekt polega na modulacji amplitudowej sygna�u wej�ciowego 
%       odpowiednim sygna�em moduluj�cym.
%       
%   Przyk�adowe wywo�anie
%       output = tremolo(sygnal_audio, 44100, 2, 0.5, "SQU");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = tremolo(input, fs, rate, depth, shape)

%Obliczenie cz�stotliwo�ci unormowanej sygna�u moduluj�cego
frequency_mod = rate / fs;

output = input(:,1);
n = 1:length(input);

% Sygna� moduluj�cy - tr�jk�t
if shape == "TRI"
    output(n) = (1/(1+depth))*input(n, 1)'.*(1+depth*(sawtooth(2*pi*frequency_mod*n)));

% Sygna� moduluj�cy - prostok�t
elseif shape == "SQU"
    output(n) = (1/(1+depth))*input(n, 1)'.*(1+depth*(square(2*pi*frequency_mod*n)));
    
% Sygna� moduluj�cy - sinus
else
    output(n) = (1/(1+depth))*input(n, 1)'.*(1+depth*(sin(2*pi*frequency_mod*n)));
end





