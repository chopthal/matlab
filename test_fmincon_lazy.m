% model: Rt = Rmax*A/(KD+A)*(1-exp(-Ka*t))

Rmax = 2;
KD = 2;
Ka = -3;
t = linspace(0,1);

% sim data 1
A = 1;
Rt1 = Rmax*A/(KD+A)*(1-exp(Ka*t)) + rand(size(t))*0.05;

% sim data 2
A = 2;
Rt2 = Rmax*A/(KD+A)*(1-exp(Ka*t)) + rand(size(t))*0.05;

% sim data 3
A = 3;
Rt3 = Rmax*A/(KD+A)*(1-exp(Ka*t)) + rand(size(t))*0.05;


figure, hold on,
plot(t, Rt1, 'r')
plot(t, Rt2, 'g')
plot(t, Rt3, 'b')


%% 여기부터는 Rmax, KD, Ka, A1, A2, A3는 unknown임
% t와 Rt1, Rt2, Rt3는 측정값임 (known)

fun1 = @(Rmax, KD, Ka, A1) Rmax*A1/(KD+A1)*(1-exp(Ka*t)) - Rt1; 
fun2 = @(Rmax, KD, Ka, A2) Rmax*A2/(KD+A2)*(1-exp(Ka*t)) - Rt2; 
fun3 = @(Rmax, KD, Ka, A3) Rmax*A3/(KD+A3)*(1-exp(Ka*t)) - Rt3; 

fun = @(x) ...
 sum((fun1(x(1), x(2), x(3), x(4))).^2) + ...
         sum((fun2(x(1), x(2), x(3), x(5))).^2) + ...
         sum((fun3(x(1), x(2), x(3), x(6))).^2);


x = fminsearch(fun, [1 1 -1 0 1 2]);

Rmax = x(1);
KD = x(2);
Ka = x(3);
A1 = x(4);
A2 = x(5);
A3 = x(6);

plot(t, Rmax*A1/(KD+A1)*(1-exp(Ka*t)), 'r--')
plot(t, Rmax*A2/(KD+A2)*(1-exp(Ka*t)), 'g--')
plot(t, Rmax*A3/(KD+A3)*(1-exp(Ka*t)), 'b--')