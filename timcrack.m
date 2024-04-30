% TIMCRACK
% A timcrack a TIM file-ok csatornaiban tarolt adatok kimenteset vegzi egy file-bol a masikba.
% Elotte alkalmazando a : timinfo.m
% Alkalmazas: 
%              timcrack(timfile, menteskezdet, sorokszama, idosor, fmint);
% 
% ahol, 
% timfile : a tordelendo fajl teljes eleresi utvonallal,                 pl:   'l:\Uni\Diploma\Adat\Mert\20040405\bme\data\unit5\TIMO45E4.003.5')
% menteskezdet : Az elso mentendo sor(/meresi pont)            pl.: 129
% sorokszama    : Az elmentendo sorok darabszama osszesen, pl.: 128
% idosor             : Azon fajl neve, amibe a kitordelt resz mentve lesz,  pl.: 'l:\Uni\Diploma\Adat\Kesz\20040405\A1.MAT'
% fmint               : A TIM*.*.* fajl elkeszitesekor alkalmazott mintavetelezesi frekvencia Hz-ben
% A program a 'TIM*.*.*-bol indul ki, ami 2 byte-os alakban tartalmazza a meresi adatokat egy header utan.
% A feldolgozas eredmenye elmentve : egy 'TIM' nevu tombvaltozo,
% IDO(tengely), sorszam, oszlopszam, fmint es a fuggveny lefuttatasahoz a parancssorba gepelt parancsok 
% 
function timcrack(timfile, menteskezdet, sorszam, idosor, fmint);
fid = fopen(timfile, 'rb');                                                           % Megnyitja a feldolgozando fajl-t
fseek(fid, 128, 'bof');                                                               % A header hosszat tartalmazo cimre ugrik
L = fread(fid, 1, 'int16');                                                           % Beolvassa a header hosszat
fprintf(['A header hossza   : ' num2str(L)          '\n']);                % Kiirja a header hosszat
fseek(fid, 134, 'bof');                                                                % A csatornak szamat tartalmazo cimre ugrik
oszlopszam = fread(fid, 1, 'int16');                                            % Beolvassa a csatornak szamat
fprintf(['Az oszlopok szama : ' num2str(oszlopszam) '\n']);
TIM = zeros(sorszam, oszlopszam);                                          % Lefoglalja a TIM fajl helyet
fprintf('A TIM csatornainak tombbe beolvasasa--------------\n');
for j = 1:oszlopszam                                                                  % Az index 1-tol a csatornak szamaig fut
    a = L+((menteskezdet-1)*2*oszlopszam)+(j-1)*2;                  % Kihagyja a header-t, a nem mentendo sorokat es csatornakat. A beolvasando csatorna elso beolvasando byte-janak helyet szamitja ki. 
    fseek(fid, a, 'bof');                                                                 % A beolvasando csatorna elso beolvasando byte-jahoz ugrik.
    for i = 1:sorszam                                                                    % A beolvasando TIM fajl sorszamait futja be
        TIM(i, j) = fread(fid, 1, 'int16', (oszlopszam-1)*2);              % A TIM tombbe olvassa be a meresi adatokat
    end
    fprintf([num2str(j) '.' 'oszlop kesz\n']);                                    % Kiirja, hogy hanyadik oszloppal vegzett
end
IDO = zeros(sorszam, 1);
dt = (1/fmint);
for i = 1:sorszam
    IDO(i, 1) = i*dt;
end
timarg = ['timcrack(' timfile ', ' num2str(menteskezdet) ', ' num2str(sorszam) ', ' idosor ', ' num2str(fmint) ');'];
save (idosor, 'TIM', 'IDO', 'sorszam', 'oszlopszam', 'fmint', 'dt', 'timarg') ; % Elmenti a kiolvasott adatokat
fprintf('----MENTES VEGE-----------------------------------\n');
fclose(fid);