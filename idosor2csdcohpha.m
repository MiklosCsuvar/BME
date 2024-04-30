%IDOSOR2CSDCOHPHA
% Kiszamolja a keresztspektrumot es a hozzajuk tartozo frekvenciakat.
% Alkalmazasa:
%               idosor2csdcohpha(path, idosor, xindex, yindex, NFFT, Fs, WINDOW, ablak, NOVERLAP, cpsdcomment);
% 
% path     : A fajlnevmentes eleresi utvonal
% idosor   : A TIM-fajlbol kivagott idosort atartalmazo fajl neve
% xindex   : Az X valtozot tartalmazo csatorna oszlopindexe
% yindex   : Az Y valtozot tartalmazo csatorna oszlopindexe
% NFFT     : A mintavetelezo jel ablaka
% Fs       : Mintavetelezesi frekvencia (Hz?)
% WINDOW   : Mintavetelezo ablak (HANNING, HAMMING, BARTLETT, ...)
% ablak         : A WINDOW stringent beirva 
% NOVERLAP : Az lapolas mereteke az atlapolodo pontok szamaval megadva
% cpsdcomment : A CPSD fajl neve veger szant komment
% 
% A Matlab belso fuggvenye a CSD csak az NFFT fele hosszu CPSD-t allit elo, csak a pozitiv tengelyt mutatja es orzi meg 
% A fuuggveny : 
% Bemenete a TIM idosor
% Kimenete a CPSD, COH, PHA, F, NFFT, Fs, WINDOW, NOVERLAP es a parancssorba irt utasitasok ugyanabban a  fajlban elmentve
%
function idosor2csdcohpha(path, idosor, xindex, yindex, NFFT, Fs, WINDOW, ablak, NOVERLAP, cpsdcomment);
idosorhelye = [path idosor '.MAT'];                                                   % Megadja asz idosor helyet
load(idosorhelye);                                                                            % Betolti a TIM-fajlbol kiszabott idosort
fprintf([num2str(10*xindex+yindex) '.' ' ' 'csatornapar feldolgozasa folyamatban\n']);
fprintf(['VIGYAZAT : a CSD csak a pozitiv tengelyfelet orzi meg\n']);
[COH,  F] = COHERE(TIM(:, xindex), TIM(:, yindex), NFFT, Fs, WINDOW, NOVERLAP);       % COH-t szamol
fprintf('COH       kesz\n');
[CPSD, F] =    CSD(TIM(:, xindex), TIM(:, yindex), NFFT, Fs, WINDOW, NOVERLAP);          % CPSD es frekvencia szamitas
sorszam = length(CPSD);
CPSDM = zeros(2*sorszam-1, 1);                                                          % Tukrozi a CSD elemeit a negativ tengelyre es konjugalja oket
FM = zeros(2*sorszam-1, 1);
for i = 1:sorszam
    v = i-1;
    w = sorszam+v;
    z = sorszam -v;
    CPSDM(w, 1) = CPSD(i, 1);
    CPSDM(z, 1) = conj(CPSD(i, 1));
    FM(w, 1) = F(i, 1);
    FM(z, 1) = -F(i, 1);
end
fprintf('CPSD      kesz\n');
fprintf('F             kesz\n');
PHA       = angle(CPSD);
fprintf('PHA        kesz\n');
CPSDfile = ['CPSD' num2str(10*xindex+yindex) cpsdcomment];                                      % A CPSD mentesehez kell  
CPSDhelye = [path idosor CPSDfile '.MAT'];                                                            % A CPSD helye 
idosor2csdcohphaarg = [ 'idosor2csdcohpha(' path ', ' idosor ', ' num2str(xindex) ', ' num2str(yindex) ', ' num2str(NFFT) ', ' num2str(Fs) ', ' ablak ', ' num2str(NOVERLAP) ', ' cpsdcomment ');'];
fprintf('----MENTES KEZDETE--------------------------------------------------------\n');
fprintf([num2str(10*xindex+yindex) '.' ' ' 'csatornapar mentese folyamatban\n']);
alsoindex  = 1;
felsoindex = sorszam;
normteny = 1;
save(CPSDhelye, 'CPSD', 'COH', 'PHA', 'F', 'NFFT', 'Fs', 'NOVERLAP', 'normteny', 'sorszam', 'oszlopszam', 'ablak', 'alsoindex', 'felsoindex', 'idosor2csdcohphaarg', 'timarg', 'CPSDM', 'FM');                                                              % Elmenti  a CPSD-t es a tobbi valtozot
fprintf(['CPSD lementve :' idosor 'CPSD' num2str(10*xindex+yindex) cpsdcomment '.MAT\n']);
fprintf('----MENTES VEGE-----------------------------------------------------------\n');
fprintf('\n');