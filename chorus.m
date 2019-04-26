%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt chorus
%   Efekt chorus (brzmienia ch�ralnego) sygna�u d�wi�kowego
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       delay- bazowa warto�� op�znienia sygna�u
%       rate_1, rate_2- cz�stotliwo�� "przemiatania" sygna�u oscylatorem 
%       LFO (pierwszego oraz drugiego)
%       depth_1, depth_2- amplituda sygna�u moduluj�cego obu oscylator�w
%       wzgl�dem sygna�u wej�ciowego
%       version- wersja efektu FIR lub IIR
%   Opis dzialania:
%       Struktura podobna do struktury efektu flanger. Na sygna� nak�adane
%       s� dwa lekko op�nione i zmodulowane sygna�y, czego efektem jest 
%       charakterystyczne "ch�ralne" brzmienie d�wi�ku. Cz�stotliwo��
%       sygna��w moduluj�cych powinna by� w granicach (0.1-0.5Hz).
%       Amplitudy tych sygna��w wzgl�dem sygna�u oryginalnego mog� by�
%       modyfikowane.
%       
%   Przyk�adowe wywo�anie
%       output = chorus(sygna�_audio, 44100, 15, 0.1, 0.5, 0.2, 0.3 'FIR');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = chorus(input, Fs, delay, rate_1, depth_1, rate_2, depth_2, version)

max_delay = floor(delay*Fs/1000);

frequency_change_1= rate_1/Fs;
frequency_change_2= rate_2/Fs;

output = zeros(length(input),1);

for i = 1:max_delay
    output(i) = input(i);
end

if(strcmp(version,'FIR'))
    for i = max_delay:length(input)
        delayTime_1 = 1 + round(max_delay/2*(1-cos(2*pi*frequency_change_1*i)));
        delayTime_2 = 1 + round(max_delay/2*(1-cos(2*pi*frequency_change_2*i)));
        output(i) =1/((1+depth_1+depth_2))* (input(i) + depth_1*input(i-delayTime_1) + depth_2*input(i-delayTime_2));
    end
else
     for i = max_delay:length(input)
         delayTime_1 = 1 + round(max_delay/2*(1-cos(2*pi*frequency_change_1*i)));
         delayTime_2 = 1 + round(max_delay/2*(1-cos(2*pi*frequency_change_2*i)));
        output(i) = 1/((1+depth_1+depth_2))*(input(i) + depth_1*output(i-delayTime_1) + depth_2*output(i-delayTime_2));
     end
end
