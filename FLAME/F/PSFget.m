function  [output] = PSFget(pixel,sigma)
sigma_2 = [sigma sigma sigma];
psfsigma = sigma_2./pixel;
psfN = ceil(psfsigma./sqrt(8*log(2)) * sqrt(-2 * log(0.0002))) + 1;
psfN = psfN * 2 + 1;
output = Gauss(psfsigma,psfN);
end