%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt reverb
%   Efekt symuluj�cy pog�os sygna�u wynikaj�cy z propagacji fali
%   akustycznej w zamkni�tej przestrzeni/pomieszczeniu.
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       room_size- rozmiar pomieszczenia, czyli ilo�� generowanego pog�osu 
%       depth1- intensywno�� generowanego pog�osu (wsp�czynnik filtr�w
%       grzebieniowych)
%       depth2- intensywno�� generowanego pog�osu (wsp�czynnik filtr�w
%       wszechprzepustowych)
%       pre_delay1- pierwszy efekt wczesnego echa 
%       pre_delay2- drugi efekt wczesnego echa 
%   Opis dzia�ania:
%       Dzia�anie efektu oparte jest o dzia�anie filtru grzebieniowego,
%       zmodyfikowanego tak, aby posiada� p�ask� charakterystyk�
%       amplitudow�. Transformuje si� zatem uk�ad filtru celem otrzymania
%       uk�adu filtru wszechprzepustowego (celem uzyskania sprz�onych par
%       biegun�w charakterystyki cz�stotliwo�ciowej). Celem minimalizacji
%       wp�ywu efektu na barw� d�wi�k�w stosuje sie ��czenie filtr�w:
%       -grzebioneowych r�wnolegle(z okre�lonymi op�nieniami), aby uzyska� 
%       maksima ka�dego filtru sk�adowego w char. amplitudowej 
%       -wszechprzepustowe szeregowo, aby zwi�kszyc efekt echa bez wp�ywu
%       na char. amplitudow�.
%
%   Przyk�adowe wywo�anie
%       output = reverb(sygnal_audio, 44100, 30, 0.7, 3, 5);                                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = reverb(input, fs, room_size, depth1, depth2, pre_delay1, pre_delay2)

% Warto�ci op�nie� filtr�w grzebieniowych
D1 = round(room_size*fs/1000);
D2 = round(room_size*1.17*fs/1000);
D3 = round(room_size*1.33*fs/1000);
D4 = round(room_size*1.5*fs/1000);
% Warto�ci op�nie� filtr�w wszechpzepustowych
D5 = round(pre_delay1*fs/1000);
D6 = round(pre_delay2*fs/1000);

% Warto�ci wsp�czynnik�w filtr�w grzebieniowych
a1 = depth1;
a2 = depth1;
a3 = depth1;
a4 = depth1;
% Warto�ci wsp�czynnik�w filtr�w wszechprzepustowych
a5 = depth2;
a6 = depth2;

comb1_out = zeros(length(input), 1);
comb2_out = zeros(length(input), 1);
comb3_out = zeros(length(input), 1);
comb4_out = zeros(length(input), 1);
allpass1_out = zeros(length(input), 1);
comb_sect_out = zeros(length(input), 1);

output = input(:, 1);

for n = max([D1,D2,D3,D4,D5,D6])+1:length(input)
    
    % Sygna�y wyj�ciowe poszczeg�lnych filtr�w grzebieniowych
    comb1_out(n) = input(n, 1) + a1*comb1_out(n-D1);
    comb2_out(n) = input(n, 1) + a2*comb2_out(n-D2);
    comb3_out(n) = input(n, 1) + a3*comb3_out(n-D3);
    comb4_out(n) = input(n, 1) + a4*comb4_out(n-D4);
    
    % Suma sygna��w z filtr�w grzebieniowych
    comb_sect_out(n) = comb1_out(n) + comb2_out(n) + comb3_out(n) + comb4_out(n);
    
    % Sygna� wyj�ciowy pierwszego stopnia filtru wszechprzepustowego
    allpass1_out(n) = -a5*comb_sect_out(n)+comb_sect_out(n-D5)+a5*allpass1_out(n-D5);
    
    % Sygna� wyj�ciowy drugiego stopnia filtru wszechprzepustowego
    output(n) = (-a6*allpass1_out(n)+allpass1_out(n-D6)+a6*output(n-D6));
end
% Przeskalowanie pr�bek sygna�u do zakresu <-1; 1>
output = output/max(abs(output));

end
