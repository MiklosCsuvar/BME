%CPSDFILTERRUN
%
%Alkalmazasa:
%                         cpsdfilterrun(path, idosor, cpsdcomment, lowerfreq, upperfreq, cpsdfcomment);
% 
function cpsdfilterrun(path, idosor, cpsdcomment, lowerfreq, upperfreq, cpsdfcomment);
s = [path idosor '.MAT'];
load(s, 'oszlopszam');
for i = 1:oszlopszam
    for j = i:oszlopszam
        cpsdfile = [idosor 'CPSD' num2str(10*i+j)];
        cpsdfilter(path, cpsdfile, cpsdcomment, lowerfreq, upperfreq, cpsdfcomment);
    end
end