function Xprob = probX(x, Om, Oc)

Xprob = (1/sqrt(((2*pi).^3)*det(Oc)))*exp((-1/2).*(transpose(x - Om)*inv(Oc)*(x - Om)));

end