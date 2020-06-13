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
function output = chorus(input, fs, delay, rate_1, depth_1, rate_2, depth_2, version)

% Obliczenie liczby probek opoznienia sygnalu audio
max_delay = floor(delay*fs/1000);

% Obliczenie cz�stotliwo�ci unormowanych sygna��w moduluj�cych
frequency_change1= rate_1/fs;
frequency_change2= rate_2/fs;

output = input(:, 1);
n = max_delay+1:length(input);
delay_time1 = floor(max_delay*abs(sin(2*pi*frequency_change1*n)));
delay_time2 = floor(max_delay*abs(sin(2*pi*frequency_change2*n)));

if(strcmp(version,'FIR'))
    % Realizacja efektu Chorus w wersji SOI 
    output(n) =1/((1+depth_1+depth_2))* (input(n, 1) + depth_1*input(n-delay_time1, 1) + depth_2*input(n-delay_time2, 1));
    
else
     for n = max_delay+1:length(input)
         % Realizacja efektu Chorus w wersji NOI 
        output(n) = 1/((1+depth_1+depth_2))*(input(n, 1) + depth_1*output(n-delay_time1(n-max_delay)) + depth_2*output(n-delay_time2(n-max_delay)));
     end
end
