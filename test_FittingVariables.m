boundScale = 10000;
koff = ones(1, size(concentration, 1)) * 10^(-4);
kon = ones(1, size(concentration, 1)) * 10^4;
Rmax = ones(1, size(concentration, 1));
if max(rmaxCandidate)>0; Rmax = Rmax * max(rmaxCandidate); end
BI = zeros(1, size(concentration, 1));

fittingVariables.Name = {'koff';   'kon';    'Rmax';   'BI'};
fittingVariables.Type = {'Global'; 'Global'; 'Global'; 'Local'};
fittingVariables.InitialValue = cell(length(fittingVariables.Type), 1);
fittingVariables.UpperBound = cell(length(fittingVariables.Type), 1);
fittingVariables.LowerBound = cell(length(fittingVariables.Type), 1);

fittingVariables.InitialValue{1, 1} = koff;
fittingVariables.InitialValue{2, 1} = kon;
fittingVariables.InitialValue{3, 1} = Rmax;
fittingVariables.InitialValue{4, 1} = BI;

fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * boundScale;
fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * boundScale;
fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * boundScale;
fittingVariables.UpperBound{4, 1} = inf(size(fittingVariables.InitialValue{4, 1}));

fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / boundScale;
fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / boundScale;
fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / boundScale;
fittingVariables.LowerBound{4, 1} = -inf(size(fittingVariables.InitialValue{4, 1}));