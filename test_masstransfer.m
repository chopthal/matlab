%% Without mass transfer
% Use R(t)
% Association phase
% syms R(t) ka A Rmax kd
% 
% ode = diff(R,t) == ka*A*Rmax - R*(ka*A-kd);
% cond = R(0) == 0;
% ySol = dsolve(ode, cond);
% disp(ySol)
% 
% % Dissociation phase (C1 = R(0))
% syms R(t) kd
% 
% ode = diff(R, t) == -kd*R;
% ySol = dsolve(ode);
% disp(ySol)

% From rate eq
% Rmax = 78.22;
% sol = ode15s(@func,[0 200],[Rmax;0]);
% figure
% plot(sol.x, sol.y(2, :))
% 
% function dy=func(t,y)
%     ka = 2.04*10^6;
%     kd = 2.95*10^(-3);
%     kt = 2.01*10^8;
%     C = 32*10^(-9);
%     dy=zeros(2,1);
% %     y = zeros(2,1);    
%     dy(1)= -ka*C*y(1)+kd*y(2); % B
%     dy(2)= ka*C*y(1)-kd*y(2); % AB
% end


%% with mass transfer
% From rate eq
tAssoEnd = 120;
tDissoEnd = 500;
Rmax = 62.85;
sol = ode15s(@func,[0 tAssoEnd],[0;Rmax;0]);
figure(1);
cla;
plot(sol.x, sol.y(3, :))

sol = ode15s(@func2, [tAssoEnd+1 tDissoEnd], [0;Rmax;sol.y(3, end)]);
figure(1);
hold on;
plot(sol.x, sol.y(3, :))

function dy = func(t,y)
    ka = 2.04*10^6;
    kd = 2.95*10^(-3);
    kt = 2.01*10^8;
    C = 16*10^(-9);
    dy = zeros(3,1);
    
    dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) = ka *y(1)*y(2) - kd*y(3); % AB
end

function dy = func2(t,y)
    ka = 2.04*10^6;
    kd = 2.95*10^(-3);
    kt = 2.01*10^8;
    C = 16*10^(-9);
    dy = zeros(3,1);
    
    dy(1) = 0;
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) = ka *y(1)*y(2) - kd*y(3); % AB
end

% Dissociation
