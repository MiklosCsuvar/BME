%CPSDFILTER2IMPRRUN
% 
% Alkalmazasa:
% 
%                           cpsdfilter2imprrun(path, cpsdfile, cpsdcomment, cpsdfcomment, imprcomment);
% 
% path                 : Eleresi utvonal faljlnev nelkul
% cpsdfile            : A CPSD fajl neve indexek es egyebek nelkul
% csatornaszam  : A csatornak szama a TIM fajlban
% cpsdcomment  : A CPSD fajl neveben talalhato komment
% cpsdfcomment : A  filterezett CPSD fajl neveben talalhato komment
% lowerfreq         : Az also frekvenciahatar
% upperfreq        : A felso frekcivenciahatar
% comment         : Az IMPR vegere fuzendo komment
% 
% Bemenete egy CPSD fajlnev kezdete.
% Kimenete a CPSD fajllal es az APSD-kkel szamitott IMPR
% 
function cpsdfilter2imprrun(path, cpsdfile, cpsdcomment, cpsdfcomment, imprcomment);
s = [path cpsdfile 'CPSD' '11' cpsdcomment cpsdfcomment '.MAT'];
load(s, 'oszlopszam');
fprintf(['Oszlopszam :' num2str(oszlopszam)]);
for xindex = 1:oszlopszam
    for yindex = xindex:oszlopszam
%         cpsdfilter2impr(path, cpsdfile, xindex, yindex, cpsdcomment, cpsdfcomment, lowerfreq, upperfreq, imprcomment);
        cpsdfilter2impr(path, cpsdfile, xindex, yindex, cpsdcomment, cpsdfcomment, imprcomment);
    end
end