function u=systemeqv(a,b)
r =1;
for j=1:b,r = r *rand;end;
u=-a*(log(r));
return;