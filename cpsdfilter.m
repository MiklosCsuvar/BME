%CPSDFILTER
% 
% Ez a program a CPSD-k adott tartomanyanak kinullazasara szolgal tisztabb CCF es IMPR eloallitasa celjabol.
% Beolvassa a CPSD-t, majd a fuggveny argumentumaban megadott frekvenciak kozotti CPSD-ket a COH-val sulyozza.
% Az eredmenyt elmenti
% Bemenet olyan CPSD fajl, amely a CPSD-t, a COH-t, a F (frekvenciat)-t es a PHA (fazis)-t  tartalmazza.
% Kimenete : CPSD, sorszam, oszlopszam, F, COH, PHA, normteny, alsoindex, felsoindex, cpsdfilterarg
% Alkalmazasa:
%                        cpsdfilter(path, cpsdfile, cpsdcomment, lowerfreq, upperfreq, cpsdfcomment);
% 
% path                 : A CPSD fajl fajlnevmentes eleresi utvonala
% cpsdfile            : A CPSD fajl neve kiterjesztes nelkul
% cpsdcomment : A CPSD fajl indexei mogotti komment
% lowerfrek          : Az also frekvenciahatar, ami alatt a CPSD-t ki kell nullazni
% upperfreq         : A felso frekvenciahatar, ami feltt a CPSD-t ki kell nullazni
% cpsdfcomment  : A CCF fajl nevebe fuzendo komment
% 
function cpsdfilter(path, cpsdfile, cpsdcomment, lowerfreq, upperfreq, cpsdfcomment);
cpsdhely = [path cpsdfile cpsdcomment '.MAT'];                                                 % Meghatarozza a feldolgozando CPSD-fajlt
cpsdhely
load(cpsdhely);                                                                             % Betolti a feldolgozando CPSD-fajlt
fprintf(['A CPSD fajl betoltve\n']);
fprintf(['A CPSD sorszama            :' num2str(sorszam) '\n']);
fprintf(['A CPSD oszlopszama         :' num2str(oszlopszam) '\n']);
for i = 1:sorszam                                                                             % Meghatarozza a lowerfreq kriterium alapjan az also frekvenciahatar indexet
    if F(i, 1) <= lowerfreq
        alsoindex = i;
    else break                                                                                   % Miutan meghatarozta, kilep a for ciklusbol
    end
end
alsofrek = F(alsoindex, 1);
fprintf(['Az also hatarfrekvencia:' ' ' num2str(alsofrek) ' ' 'Hz' ' ' 'es sorszama az F-ben :' ' ' num2str(alsoindex) '\n']);
fprintf(['Az ezen frekvencia alatti elemeket kinullazza \n']);
for i = 1:sorszam                                                                               % Meghatarozza az upperfreq kriterium alapjan a felso frekvenciahatar indexet
    if F((sorszam+1-i), 1) >= upperfreq
        felsoindex = (sorszam+1-i);
    else break                                                                                     % Miutan meghatarozta, kilep a for ciklusbol
    end
end
felsofrek = F(felsoindex, 1);
fprintf(['A felso hatarfrekvencia:' ' ' num2str(felsofrek) 'Hz ' ' ' 'es sorszama az F-ben :' ' ' num2str(felsoindex) '\n']);
fprintf(['Az ezen frekvencia feletti elemeket kinullazza \n']);
fprintf(['A CPSD szures kezdete--------------------------\n']);
CPSDF = zeros(sorszam, 1);
CPSDMF = zeros(2*sorszam-1, 1);
% for i = 1:(alsoindex-1)                                                                          % Kinullazza az also frekvenciakorlat indexe alatti elemeket 
%     CPSDF(i, 1) = 0;
%     q = i-1;
%     CPSDMF(sorszam+q, 1) = 0;
%     CPSDMF(sorszam-q, 1) = 0;
% end
w = zeros((felsoindex-(alsoindex-1)), 1);                                              % A COH-val valo sulyozashoz vektort keszit
for i = alsoindex:felsoindex
    w(i, 1) = COH(i-(alsoindex-1), 1);
end
normteny = sum(w);                                                                               % A normalo tenyezo kiszamitasa
for i = alsoindex:felsoindex
    q = i-1;
    CPSDF(i, 1) = CPSD(i, 1)*COH(i, 1)/normteny;                                  % A kiszamitott normalasi tenyezo segitsegevel a COH-t felhasznalva sulyoz
    CPSDMF(sorszam+q, 1) = CPSD(i, 1)*COH(i, 1)/(normteny/2);
    CPSDMF(sorszam-q, 1) = conj(CPSD(i, 1))*COH(i, 1)/(normteny/2);
end
% for i = (felsoindex+1):sorszam                                                                 % Kinullazza a felso frekvenciakorlat indexe feletti elemeket 
%     CPSDF(i, 1) = 0;
%     CPSDMF(i, 1) = 0;
%     CPSDMF(sorszam-(i-1), 1) = 0;
% end
CPSD = CPSDF;
CPSDM = CPSDMF;
cpsdfhely = [path cpsdfile cpsdcomment cpsdfcomment '.MAT'];
cpsdfilterarg = [ 'idosor2csdcohphaarg' ' ' 'cpsdfilter(' path ', ' cpsdfile ', ' cpsdcomment ', ' num2str(lowerfreq) ', ' num2str(upperfreq) ', ' cpsdfcomment ');'];
idosor2csdcohphaarg = cpsdfilterarg;
save(cpsdfhely, 'CPSD', 'sorszam', 'oszlopszam', 'F', 'COH', 'PHA', 'normteny', 'alsoindex', 'felsoindex', 'idosor2csdcohphaarg', 'timarg', 'NFFT', 'ablak', 'Fs', 'NOVERLAP', 'CPSDM', 'FM');                       
fprintf(['A CCF es az idotengely elmentve------------------\n']);