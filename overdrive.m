%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt overdrive
%   Efekt przesterowania sygna�u audio
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       clip_value- pr�g przesterowywania sygnalu
%   Opis dzia�ania:
%       Zmiana warto�ci pr�bki do opisanej algorytmem warto�ci w zale�no�ci
%       od poziomu tej�e pr�bki
%
%   Przyk�adowe wywo�anie
%       output = overdrive(sygnal_audio, 44100, 0.05);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = overdrive(input, clip_value)

output = input(:, 1);

% Realizacja obci�cia sygna�u w zale�no�ci od poziomu amplitudy
for n = 1:length(input)
    switch true
        case input(n) <= -(2/3)*clip_value
            output(n) = -clip_value;
        case input(n) <= -(1/3)*clip_value
            output(n) = clip_value*(-3+(2+3*input(n)/clip_value)^2)/3;
        case abs(input(n)) <= (1/3)*clip_value
            output(n) = 2*input(n);
        case input(n) <= (2/3)*clip_value
            output(n) = clip_value*(3-(2-3*input(n)/clip_value)^2)/3;
        otherwise
            output(n) = clip_value;
    end
end