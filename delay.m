%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt delay
%   Efekt symuluj�cy echo sygna�u poprzez dodanie do orygina�u sygna�u
%   op�nionego i st�umionego
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       delay- op�nienie sygna�u w ms
%       gain- przyrost sygna�u op�nionego wzgl�dem orygina�u
%       version - okre�la wersj� FIR lub IIR u�ywanego efektu
%   Opis dzia�ania:
%       Dodanie do obecnej pr�bki warto�ci pr�bki z przed "delayTime"
%       pr�bek temu, uwzgl�dniajac zysk sygna�u op�nionego do orygina�u.
%
%   Przyk�adowe wywo�anie
%       output = delay(sygnal_audio, 44100, 200, 0.5, 'FIR');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = delay(input, Fs, delay, gain, version)

delayTime = floor(delay*Fs/1000);
output = zeros(length(input), 1);

for i = 1:delayTime
    output(i) = input(i);
end

if(strcmp(version, 'FIR'))
    for i = delayTime+1:length(input)
        output(i) = (1/(1+gain))*(input(i) + gain*input(i-delayTime));
    end
else
    for i = delayTIme+1:length(signal)
        output(i) = (1/(1+gain))*(input(i) + gain*output(i-delayTime));
    end
end
