%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Efekt reverb
%   Efekt symuluj�cy pog�os sygna�u wynikaj�cy z propagacji fali
%   akustycznej w zamkni�tej przestrzeni/pomieszczeniu.
%   Parametry:
%       input- sygna� wej�ciowy (podany w pr�bkach)
%       Fs- cz�stotliwo�� pr�bkowania sygna�u oryginalnego 
%       room_size- rozmiar pomieszczenia, czyli ilo�� generowanego pog�osu 
%       depth- intensywno�� generowanego pog�osu 
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
function output = reverb(input, Fs, room_size, depth, pre_delay1, pre_delay2)

% Warto�ci op�nie� filtr�w grzebieniowych
D1 = round(0.001*room_size*Fs);
D2 = round(0.001*room_size*1.17*Fs);
D3 = round(0.001*room_size*1.33*Fs);
D4 = round(0.001*room_size*1.5*Fs);
% Warto�ci op�nie� filtr�w wszechpzepustowych
D5 = round(0.001*pre_delay1*Fs);
D6 = round(0.001*pre_delay2*Fs);

% Warto�ci wsp�czynnik�w filtr�w grzebieniowych
a1 = depth;
a2 = depth;
a3 = depth;
a4 = depth;
% Warto�ci wsp�czynnik�w filtr�w wszechprzepustowych
a5 = 0.7;
a6 = 0.7;

comb1_out = zeros(length(input),1);
comb2_out = zeros(length(input),1);
comb3_out = zeros(length(input),1);
comb4_out = zeros(length(input),1);
allpass1_out = zeros(length(input),1);
comb_sect_out = zeros(length(input),1);

output = zeros(length(input), 1);

for i = max([D1,D2,D3,D4,D5,D6])+1:length(input)
    
    % Sygna�y wyj�ciowe poszczeg�lnych filtr�w grzebieniowych
    comb1_out(i) = input(i) + a1*comb1_out(i-D1);
    comb2_out(i) = input(i) + a2*comb2_out(i-D2);
    comb3_out(i) = input(i) + a3*comb3_out(i-D3);
    comb4_out(i) = input(i) + a4*comb4_out(i-D4);
    
    % Suma sygna��w z filtr�w grzebieniowych
    comb_sect_out(i) = comb1_out(i) + comb2_out(i) + comb3_out(i) + comb4_out(i);
    
    % Sygna� wyj�ciowy pierwszego stopnia filtru wszechprzepustowego
    allpass1_out(i) = -a5*comb_sect_out(i)+comb_sect_out(i-D5)+a5*allpass1_out(i-D5);
    
    % Sygna� wyj�ciowy drugiego stopnia filtru wszechprzepustowego
    output(i) = (-a6*allpass1_out(i)+allpass1_out(i-D6)+a6*output(i-D6));
end
% Przeskalowanie pr�bek sygna�u do zakresu <-1; 1>
output = output/max(abs(output));

end
