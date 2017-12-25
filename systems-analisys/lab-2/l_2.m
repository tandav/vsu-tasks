clear all;

Ts=0.001;

Ns=10000;

mr=0.001;

nf=2;

minf=[0.0005 1];

maxf=[0.05 8];

fracfact('a b ab' );

N=2^nf;

fracplan=ans;

fictfact=ones(N,1);

X=[fictfact ans]';

fraceks=zeros(N,nf);

for i=1:nf,

    for j=1:N,

fraceks(j,i)=minf(i)+(fracplan(j,i)+1)*(maxf(i)-minf(i))/2;

end;

end;

fraceks

dp=0.1;

alpha=0.2;

tkr_alpha=norminv(1-alpha/2);

NE=round(tkr_alpha^2/(4*dp^2)) 

for j=1:N,

    a=fraceks(j,1); 

    b=fraceks(j,2);

    NP=a

    R=b

    uo=zeros(NE,1);

    u1=zeros(NE,1);

    for k=1:NE,

to=randseed;

sim('trenl',Ts*Ns);

u1(k)=sum(simout1); 

    end;

    P_O=nanstd(u1);

    Y(j)=P_O;

end;

C=X*X';

b_=inv(C)*X*Y'

A=minf(1):0.01:maxf(1);

B=minf(2):0.1:maxf(2);

[k N1]=size(A);

[k N2]=size(B);

for i=1:N1,

    for j=1:N2,

        an(i)=2*(A(i)-minf(1))/(maxf(1)-minf(1))-1;

        bn(j)=2*(B(j)-minf(2))/(maxf(2)-minf(2))-1;

     Yc(j,i)=b_(1)+an(i)*b_(2)+bn(j)*b_(3)+an(i)*bn(j)*b_(4);

end;

end;

[x,y]=meshgrid(A,B);

figure;

subplot(1,2,1),plot3(x,y,Yc),

xlabel('fact R'),

ylabel('fact NP'),

zlabel('Yc'),

title('PO'),

grid on,

% 
% R - ????????? ?? ?????????
% mr - ???????????