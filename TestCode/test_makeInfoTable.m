Var1 = {
    'Immobilization';
    'Immobilization';
    'Immobilization';
    'Multi-cycle Kinetics';    
    'Multi-cycle Kinetics';    
    'Multi-cycle Kinetics';    
    'Multi-cycle Kinetics';    
    'Multi-cycle Kinetics';
    'Multi-cycle Kinetics(2)';
    'Multi-cycle Kinetics(2)';
    'Multi-cycle Kinetics(2)';
    'Multi-cycle Kinetics(2)';
    'Multi-cycle Kinetics(2)'};

Var2 = {'CA2';
    'CA2';
    'CA2';
    'Aceta';
    'Aceta';
    'Aceta';
    'Aceta';
    'Aceta';
    'Furo';
    'Furo';
    'Furo';
    'Furo';
    'Furo'};

Var3 = {'';
    '';
    '';
    '62.5';
    '125';
    '250';
    '500';
    '1000';
    '625';
    '1250';
    '2500';
    '5000';
    '10000'};

Var4 = {'nM';
    'nM';
    'nM';
    'nM';
    'nM';    
    'nM';
    'nM';
    'nM';
    'nM';
    'nM';
    'nM';
    'nM';
    'nM'};

Var5 = {'⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃';
    '⊃'};

Var6 = {'50';
    '50';
    '50';
    '50';    
    '50';
    '50';
    '50';
    '50';
    '50';
    '50';
    '50';
    '50';
    '50'};

Var7 = {'60';
    '60';
    '60';
    '60';
    '60';
    '60';
    '60';
    '60';
    '60';
    '60';
    '60';
    '60';
    '60'};

Var8 = cell(13, 1);
Var8(:) = {'300'};

Var11 = ones(13, 1) * 388;


ExpProc.TableData = table(Var1, Var2, Var3, Var4, Var5, Var6, Var7, Var8, Var11);
ExpProc.App = 'Multi-cycle Kinetics';

save('D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\iMSPR_ProA_SmallMolecule\2022-02-04 11-13-59\Info.mat', 'ExpProc')