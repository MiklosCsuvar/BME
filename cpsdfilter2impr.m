%CPSDFILTER2IMPR
% 
% Ez a program a CPSD-k adott tartomanyanak kinullazasara szolgal tisztabb CCF eloallitasa celjabol.
% Beolvassa a CPSD-t, majd a fuggveny argumentumaban megadott frekvenciak kozotti CPSD-ket a COH-val sulyozza.
% Ezt kovetoen a CPSD-böl IFFT-vel CCF-et szamol.
% bemenet olyan CPSD fajl, amely a CPSD-t, a COH-t, a F (frekvenciat)-t es a PHA (fazis)-t  tartalmazza.
% 
% Alkalmazasa:
%                      cpsdfilter2impr(path, cpsdfile, lowerfreq, upperfreq, comment);
% 
% path         : A CPSD fajl fajlnevmentes eleresi utvonala
% cpsdfile     : A CPSD fajl neve kiterjesztes es indexek nelkul
% xindex : Az X csatorna indexe
% yindex : Az Y csatorna indexe
% cpsdcomment : A CPSD fajl nevebe fuzott komment
% cpsdfcomment : A CPSDF fajl nevebe fuzott komment
% lowerfrek  : Az also frekvenciahatar, ami alatt a CPSD-t ki kell nullazni
% upperfreq : A felso frekvenciahatar, ami feltt a CPSD-t ki kell nullazni
% comment  : Komment
% 
function cpsdfilter2impr(path, cpsdfile, xindex, yindex, cpsdcomment, cpsdfcomment, imprcomment);
% function cpsdfilter2impr(path, cpsdfile, xindex, yindex, cpsdcomment, cpsdfcomment, lowerfreq, upperfreq, imprcomment);
cpsdhely = [path cpsdfile 'CPSD' cpsdcomment num2str(10*xindex+yindex) cpsdfcomment '.MAT'];
cpsdhely
apsdhely = [path cpsdfile 'CPSD' cpsdcomment num2str(10*xindex+xindex) cpsdfcomment '.MAT'];
apsdhely
load(apsdhely, 'CPSD', 'idosor2csdcohphaarg', 'sorszam', 'CPSDM');
arg1 = idosor2csdcohphaarg;
APSD = CPSD;
% APSD((14:18), 1)
APSDM = CPSDM;
fprintf(['Az APSD fajl betoltve\n']);
load(cpsdhely, 'CPSD', 'F', 'idosor2csdcohphaarg', 'timarg', 'alsoindex', 'felsoindex', 'oszlopszam', 'sorszam', 'CPSDM');
% CPSD((14:18), 1)
arg2 = idosor2csdcohphaarg;
fprintf(['A  CPSD fajl betoltve\n']);
fprintf(['A  sorszam (CPSD hossza) : ' num2str(sorszam) '\n']);
% A CCF kiszamitasa
% CCF = zeros(sorszam, 1);
CCF = fftshift(ifft(CPSD));
% CCFM = zeros(2*sorszam-1, 1);
CCFM = fftshift(ifft(CPSDM));
% Az IMPR kiszamitasa
CPSDAPSD  = zeros(sorszam, 1);
CPSDAPSDM = zeros(2*sorszam-1, 1);
% % felsoindex
% % alsoindex
% % sorszam
% % length(CCF)
% % length(CPSD)
% % length(APSD)
% % length(CPSDAPSD)
fprintf(['Az also  index : ' num2str(alsoindex)                 '\n']);
fprintf(['Az felso index : ' num2str(felsoindex)                '\n']);
for i = alsoindex:felsoindex
%     i
    w = sorszam+(i-1);
    z = sorszam-(i-1);
%     CPSD(i, 1)
%     APSD(i, 1)
%     CPSDM(w, 1)
%     CPSDM(z, 1)
%     APSDM(w, 1)
%     APSDM(z, 1)
    CPSDAPSD(i, 1) = CPSD(i, 1)/APSD(i, 1);
    CPSDAPSDM(w, 1) = CPSDM(w, 1)/APSDM(w, 1);
    CPSDAPSDM(z, 1) = CPSDM(z, 1)/APSDM(z, 1);
end
IMPR = fftshift(ifft(CPSDAPSD));
IMPRM = fftshift(ifft(CPSDAPSDM));
fprintf(['Az IMPR kiszamitasa kesz----------------------------\n']);
fprintf(['Az idotengely szamitasa folyamatban--------------\n']);
fprintf(['Sorszam :' num2str(sorszam) '\n']);
if rem(sorszam, 2)
    hatar = (sorszam+1)/2;
else
    hatar = (sorszam/2)+1;
end
fprintf(['Hatar :' num2str(hatar) '\n']);
df = F(2, 1) - F(1, 1);
fprintf(['A frekvenciafelbontas :' num2str(df) '---------------\n']);
dt = 1/(2*sorszam*df);
fprintf(['Az idofelbontas :' num2str(dt) '-----------------------\n']);
IDO = zeros(sorszam, 1);
for i = 1:sorszam
    IDO(i, 1) = (i-hatar)*dt;
end
fprintf(['Az elso idotengely kesz--------------------------------\n']);
% if rem(2*sorszam-1, 2)
%     hatar = ((2*sorszam-1)+1)/2;
% else
%     hatar = ((2*sorszam-1)/2)+1;
% end
% fprintf(['Hatar :' num2str(hatar) '\n']);
fprintf(['Sorszam :' num2str(sorszam) '\n']);
IDOM = zeros(2*sorszam-1, 1);
for i = 1:sorszam
%     i
    v = i-1;
    IDOM(sorszam-v, 1) = -v*dt;
    IDOM(sorszam+v, 1) = v*dt;
end
fprintf(['Az masodik idotengely kesz---------------------------\n']);
fprintf(['Az idotengely kiszamitva-------------------------------\n']);
imprhely = [path cpsdfile 'CPSD' num2str(10*xindex+yindex) cpsdcomment cpsdfcomment 'IMPR' imprcomment '.MAT'];
cpsd2ccfimprarg = ['cpsdfilter2impr(' path ', ' cpsdfile ', ' num2str(xindex) ', ' num2str(yindex) ', ' cpsdcomment ', ' cpsdfcomment ', ' imprcomment ');'];
save(imprhely, 'IMPR', 'CCF', 'IDO', 'dt', 'sorszam', 'oszlopszam', 'cpsd2ccfimprarg', 'idosor2csdcohphaarg', 'timarg', 'IMPRM', 'CCFM', 'IDOM');
fprintf(['Az IMPR es az idotengely elmentve------------------\n']);