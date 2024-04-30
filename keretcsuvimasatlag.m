%KERETCSUVIMASATLAG
% 
% Celja az idosor2csdcohpha.m segitsegevel CPSD-k, COH-, PHA-k eloallitasa
% Az idosor2csdcohpha.m a Matlab belso fuggvenyeivel dolgozik
% 
% Alkalmazas:
%                       keretcsuvimasatlag(path, idosor, NFFT, Fs, WINDOW, ablak, NOVERLAP, cpsdcomment);
%
% path    : A TIM eleresi utvonala fajlnevmentesen
% idosor : A TIM fajl neve '.MAT' mentesen
% NFFT  : A DFT hossza
% Fs : Mintavetelezesi frekvencia
% WINDOW : A sulyozofuggveny (ablak) pl : HANNING(131072)
% ablak : A WINDOW stingkent megadva
% NOVERLAP : Az atlapolas minta elemszamaban megadva
% cpsdcomment : Komment
% 
% Bemenete a TIM idosor
% Kimenete a CPSD, COH, PHA kulon fajlokban elmentve
%
function keretcsuvimasatlag(path, idosor, NFFT, Fs, WINDOW, ablak, NOVERLAP, cpsdcomment);
s = [path idosor '.MAT'];
load(s,'sorszam', 'oszlopszam');
fprintf ('\n');
fprintf ('CPSD-COH-PHA SZAMITAS--------------------------+\n');
for xindex = 1:oszlopszam
    for yindex = xindex:oszlopszam
        idosor2csdcohpha(path, idosor, xindex, yindex, NFFT, Fs, WINDOW, ablak, NOVERLAP, cpsdcomment);
    end
end
fprintf ('FINISHED----------------------------------------+\n');