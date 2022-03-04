LA + RI1 * $1 + RI2 * $2 + RI3 * $3 + RI4 * $4 + RI5 * $5 + (Drift * (t - ton1));

$1 = (sign(t - (ton1)) - sign(t - (ton1 + c_time))) / 2;
$2 = (sign(t - (ton2)) - sign(t - (ton2 + c_time))) / 2; 
$3 = (sign(t - (ton3)) - sign(t - (ton3 + c_time))) / 2; 
$4 = (sign(t - (ton4)) - sign(t - (ton4 + c_time))) / 2; 
$5 = (sign(t - (ton5)) - sign(t - (ton5 + c_time))) / 2; 

% Mass transfer (?)
$6 = kt * ($1 * conc / (F^4) + $2 * conc / (F^3) + $3 * conc / (F^2) + $4 * conc / (F) + $5 * conc - L);

% Diff eq
$7 = ka * L * A - kd * LA;

L = $6 - $7 | 0; 
A = -$7 | Rmax;
LA = $7 | 0;




function [X, Y] = ODESolve(k, xdata, pfuncAsso, pfuncDisso, eventTime, isMassTransfer, concentration, idxVar)

X = [];
Y = [];

Rmax = k(4);



injTime(1) = ((t-ton1) - (t-(ton1 + c_time))) / 2;
injTime(2) = ((t-ton2) - (t-(ton2 + c_time))) / 2;
injTime(3) = ((t-ton3) - (t-(ton3 + c_time))) / 2;
injTime(4) = ((t-ton4) - (t-(ton4 + c_time))) / 2;
injTime(5) = ((t-ton5) - (t-(ton5 + c_time))) / 2;



end

function dy = KineticTitration(t, y, k)

    kd = k(2);
    ka = k(3);
    dy = zeros(3, 1);

    dy(1) = 0;
    dy(2) = -ka*C*y(2) + kd*y(3); % B
    dy(3) = ka *C*y(2) - kd*y(3); % AB

end