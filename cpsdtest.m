load('L:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\UZEM1.MAT', 'TIM');
x = TIM((1:131072), 1);
y = zeros(131072, 1);
k = 32;
for i = 1:k
    y(i, 1) = 0;
end
for i = k+1:131072
    y(i, 1) = x(i-k, 1);
end
% PHA, CCF es IMPR kiszamitasa a definiciok alapjan - FFT-k szorzasaval
X = fft(x);                                                                                       % A valtozok Fourier-transzformalasa
Y = fft(y);
CPSD = zeros(131072, 1);                                                            % A memoria lefoglalasa 
APSD = zeros(131072, 1);
APSDCPSD = zeros(131072, 1);
IDO = zeros(131072, 1);
F = zeros(131072, 1);
for i = 1:131072                                                                             % Spektrumok, ido, frekvencia kiszamitasa 
    CPSD(i, 1) = conj(X(i, 1))*Y(i, 1);
    APSD(i, 1) = conj(X(i, 1))*X(i, 1);
    IDO(i, 1) = (i-65536)/2000;
    APSDCPSD(i, 1) = CPSD(i, 1)/APSD(i, 1);
    F(i, 1) =  2*(i-65536)*(2000/(2*131072));
end
PHA = angle(CPSD);
CCF=fftshift(ifft(CPSD));
IMPR = fftshift(ifft(APSDCPSD));
% PHA, CCF es IMPR kiszamitasa a Matlab CSD f�ggv�nye alapjan 
[PXY,FCSD] = CSD(x,y,131072,2000,RECTWIN(131072),0);
[PXX,FCSD] = CSD(x,x,131072,2000,RECTWIN(131072),0);
s = length(PXY);
IMPRPSD = zeros(s, 1);
for i = 1:s
    IMPRPSD(i, 1) = PXY(i, 1)/PXX(i, 1);
end
IMPRCSD = fftshift(ifft(IMPRPSD));
CCFCSD = fftshift(ifft(PXY));
PHACSD = angle(PXY);
b = length(IMPRCSD);
 if rem(b, 2)
    hatar = (b+1)/2;
else
    hatar = (b/2)+1;
end
hatar
dfcsd = F(2, 1) - F(1, 1);
dtcsd = 2*1/(2*b*dfcsd);
IDOCSD = zeros(b, 1);
for i = 1:b
    IDOCSD(i, 1) = (i-hatar)*dtcsd;
end
% PHA, CCF es IMPR kiszamitasa a CSD alapjan kepzett spektrum konjugalasos tukrozesevel
[PXYM,FM] = CSD(x,y,131072,2000,RECTWIN(131072),0);
[PXXM,FM] = CSD(x,x,131072,2000,RECTWIN(131072),0);
sorszam = length(PXYM);
CPSDM = zeros(2*sorszam-1, 1);                                                          % Tukrozi a CSD elemeit a negativ tengelyre es konjugalja oket
APSDM = zeros(2*sorszam-1, 1);
FMN = zeros(2*sorszam-1, 1);
IDOM = zeros(2*sorszam-1, 1);
dfm = FM(2, 1)-FM(1, 1);
dtm = 1/(2*(2*sorszam-1)*dfm);
for i = 1:sorszam
    v = i-1;
    w = sorszam+v;
    z = sorszam-v;
    APSDM(w, 1) = PXXM(i, 1);
    APSDM(z, 1) = conj(PXXM(i, 1));
    CPSDM(w, 1) = PXYM(i, 1);
    CPSDM(z, 1) = conj(PXYM(i, 1));
    FMN(w, 1) = FM(i, 1);
    FMN(z, 1) = -FM(i, 1);
    IDOM(w, 1) = v*dtm;
    IDOM(z, 1) = -v*dtm;
end
IMPRPSDM = zeros(2*sorszam-1, 1);
for i = 1:(2*sorszam-1)
   IMPRPSDM(i, 1) = CPSDM(i, 1)/APSDM(i, 1);
end
CCFM = fftshift(ifft(CPSDM));
IMPRM = fftshift(ifft(IMPRPSDM));
PHAM = angle(CPSDM);
% Eredmenyek abrazolasa
% % % Definicio alapjan
% figure
% plot(IDO, abs(CCF)); xlabel('t (s)'); ylabel('CCF MAG'); title('CCF defin�ci� alapj�n');
% figure
% semilogy(IDO, abs(IMPR)); xlabel('t (s)'); ylabel('IMPR MAG'); title('IMPR defin�ci� alapj�n');
% figure
% plot(F, PHA); xlabel('f (Hz)'); ylabel('PHA (rad)'); title('PHA defin�ci� alapj�n');
% % % CSD alapjan
% figure
% plot(IDOCSD, abs(CCFCSD)); xlabel('t (s)'); ylabel('CCF MAG'); title('CCF CSD alapj�n');
% figure
% semilogy(IDOCSD, abs(IMPRCSD)); xlabel('t (s)'); ylabel('IMPR MAG'); title('IMPR CSD alapj�n');
% figure
% plot(FCSD, PHACSD); xlabel('f (Hz)'); ylabel('PHA (rad)'); title('PHA CSD alapj�n');
% % CSD tukrozessel
% figure
% plot(IDOM, abs(CCFM)); xlabel('t (s)'); ylabel('CCF MAG'); title('CCF tukrozessel');
% figure
% semilogy(IDOM, abs(IMPRM)); xlabel('t (s)'); ylabel('CCF MAG'); title('IMPR tukrozessel');
% figure
% plot(FMN, PHAM); xlabel('f (Hz)'); ylabel('PHA (rad)'); title('PHA tukrozessel');