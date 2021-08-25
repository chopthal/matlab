clear all

filename = 'C:\Users\tjckd\OneDrive\바탕 화면\icluebio\Kinetics\MultiKinetics\TestSet\Biacore2000_CMD200M_PA_IgG\50 nM IgG.txt';
dataTable = readtable(filename);

% filename2 = 'C:\Users\tjckd\OneDrive\바탕 화면\icluebio\Kinetics\MultiKinetics\TestSet\Biacore2000_CMD200M_PA_IgG\50 nM IgG_notitle.txt';
% dataTable2 = readtable(filename2);

ImportTest(dataTable)