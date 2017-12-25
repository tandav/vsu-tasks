

clear all;
nf=2;
minf=[2 3];
maxf=[5 5];
%формирование дробного двухуровневого плана эксперимента
%для учета взаимодействий
fracfact('a b ab');
N=2^nf;
fracplan=ans
fictfact=ones(N,1);
X=[fictfact ans]'
fraceks=zeros(N,nf);
for i=1:nf,
    for j=1:N,
fraceks(j,i)=minf(i)+(fracplan(j,i)+1)*(maxf(i)-minf(i))/2;
end;
end;
fraceks
%тактическое планирование эксперимента
%задание доверительного интервала и уровня значимости
d_sigma=0.15;
alpha=0.03;
%определение t-критического
tkr_alpha=norminv(1 - alpha/2);
%определение требуемого числа испытаний
NE=round(1 + 2*tkr_alpha^2 / d_sigma^2);
%цикл по совокупности экспериментов стратегического плана
for j=1:N,
    a=fraceks(j,1); 
    b=fraceks(j,2);
    %цикл статистических испытаний
    for k=1:NE,
        %имитация функционирования системы
        u(k)=systemeqv(a,b);
    end;
    %оценка параметров (реакции) по выборке наблюдений
        mx=mean(u);
%         DX=std(u)^2;
        DX = var(u)
    Y(j)=DX;
    %формирование и отображение гистограммы с 12-ю интервалами
%     figure;
    %hist(u,12);
end;
%определение коэффициентов регрессии
C=X*X';
b_=inv(C)*X*Y'
%формирование зависимости реакции системы на множестве
%значений факторов
A=minf(1):0.1:maxf(1);
B=minf(2):0.1:maxf(2);
[k N1]=size(A)
[k N2]=size(B)
for i=1:N1,
    for j=1:N2,
        an(i)=2*(A(i)-minf(1))/(maxf(1)-minf(1))-1;
        bn(j)=2*(B(j)-minf(2))/(maxf(2)-minf(2))-1;
        %экспериментальная поверхность реакции
    Yc(j,i)=b_(1)+an(i)*b_(2)+bn(j)*b_(3)+an(i)*bn(j)*b_(4);
end;
end;

for i=1:N1,
    for j=1:N2,
        %реальная поверхность реакции
           %Yo(j,i)=(A(i)^2)*exp(B(j)^2)*(exp(B(j)^2)-1);
           Yo(j,i)=A(i)^2*B(j);

end;
end;
% отобрабражение зависимостей в трехмерной графике 
[x,y]=meshgrid(A,B);
figure;
subplot(1,2,1),plot3(x,y,Yc),
xlabel('fact a'),
ylabel('fact b'),
zlabel('Yc'),
title('System output'),
grid on,
subplot(1,2,2),plot3(x,y,Yo),
xlabel('fact a'),
ylabel('fact b'),
zlabel('Yo'),
title('System output'),
grid on;

