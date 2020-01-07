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
function output = tremolo(input, Fs, rate, depth, shape)

%Obliczenie cz�stotliwo�ci unormowanej sygna�u moduluj�cego
frequency_mod = rate / Fs;

output = zeros(length(input),1);

% Sygna� moduluj�cy - tr�jk�t
if shape == "TRI"
    for i = 1:length(input)
        output(i) = (1/(1+depth))* input(i)*(1+depth*(sawtooth(2*pi*frequency_mod*i)));
    end

% Sygna� moduluj�cy - prostok�t
elseif shape == "SQU"
    for i = 1:length(input)
        output(i) = (1/(1+depth))* input(i)*(1+depth*(square(2*pi*frequency_mod*i)));
    end
    
% Sygna� moduluj�cy - cosinus
else
    for i = 1:length(input)
        output(i) = (1/(1+depth))* input(i)*(1+depth*(cos(2*pi*frequency_mod*i)));
    end
end





