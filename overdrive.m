%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt overdrive
%   Efekt przesterowania sygna�u audio
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       clipValue- pr�g przesterowywania sygnalu
%   Opis dzia�ania:
%       Zmiana warto�ci pr�bki do opisanej algorytmem warto�ci w zale�no�ci
%       od poziomu tej�e pr�bki
%
%   Przyk�adowe wywo�anie
%       output = overdrive(sygnal_audio, 44100, 0.05);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = overdrive(input, Fs, clipValue)

output = zeros(length(input), 1);

for i = 1:length(input)
    if ((input(i)) <= -(2/3)*clipValue)
        output(i) = -clipValue;
    else
        if (input(i) <= -(1/3)*clipValue)
            output(i) = clipValue*(-3+(2+3*input(i)/clipValue)^2)/3;
        else
            if (abs(input(i) <= (1/3)*clipValue))
                output(i) = 2*input(i);
            else
                if (input(i) <= (2/3)*clipValue)
                    output(i) = clipValue*(3-(2-3*input(i)/clipValue)^2)/3;
                else
                    output(i) = clipValue;
                end
            end
        end
    end
end
